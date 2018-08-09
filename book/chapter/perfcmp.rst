Performance Comparison
=================================================

We constantly conduct a comprehensive set of performance tests to make sure Owl is able to deliver the state-of-the-art performance. This guarantees that Owl has a competitive edge over other software tools.

We present the results of a thorough comparison between Owl and other popular software, namely NumPy and Julia, in this article. We compare them using plethora of numerical operations. They are categorised into five groups as shown below.

1) Conventional math operations. They can further be divided into two groups by the number of parameters:
  - one ndarray: ``abs``, ``exp``, ``log``, ``sqrt``, ``cbrt``, ``sin``, ``tan`, ``asin``, ``sinh``, ``asinh``, ``round``, ``sort``, ``sigmoid``, ``relu``, ``copy``.
  - two ndarrays: ``add``, ``mul``, ``div``, ``pow``, ``hypot``, ``min2``, ``fmod``.
  For these operations, we generate one or two uniformly distributed vector(s) as the input. The size of each vector grows from 10 to 1,000,000.
  To make sure a fair comparison, we change the in-place modification of ``sort`` function to return a new copy.

2) Fold and scan operations, including: ``max``, ``sum``, ``prod``, ``cumprod``, ``cummax``. These operation allows an "axis" parameter to specify along which dimension to perform the computation. Without loss of generality,  for each of these operations, we generate a uniformly distributed 4-dimension array, and choose the first and last dimensions to perform the operation. The size of each dimension is the same, which grows from 10 to 60.

3) Repeat operations, including ``repeat`` and ``tile``. For these two operations, we also uses 4-dimension array as input. The size of each dimension grows from 10 to 35.

4) Indexing and Slicing. We use ``get_slice`` function on Owl. For this operation, we choose two different input shape: [|10; 300; 3000|] and [|3000; 300; 10|], and apply different index combinations, e.g. ``[[-1;0]; [0;1]; []]``.

5) Linear Algebra functions, including: ``matmul``, ``inv``, ``eigenvals``, ``svd``, ``lu``, and ``qr``. We choose square matrix of order ``n`` as input, where ``n`` grows from 10 to 400.


Next we shows the evaluation results. Each observation is repeated for 30 times, and the outliers are trimmed.
We compare Owl version 0.4.0 with NumPy version 1.14.3, and Julia 0.6.3 on MacOS.


Conventional math operations
----------------------------


Outperforms the other two in most case; slower for simple operations that within 5ms.

Fold and Scan operations
----------------------------

Case by case.

Repeat operations
----------------------------

Note that we do not use Julia.
Performs better.

Indexing and Slicing
----------------------------

Slower than the other two.

Linear Algebra
----------------------------

For the rest, faster than the other two; but slower on ``lu`` and ``qr`` .
