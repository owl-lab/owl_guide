Automated Empirical Optimisation of Parameters in Owl
=====================================================

by Jianxin Zhao


Recent research on *parameter tuning* mostly focus on hyper-parameter tuning, such as optimising the parameters of stochastic gradient in machine learning applications.
However, tuning code and parameters in low-level numerical libraries is of the same importance.
For example, `ATLAS <http://math-atlas.sourceforge.net/>`_ and the recent `Intel Math Kernel Library (MKL) <https://software.intel.com/mkl>`_ are both software libraries of optimised math routines for science and engineering computation.
They are widely used in many popular high-level platforms such as Matlab and  TensorFlow.
One of the reasons these libraries can provide optimal performance is that they have adopted the paradigm of Automated Empirical Optimisation of Software, or AEOS.
That is, a library chooses the best method and parameter to use on a given platform to do a required operation.
One highly optimised routine may run much faster than a naively coded one.
Naturally, optimised code is usually platform- and hardware-specific. An optimised routine on one machine usually performs bad on the other.

Though `Owl <http://ocaml.xyz/>`_  currently does not plan to improve the low-level libraries it depends on, as an initial endeavour to apply the AEOS paradigm in Owl, one ideal tuning point is the parameters of OpenMP used in Owl.


Use OpenMP to boost computation
-----------------------------------------------------

Currently many computers contain shared memory multiprocessors.
`OpenMP <https://www.openmp.org/>`_ is an application programming interface that supports multi-platform shared memory multiprocessing programming in C or Fortran, supported on a plethora of hardware and software platforms.
It is used in key operations in libraries such as Eigen and MKL.
Owl has also utilised OpenMP on many math operations to boost their performance by threading calculation.

For example, the figure below shows that when we apply the :math:`sin` function on a N-Dimensional Array (ndarray) in Owl, on a 4-core CPU MacBook, the OpenMP version only takes about a third of the execution time compared with the non-OpenMP version.


.. figure:: ../figure/owl_aeos_sin_perf_mac.png
   :width: 30%
   :align: center
   :alt: omp_sin


However, as is often the case, performance improvement does not come for free.
Overhead of using OpenMP comes from time spent on scheduling chunks of work to each thread, managing locks on critical sections, and startup time of creating threads, etc.
Therefore, when the input ndarray is small enough, these overheads might overtake the benefit of threading.
Now the question is, what is a suitable input size to use OpenMP?


Why simple solution does not work
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This question would be easy to solve if there is one single suitable input size threshold for every operation.
Alas, that's not the case. Let's do a small experiment.
We compare the performance of two operations, :math:`abs` (calculate absolute value) and :math:`sin`, in three cases: running them without using OpenMP, with 2 threads OpenMP, and with 4 threads OpenMP.


.. figure:: ../figure/owl_aeos_cross.png
   :width: 90%
   :align: center
   :alt: omp_cross


The result shows that, with growing input size, for :math:`sin` operation, the OpenMP version outperforms the non-OpenMP version at a size of less than 1000, but for :math:`abs` operation, that crosspoint is at about 1,000,000.
The `complexity of math operations <https://en.wikipedia.org/wiki/Computational_complexity_of_mathematical_operations>`_ varies greatly, and the difference is even starker when compare their performance on different machines.

This issue becomes more complex when considered in real applications.
We know that even advanced computation such as training and inference of neural networks can be seen as a computation graph, each node being basic math operations such as :math:`conv`, :math:`dot`, :math:`sigmoid`, :math:`uniform`, etc.
In a computation graph, we need to deal with operations of vastly different complexity and input sizes.
Thus one fixed threshold for several operations is not an ideal solution.

Considering these factors, we need a fine-grained method to decide a suitable threshold for each operation.


Implementation
-----------------------------------------------------

Towards this end, we implement the AEOS module.
The idea is to add a *tuning* phase before compiling and installing Owl, so that each operation learns a suitable threshold parameter to decide if OpenMP should be used or not, depending on input size.

The key idea of parameter tuning is simple.
We implement two versions of each operation, one using OpenMP and the other not. We then measure their execution time for various sizes of input.
Each measurement is repeated multiple times, and to reduce the effect of outliers, only the values that are within first and third percentiles are used.
After removing outliers, regression is performed to find a suitable input size threshold.
According to our initial experiment, linear regression is fit to estimate the OpenMP parameters here.

Since this tuning phase is executed before compiling Owl, the AEOS module is made independent of Owl, and all the necessary implementation are coded separately to ensure that future changes of Owl do not affect the AEOS module itself.

The tuned parameters then need to be passed to Owl.
When the OpenMP switch is turned on, the AEOS module generates a C header file which contains the definition of macros, each of which defines a threshold for one operation. When this header file is not generated, pre-defined default macro values are used instead.
After that, Owl is compiled with this header file and uses these tuned parameters in its math operations.
The tuning phase only needs to be performed once on each machine.

The design of the AEOS module focuses on keeping tuning simple, effective, and flexible.
Each operation is implemented as a single OCaml module, so that support for new operations can be easily added.
The interface of a module is shown as below:


.. code-block:: ocaml

  module Sin = struct

    type t = {
      mutable name  : string;
      mutable param : string;
      mutable value : int;
      mutable input : int array array;
      mutable y     : float array
    }
    (** Tuner type definition. *)

    val make : unit -> t
    (** Create the tuner. *)

    val tune : t -> unit
    (** Tuning process. *)

    val save_data : t -> unit
    (** Save tuned data to csv file for later analysis. *)

    val to_string : t -> string
    (** Convert the tuned parameter(s) to string to be written on file *)

  end


We expect that tuning does not have to be only about OpenMP parameters, and that different regression methods could be used in the future.
For example, the `Theil–Sen estimator <https://www.tandfonline.com/doi/abs/10.1080/01621459.1968.10480934>`_ can be plugged in for parameter estimation if necessary.
In each module, arbitrary tuning procedures can be plugged in as long as the interface is satisfied.

The AEOS module is implemented in such way that brings little interference to the main Owl library. Code can be viewed in this `pull request <https://github.com/owlbarn/owl/pull/332>`_, and has been merged into the main branch of Owl. You only need to switch the *ENABLE_OPENMP* flag from :math:`0` to :math:`1` in the `dune file <https://github.com/owlbarn/owl/blob/master/src/owl/dune>`_ to try this feature.


Evaluation
-----------------------------------------------------

To evaluate the performance of tuned OpenMP thresholds, we need a metric to compare them.
Note that the effect of using the tuned parameters depends on input sizes, and given two thresholds, any input ndarray of size that smaller than the smaller one or larger than the larger one can be considered not affected.

Therefore, one metric to measure the difference of two thresholds can be calculated in such way: we generate a series of ndarrays, whose sizes grow by certain steps until they reach a given maximum number; for each size that falls between these two thresholds, we calculate the performance improvement ratio of the OpenMP version function over the non-OpenMP version. The ratios are added up, and then amortised by the total number of ndarrays.
Hereafter we use this averaged ratio as performance metric.


  +--------------+-------------+--------------+-------------+-------------+----------------+
  | Platform     | :math:`tan` | :math:`sqrt` | :math:`sin` | :math:`exp` | :math:`sigmoid`|
  +--------------+-------------+--------------+-------------+-------------+----------------+
  | MacBook      | 1632        | max_int      | 1294        | 123         | 1880           |
  +--------------+-------------+--------------+-------------+-------------+----------------+
  | Raspberry Pi | 1189        | 209          | 41          | 0           | 0              |
  +--------------+-------------+--------------+-------------+-------------+----------------+


This table presents the tuned threshold values of a five operations on a MacBook with a 1.1GHz Intel Core m3 CPU and a Raspberry Pi 3B.
We can see that they vary across different operations and different machines, depending on their computation complexity.
For example, on MacBook, the tuning result is "max\_int", which means that for the relatively simple :math:`sqrt` calculation OpenMP should not be used, but that's not the case on Raspberry Pi. Also, we note that the less powerful Raspberry Pi tends to get lower thresholds.


.. figure:: ../figure/owl_aeos_perf.png
   :width: 100%
   :align: center
   :alt: aeos mac


We then evaluate the performance improvement after applying AEOS.
We compare each generated parameter with 30 random generated thresholds. These measured average ratios are then presented as a box plot, as shown in the figure above.

It can be observed that in general more than 20\% average performance improvement can be expected on the MacBook.
The result on Raspberry Pi shows a larger deviation but also a higher performance gain (about 30\% on average).
One reason of this difference could be that a suitable threshold on Raspberry Pi tends to be smaller, leading to a larger probability to outperform a randomly generated value.
Note that we cannot proclaim that the tuned parameters are always optimal, since the figure shows that in some rare cases where the improvement percentages are minus, the randomly found values indeed perform better.
Also, the result seems to suggest that AEOS can provide a certain bound, albeit a loose one, on the performance improvement, regardless of the type of operation.
These interesting issues requires further investigation.

What’s next?
-----------------------------------------------------

As said above, this is an initial effort to apply the AEOS paradigm in Owl. Though the result looks promising, there still exists many interesting questions to further explore.
For example, analysis on single operation should be extended to practical applications.
Different regression methods could also be applied.
More operations that require tuning more than just OpenMP parameters could be included.
In evaluation, besides performance, stability of the generated parameters might also need to be considered to give a full picture in evaluation.
