Performance Comparison
=================================================

We constantly conduct a comprehensive set of performance tests to make sure Owl is able to deliver the state-of-the-art performance. This guarantees that Owl has a competitive edge over other software tools.

We present the results of a thorough comparison between Owl and other popular software, namely Numpy and Julia in this article. The operations we use for comparison can be categorised into five groups as shown below. Please refer to the document of
`ndarray <http://ocaml.xyz/chapter/ndarray.html>`_, `slicing <http://ocaml.xyz/chapter/slicing.html>`_, and `linear algebra <http://ocaml.xyz/chapter/linalg.html>`_ for detailed description of them.

1) Vectorised math operations. They can further be divided into two groups by the number of n-dimensional array they accept as input:

  - Unary operator: ``abs``, ``exp``, ``log``, ``sqrt``, ``cbrt``, ``sin``, ``tan``, ``asin``, ``sinh``, ``asinh``, ``round``, ``sort``, ``sigmoid``, ``copy``.
  - Binary operator: ``add``, ``mul``, ``div``, ``pow``, ``hypot``, ``min2``, ``fmod``.

  For these operations, we generate one or two uniformly distributed vector(s) as the input. The size of each vector increases from 10 to 1,000,000. Specifically, to ensure a fair comparison, we modify the in-place sort function in Owl to make it return a copy.

2) Fold and scan operations, including ``max``, ``sum``, ``prod``, ``cumprod``, and ``cummax``. These operations accept an "axis" parameter to specify along which dimension to perform the computation. Without loss of generality, for each of them, we generate a uniformly distributed 4-dimensional array, and choose the first and last dimension to perform computation. The size of each dimension is the same, increasing from 10 to 60.

3) Repeat operations, namely ``repeat`` (i.e. inner repeat) and ``tile`` (i.e. outer repeat). For these two operations, we also use 4-dimensional array and different axes array as input. The size of each dimension increases from 10 to 35.

4) Indexing and slicing, we benchmark the ``get_slice`` function in Owl. We choose two input shapes: ``[|10; 300; 3000|]`` and ``[|3000; 300; 10|]``, and apply different index combinations, e.g. ``[[-1;0]; [0;1]; []]``.

5) Linear Algebra functions, including ``matmul``, ``inv``, ``eigenvals``, ``svd``, ``lu``, and ``qr``. We use a square matrix of order ``n`` as input, where ``n`` increases from 10 to 1000.

We use Owl version 0.4.0, Numpy version 1.14.3, and Julia version 0.6.3. Each observation is repeated for 30 times, with outliers being trimmed.
The rest of this article presents the evaluation results.



Vectorised Math Operations
-------------------------------------------------

The ndarray module in Owl includes a full set of vectorised unary and binary mathematical functions. These functions map to each element in the input ndarray to the output with specific tranformation functions.
We choose a group of representative operations considering computation type and complexity for evaluation. For example, ``log2`` and ``sub`` are not used, since we have already selected the ``log`` and ``add`` operations with equivalent complexity.

Also, since Numpy and Julia do not have ``sigmoid``, we calculate it using existing operations. For example, the code in Python:

.. code-block:: python

  def sigmoid(x): return 1 / (1 + np.exp(-x))

The figures below show the evaluation results.

.. figure:: ../figure/perf/op_eval15.png
   :width: 100%
   :align: center
   :alt: exp

.. figure:: ../figure/perf/op_eval6.png
   :width: 100%
   :align: center
   :alt: log

.. figure:: ../figure/perf/op_eval7.png
   :width: 100%
   :align: center
   :alt: sqrt

.. figure:: ../figure/perf/op_eval1.png
   :width: 100%
   :align: center
   :alt: cbrt

.. figure:: ../figure/perf/op_eval12.png
   :width: 100%
   :align: center
   :alt: sin

.. figure:: ../figure/perf/op_eval4.png
   :width: 100%
   :align: center
   :alt: tan

.. figure:: ../figure/perf/op_eval5.png
   :width: 100%
   :align: center
   :alt: asin

.. figure:: ../figure/perf/op_eval16.png
   :width: 100%
   :align: center
   :alt: sinh

.. figure:: ../figure/perf/op_eval14.png
   :width: 100%
   :align: center
   :alt: asinh

.. figure:: ../figure/perf/op_eval21.png
   :width: 100%
   :align: center
   :alt: round

.. figure:: ../figure/perf/op_eval13.png
   :width: 100%
   :align: center
   :alt: sort

.. figure:: ../figure/perf/op_eval0.png
   :width: 100%
   :align: center
   :alt: sigmoid

.. figure:: ../figure/perf/op_eval9.png
   :width: 100%
   :align: center
   :alt: abs

.. figure:: ../figure/perf/op_eval18.png
   :width: 100%
   :align: center
   :alt: copy

.. figure:: ../figure/perf/op_eval8.png
   :width: 100%
   :align: center
   :alt: add

.. figure:: ../figure/perf/op_eval11.png
   :width: 100%
   :align: center
   :alt: mul

.. figure:: ../figure/perf/op_eval20.png
   :width: 100%
   :align: center
   :alt: div

.. figure:: ../figure/perf/op_eval10.png
   :width: 100%
   :align: center
   :alt: pow

.. figure:: ../figure/perf/op_eval17.png
   :width: 100%
   :align: center
   :alt: min2

.. figure:: ../figure/perf/op_eval2.png
   :width: 100%
   :align: center
   :alt: hypot

.. figure:: ../figure/perf/op_eval19.png
   :width: 100%
   :align: center
   :alt: fmod


We can see that in this group Owl outperforms or achieves similar performance as the other two in most cases, especially for complex computation such as ``log`` and ``sin``.

One thing is noteworthy is that Owl's ``copy`` function is slower than the other two, this explains why ``add`` operation is slower because the memory operation overhead dominates and the actual computation complexity is low. Owl's ``copy`` operation is implemented with a simple ``for`` loop whereas the other two are heavily optimised with AVX/SSE. Currently, we are working on the same AVX optimisation which is expected to boost the performance of ``copy`` to the same level. We will conduct another separate evaluation with AVX enabled soon.



Fold and Scan Operations
-------------------------------------------------

Fold and scan operations share the similar interface. They both have an axis parameter to specify along which axis of the input ndarray to perform certain type of calculation.

A fold function, or "reduction" function as is called in some other numerical libraries, reduces one dimension of a ndarray to one, and accumulates the value along that dimension according to the applied calculation. Scan functions are similar, only that they do not change the shape of input. 

In this part we choose the widely used maximum, summation, and multiplication calculations for both.

.. figure:: ../figure/perf/op_eval23.png
   :width: 100%
   :align: center
   :alt: max

.. figure:: ../figure/perf/op_eval24.png
   :width: 100%
   :align: center
   :alt: sum

.. figure:: ../figure/perf/op_eval25.png
   :width: 100%
   :align: center
   :alt: prod

.. figure:: ../figure/perf/op_eval22.png
   :width: 100%
   :align: center
   :alt: cummax

.. figure:: ../figure/perf/op_eval26.png
   :width: 100%
   :align: center
   :alt: cumprod

For fold and scan operations, except for ``max``, Owl operations are not the fastest. The performance varies for different computations.
Similar to vectorised math operations, the fold functions of Numpy and Julia also utilise AVX/SSE to boost the performance, while in Owl they are implemented as simple ``for`` loops with varied strides. This explains the performance gap for ``sum`` and ``prod``.



Repeat Operations
-------------------------------------------------

The ``repeat`` function in Owl repeats the elements in ndarray according the repetition specified by an integer array, the i-th element of which specifies the number of times that the individual entries of the i-th dimension of input ndarray should be repeated.

``tile`` is similar, but it repeats the whole input along specified dimensions. These two functions are also referred to as inner and outer repetition respectively.

.. figure:: ../figure/perf/op_eval28.png
   :width: 100%
   :align: center
   :alt: repeat

.. figure:: ../figure/perf/op_eval27.png
   :width: 100%
   :align: center
   :alt: tile

We exclude results of Julia in the comparison, since its repeat operations are orders of magnitude slower than that of Owl and Numpy.

Owl has shown the advantage for repeat operations. Part of the reason is that , multiple axes repeat in Numpy is implemented with multiple basic single axis repeat operation, whereas Owl has adopted an algorithm that repeats along multiple axes without generating intermediate results.



Slicing Operation
-------------------------------------------------

Slicing is one of the most important functions in a numerical computing library.
Owl provides basic slicing and fancy slicing. The latter supports more powerful index definition, but basic slicing is sufficient for performance evaluation.
Basic slicing contains two functions ``get_slice`` and ``set_slice`` to retrieve and assign slice values respectively. We evaluate the get function in this section.

.. figure:: ../figure/perf/op_eval29.png
   :width: 100%
   :align: center
   :alt: get_slice

We apply 8 different indices for two 3-dimensional arrays in slicing, and the result shows that slicing in Owl is slower than Numpy and Julia.



Linear Algebra Operations
-------------------------------------------------

Linear Algebra functions are usually categorised into matrix/vector products, decompositions, matrix eigenvalues, solving and inverting matrix, etc. In this section we choose to test multiplication, SVD/LU/QR decomposition, eigenvalue computation, and inversion functions for matrix. Since LU decomposition is not provided in Numpy, we use ``scipy.linalg.lu`` from the Scipy linear algebra library instead.
The results are shown as below.

.. figure:: ../figure/perf/op_eval33.png
   :width: 100%
   :align: center
   :alt: matmul

.. figure:: ../figure/perf/op_eval35.png
   :width: 100%
   :align: center
   :alt: inv

.. figure:: ../figure/perf/op_eval31.png
   :width: 100%
   :align: center
   :alt: svd

.. figure:: ../figure/perf/op_eval34.png
   :width: 100%
   :align: center
   :alt: lu

.. figure:: ../figure/perf/op_eval30.png
   :width: 100%
   :align: center
   :alt: qr

.. figure:: ../figure/perf/op_eval32.png
   :width: 100%
   :align: center
   :alt: eigvals

The performance for linear algebra operations are similar, since they all call the low level LAPACK and BLAS libraries to perform the required calculation.

As to the performance of QR decomposition, most of its time is spent in LAPACK routines. Owl's LAPACK interface passes data directly to LAPACK, while Numpy's interface implementation preprocesses the data according to different conditions, thus trying to improve the performance.
