Finished Sub-Projects
=================================================

This page maintains a list of finished projects including a brief description and its outcome. If you think your project is relevant to Owl and want to be included in the list on this page, please contact me directly.



Probabilistic Synchronous Parallel
-------------------------------------------------

By **Benjamin P. W. Catterall** | Part III | June 2017 | :download:`{Thesis} <../papers/catterall.pdf>`  `{ArXiv 1709} <https://arxiv.org/abs/1709.07772>`_

The synchronisation scheme used to manage parallel updates of a distributed machine learning model can dramatically impact performance. System and algorithm designers need methods which allow them to make trade-offs between fully asynchronous and fully deterministic schemes. Barrier control methods represent one possible solution. In this report, I present Probabilistic Synchronous Parallel (PSP), a barrier control method for distributed machine learning. I provide analytical proofs of convergence and carry out an experimental verification of the method using a bespoke simulator. I find that PSP improves the convergence speed and iteration throughput of more traditional barrier control methods. Furthermore, I demonstrate that PSP provides stronger convergence guarantees than a fully asynchronous design whilst maintaining the general characteristics of stronger methods.



Supporting Browser-based Machine Learning
-------------------------------------------------

By **Tudor Petru Tiplea** | Part III | June 2018 | :download:`{Thesis} <../papers/tiplea.pdf>`

Because it can tell so much about nature and people, digital data is collected and analysed in immeasurable quantities. Processing this data often requires collections of resources typically organised in massive data centres, a paradigm known as cloud computing. However, this paradigm has certain limitations. Apart from the often prohibitive costs, cloud computing requires data centralisation, which could slow down real-time applications, or require exorbitant storage. Edge computing—a solution aiming to move computation to the network’s edge — is regarded as a promising alternative, especially when tailored for Internet-of-Things deployment.

Aiming for more large-scale adoption, this project provides a proof of concept for edge computing support on an ubiquitous platform—the web-browser. This work is framed within an emerging OCaml ecosystem for data processing and machine learning applications. We explored options for OCaml-to-JavaScript compilation, and extended Owl, the main library in the ecosystem, guided by those findings. Next, we researched solutions for efficient data transmissions between browsers, then based on that, implemented a browser-compatible communication system analogous to TCP/IP network sockets. This system was later used to modify Actor, Owl’s distributed computing engine, making it deployable in the browser.

We demonstrated our work on Owl was successful, exemplifying the browser-deployed localised computing capabilities. The performance limitations of this part were analysed, and we suggest directions for optimisations based on empirical results. We also illustrated the accomplishment of browser-based distributed computing, again identifying limitations that must be overcome in the future for a complete solution.



Adaptable Asynchrony in Distributed Learning
-------------------------------------------------

By **De Sheng Royson Lee** | M.Phil | June 2018 | :download:`{Thesis} <../papers/royson.pdf>`

Distributed training of deep learning models is typically trained using stochastic optimisation in an asynchronous or synchronous environment. Increasing asynchrony is known to add noise introduced from stale gradient updates, whereas relying on synchrony may be inefficient due to stragglers. Although there has been a wide range of approaches to mitigate or even negate these weaknesses, little has been done to improve asynchronous adaptive stochastic gradient descent (SGD) optimisation. In this report, I survey these approaches and propose a technique to better train these models. In addition, I empirically show that the technique works well with delay-tolerance adaptive SGD optimisation algorithms, improving the rate of convergence, stability, and test accuracy. I also demonstrate that my approach performs consistently well in a dynamic environment in which the number of workers changes uniformly at random.



Applications of Linear Types
-------------------------------------------------

By **Dhruv C. Makwana** | Part III | June 2018 | :download:`{Thesis} <../papers/dhruv.pdf>`  `{Github} <https://github.com/dc-mak/lt4la/>`_

In this thesis, I argue that linear types are an appropriate, type-based formalism for expressing aliasing, read/write permissions, memory allocation, re-use and deallocation, first, in the context of the APIs of linear algebra libraries and then in the context of matrix expression compilation. I show that framing the problem using linear types can reduce bugs by making precise and explicit, the informal, ad-hoc practices typically employed by experts and matrix expression compilers and automate checking them.

As evidence for this argument, I show non-trivial, yet readable, linear algebra programs, that are safe and explicit (with respect to aliasing, read/write permissions, memory allocation, re-use and deallocation) which (1) are more memory-efficient than equivalent programs written using high- level linear algebra libraries and (2) perform just as predictably as equivalent programs written using low-level linear algebra libraries. I also argue the experience of writing such programs with linear types is qualitatively better in key respects. In addition to all of this, I show that it is possible to provide such features as a library on top of existing programming languages and linear algebra libraries.



Composing Data Analytical Services
-------------------------------------------------

By **Jianxin Zhao** | PhD | June 2018 | `{ArXiv 1805} <https://arxiv.org/abs/1805.05995>`_

Data analytics on the cloud is known to have issues such as increased response latency, communication cost, single point failure, and data privacy concerns. While moving analytics from cloud to edge devices has recently gained rapid growth in both academia and industry, this topic still faces many challenges such as limited computation resource on the edge. In this report, we further identify two main challenges: the composition and deployment of data analytics services on edge devices. Initially, the Zoo system is designed to make it convenient for developers to share and execute their OCaml code snippets, with fine-grained version control mechanism. We then extend it to address those two challenges. On one hand, Zoo provides simple domain-specific language and high-level types to enable easy and type-safe composition of different data analytics services. On the other hand, it utilises multiple deployment backends, including Docker container, JavaScript, and MirageOS, to accommodate the heterogeneous edge deployment environment. We demonstrate the expressiveness of Zoo with a use case, and thoroughly compare the performance of different deployment backends in evaluation.



Computer Vision & Performance Optimisation of Computation Graph
---------------------------------------------------------------
By **Pierre Vandenhove** | MSc | October 2018 | `{MRCNN Github} <https://github.com/owlbarn/owl-mask-rcnn>`_ | `{ArXiv 1812} <https://arxiv.org/abs/1812.03770>`_ | {:doc:`pierre_cgraph`}

Computer vision tasks are known to be highly computationally-heavy, both performance-wise and memory-wise. They are thus especially relevant to put a numerical framework such as Owl to the test. The first part of this project focuses on the implementation of several computer vision applications using Owl's neural network library. The first such application is Microsoft's 'ResNet' network to perform simple image classification (`paper 1512.03385 <https://arxiv.org/abs/1512.03385>`_, `Resnet implementation in Owl <https://github.com/pvdhove/owl-resnet>`_). The second, more extensive one, is 'Mask R-CNN', which is one of the leading networks to perform object detection, segmentation and classification (`paper 1703.06870 <https://arxiv.org/abs/1703.06870>`_, `MRCNN implementation <https://github.com/pvdhove/owl-mask-rcnn>`_). This allowed exemplifying some use cases to improve Owl's flexibility and ease of use, as well as add some necessary operations.

These applications are valuable benchmarking tools to identify bottlenecks and guide the optimisation of different subcomponents of Owl. A crucial step in this process is to apply Owl's computation graph to them, which is the key to obtaining state-of-the-art performance and memory usage. With the new applications as examples, it was possible to make it more robust, efficient and user-friendly.



Automatic Parameter Tuning for OpenMP
-------------------------------------------------

By **Jianxin Zhao** | PhD | November 2018 | `{AEOS Github} <https://github.com/owlbarn/owl/tree/master/src/aeos>`_ | `{Thesis} <http://ocaml.xyz>`_ | {:doc:`jianxin_aeos`}

Automatic Empirical Optimisation of Software (AEOS) is crucial for high performance computing software. It is a methodology to generate optimised software using empirically tuned parameters. As an initial attempt to improve the performance of Owl with it, we build the AEOS module to tune the OpenMP parameters in Owl. OpenMP is an application programming interface that supports multi-platform shared memory multiprocessing programming. It is used in Owl to boost performance of basic operations. However, using OpenMP brings certain overhead, so that when the size of input data is small, or the operation is simple, the non-OpenMP version operation might be faster. Thus an optimal threshold varies for different operations and machines. In the AEOS module, each operation is abstracted as a stand-alone module, and uses linear regression to find this optimal threshold. Compared with the previous practice of set a single threshold for all OpenMP operations, using AEOS module further improves their performance. The AEOS module is designed in such way that extending it to accommodate more parameters or operations should be easy.


Run Your Owl Computation on TensorFlow
-------------------------------------------------

By **Jianxin Zhao** | PhD | February 2019 | {:doc:`jianxin_cgraph`}

In this project we are looking at computation interoperability of Owl with existing libraries such as TensorFlow.
Our target is to have the best of both worlds. On one hand, we can define "how to compute" on Owl with its elegant and powerful syntax; on the other hand, we can execute the computation efficiently across various hardware devices, such as GPU and TPU, that TensorFlow supports.
One crucial decision to make is to find the correct intermediate representation in exchanging computation between different platforms.
Unlike many existing systems and tools, we decide that computation graph, rather than neural network graph, should be the fundamental abstraction.
Based on this decision, we build an experimental converter system. It aims to export CGraph defined in Owl and execute it in TensorFlow.
This system centres around the abstraction of TensorFlow computation graph, and how to map Owl computation graph to it.
Our system utilises the Save and Restore mechanism in TensorFlow to provide a concise workflow.
Currently we are actively developing the system. Thought still quite limited at the initial phase, the system has shown its potential in real-world examples, including deep neural network inference and algorithmic differentiation.
In our next step, it would be interesting to see how our system can be extended and combined with related topics such as GPU and XLA. 
