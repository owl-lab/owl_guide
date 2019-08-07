Proposed Sub-Projects
=================================================

Owl is a very focused system but it indeed covers a wide range of topics from numerical analysis to system programming and optimisation. This page maintains an active list of potential topics which are relevant to Owl. Many of these topics are tightly connected to the cutting-edge research carried by the researchers in the Computer Lab.

Please contact us if you are interested in any of them.



Project 1. Maths and Stats in the Base library
-------------------------------------------------------------------------------

Owl's Base library not only provides fundamental support for its numerical core, but also allows us to compile the code for different backends, from javascript, bytecode, to native code.

This project focuses on enhancing the maths and stats modules in the Base library. The project requires a good understand of mathematics and statistics, as well as some knowledge in special functions. The task is very well-defined and easy to monitor the progress.

This project is very important because the more functions we have in the Base library, the more freedom we can give to programmers to switch between different platforms by allowing them compile the code into pure bytecode, Javascript, mirageOS, and etc. Having a powerful Base library will attract more programmers into OCaml community.



Project 2. Linear Algebra in the Base library
-------------------------------------------------------------------------------

This project is very similar to the previous one, but the focus is on the linear algebra. The student is expected to implement basic linear algebra functions such as matrix multiplication, factorisation, and so on.

The outcome can open the possibility of implementing more advanced and complicated analytical functions in unikernel, which will be very useful for building up more advanced micro services in the context of both cloud and edge computing.



Project 3. Ndarray in the Base library
-------------------------------------------------------------------------------

Ndarray is the core data structure in Owl. In the Owl Core library, there is already a very efficient implementation based on the CPU backend. However, the pure OCaml implementation in Base library has many limitation. This project focuses on the optimisation of Ndarray module, as well as introducing more tensor operations. E.g. Einstein Summation is one of the functions can be included.

Similarly, the data structure for sparse Ndarray and Matrix is also missing in the Base library, which can also be a potential direction to look into.



Project 4. Probabilistic Programming
-------------------------------------------------------------------------------

This project aims to implement a small probabilistic programming language in Owl (refer to Edward). Note the implementation will be different from Church or WebPPL which are trace-based. Instead, The design will be in line with Edward (atop of Tensorflow) which is graph-based model for Bayesian inference.

Many components are already ready in Owl, e.g., efficient random number generation, lazy evaluation, and etc. The student is expect to implement the skeleton of inference engines, such as MCMC engine, variational, HMCMC, and etc.

This project requires a good understand of PPL, Statistics, Bayesian inference, and etc. It is an very interesting topic and challenging project.



Project 5. Machine Learning Applications
-------------------------------------------------------------------------------

This project emphasises applying Owl to solve real world problems. Similar to our existing Google Inception V3 demonstration, and recent Neural Style Transfer application. We expect students to build interesting applications by taking advantage of Owl’s numerical power, such as text classification, voice to text translation, and etc.

This project can be tailored based on student’s background, i.e. what he/she is familiar with really.

* `Google Inception Demo <http://138.68.155.178/index.html>`_
* `Neural Style Transfer Demo <http://138.68.155.178/neuraltrans.html>`_



Project 6. Deep Neural Network
-------------------------------------------------------------------------------

This project aims to enhance the Deep Neural Network module in Owl. The current ``Neural`` module is already very powerful and allows us to build very advanced models. However, there are still several types of neuron missing, e.g. transposed convolutional neuron, and etc.

The student is expected to complete the missing features in Neural module and optimise the existing implementation. The background in machine learning, deep neural network, and optimisation is highly appreciated.



Project 7. Optimisation Engine
-------------------------------------------------------------------------------

Owl’s optimisation engine is built atop of its algorithmic differentiation module ``Algodiff``, which itself is a functor. The OCaml code built atop of `Optimise` functor can be compiled into self-contained Javascript.

This project focuses on extending current optimisation engine with more optimisation functions such as L-BFGS, and etc. The student is also expected add more regression models into ``Regression`` functor. Ideally, the student should have strong background in Statistics and convex optimisation.



Project 8. Signal Processing & ODE
-------------------------------------------------------------------------------

Two important modules are currently missing in Owl: integration and signal processing. Please refer to Scipy as below. This project strongly focuses on the implementation of this fundamental functions. Signal processing is more challenging because there are more functions to implement.

The strong background in Mathematical analysis is appreciated.

* `Scipy's Integration <https://docs.scipy.org/doc/scipy/reference/integrate.html>`_
* `Scipy's Signal Processing <https://docs.scipy.org/doc/scipy/reference/signal.html>`_



Project 9. Dynamic Graph Optimisation
-------------------------------------------------------------------------------

This project aims to optimise the dynamic graph generated from ``Algodiff`` and ``Lazy`` module. The optimised graph can lead to superior performance in deep neural network and other advanced numerical applications. This is a non-trivial task and requires good understanding of dataflow programming, graph optimisation techniques, and so on.

Refer to

* `Theano AD <http://deeplearning.net/software/theano/extending/graphstructures.html#optimizations>`_
* `Graph optimization <http://deeplearning.net/software/theano/extending/optimization.html#optimization>`_
* `Optimizations <http://deeplearning.net/software/theano/optimizations.html#optimizations>`_


Project 10. GPU Computing
-------------------------------------------------------------------------------

This project is to extend Owl's numerical capability from CPU to GPU using OpenCL. Currently, Owl already has raw interface to OpenCL and has implemented many basic vectorised math functions. Technically, the student is expected to keep building a full-featured ``Ndarray`` module on GPU.

This project requires programming in both OpenCL kernel and OCaml, so the understanding of the relevant technologies is important.



Project 11. Data Processing and Visualisation
-------------------------------------------------------------------------------

For most data analysts and scientists, their daily job deals with data processing and visualisation. Efficient (pre-)processing algorithms and effective visualisation techniques together lay a solid foundation for all the modern data analytical platforms.

This project uses Owl as its underlying numerical platform and focusses on developing practical algorithms to handle various data sets. The goal is to provide an efficient and elegant data abstraction layer to other components in Owl.

Another focus is to further develop data visualisation component in Owl. The algorithms of interest range from the basic plots used in classic statistical analysis such as qqplot to the state-of-the-art visualisation techniques such as t-SNE to visualise high-dimensional data. If you are interested in data processing and visualisation, please contact me.



Project 12. Neural Network and Computation Graph Exchange Format
-------------------------------------------------------------------------------

This project aims to develop the functionality which can converts Owl's neural network and computation graph definition into NNEF or ONNX format. NNEF is a newly proposed open standard in industry for defining the graph structure of neural networks, independent from different deep learning frameworks. OpenVX and NNEF together reduce the hassles of deploying DNN-based services on various inference engines. On the other hand, ONNX is not really a standard but widely accepted by many mainstream DNN frameworks.

Refer to

* `ONNX Project <https://onnx.ai/>`_
* `Khronos OpenVX <https://www.khronos.org/openvx/>`_
* `Khronos NNEF <https://www.khronos.org/nnef/>`_



Project 13. Distributed ML on Unikernel for IoT
-------------------------------------------------------------------------------

By `Hiroshi Doyu <https://www.linkedin.com/in/hidoyu/>`_ (Ericsson) | ongoing | `{LwAE Github} <https://github.com/owlbarn/light_actor>`_

Considering the coming enormous amount of hyper-scale IoT data, Mobile Edge servers would be heavily overloaded at peak times, especially raw data for ML training is too huge and insecure to move around quickly. To solve this problem, we need to offload those computation from Edge servers to any available computational devices at hand before sending them out to Edge. Usually those beyond-Edge devices are resource constraint. Container-based solutions are not enough efficient for this purpose. We expect Owl with MirageOS(Unikernel) to fill this gap because of its size conciseness. And LwAE is the way to distribute those computations over resource constraint IoT devices along with Cloud and Edge. We'll explore the possibility of beyond-Edge computation with Owl, MirageOS and LwAE.
