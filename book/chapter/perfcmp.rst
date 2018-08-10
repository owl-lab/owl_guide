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

5) Linear Algebra functions, including ``matmul``, ``inv``, ``eigenvals``, ``svd``, ``lu``, and ``qr``. We use square matrix of order ``n`` as input, where ``n`` increases from 10 to 400.

We use Owl version 0.4.0, Numpy version 1.14.3, and Julia version 0.6.3. Each observation is repeated for 30 times, with outliers being trimmed.
The rest of this article presents the evaluation results.



Vectorised Math Operations
-------------------------------------------------

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

.. figure:: ../figure/perf/op_eval8.png
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

.. figure:: ../figure/perf/op_eval7.png
   :width: 100%
   :align: center
   :alt: min2

.. figure:: ../figure/perf/op_eval2.png
   :width: 100%
   :align: center
   :alt: hypot

.. figure:: ../figure/perf/op_eval9.png
   :width: 100%
   :align: center
   :alt: fmod

We can see that in this group Owl outperforms or achieves similar performance as the other two in most cases, especially for complex computation such as ``log`` and ``sin``.



Fold and Scan Operations
-------------------------------------------------

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

For fold and scan operations, except for ``max``, Owl operations are not the fastest. The performance varies for different computation.



Repeat Operations
-------------------------------------------------

.. figure:: ../figure/perf/op_eval28.png
   :width: 100%
   :align: center
   :alt: repeat

.. figure:: ../figure/perf/op_eval27.png
   :width: 100%
   :align: center
   :alt: tile

We do not include results of Julia here, since its repeat operations are orders of magnitude slower than that of Owl and Numpy. Owl has shown the advantage for repeat operations.



Slicing Operation
-------------------------------------------------

.. figure:: ../figure/perf/op_eval29.png
   :width: 100%
   :align: center
   :alt: get_slice

We apply 8 different indices for two 3-dimensional arrays in slicing, and the result shows that currently indexing and slicing in Owl still needs improving compared with Numpy and Julia.



Linear Algebra Operations
-------------------------------------------------

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


Except for ``qr``, the performance of Owl and Julia is very close for the other regarding to linear algebra operations. Both are slightly slower than that of Numpy.
