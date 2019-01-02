Acknowledgement
=================================================

Owl is built on top of an enormous amount of previous work. Without the efforts of these projects and the intellectual contribution of these people, it will be very difficult for me to continue developing Owl.

While designing and developing the various components in Owl, I have been studying many systems and keep learning from them. The following is an incomplete list of individuals/projects/software who made significant contributions to Owl. I owe a great debt of gratitude to these ingenious people. The credit goes to them.

Because Owl is always under active development, there might be a lag between the development code and the lists here. In case you think there is something/someone missing in the list, please do contact me. I will try to make this list up-to-date.


Contributors
-------------------------------------------------

- Great support from my `colleagues <http://ocamllabs.io/people/>`_ in `OCaml Labs <http://ocamllabs.io/>`_ and `System Research Group <https://www.cl.cam.ac.uk/research/srg/netos/people/>`_ in the Computer Lab.

- The interface design are heavily influenced by `Numpy <http://www.numpy.org/>`_, `SciPy <https://www.scipy.org/>`_, `Julia <https://julialang.org/>`_, `Matlab <https://www.mathworks.com/products/matlab.html>`_.

- The early versions heavily relied on `Markus Mottl <http://www.ocaml.info/>`_ and `Christophe Troestler <https://github.com/Chris00>`_'s projects: `Lacaml <https://github.com/mmottl/lacaml>`_, `Gsl <https://github.com/mmottl/gsl-ocaml>`_.

- `Richard Mortier <https://github.com/mor1>`_ has been providing great support and constructive feedback. We two together have been running interesting sub-projects on top of Owl.

- `Ben Catterall <https://www.linkedin.com/in/ben-catterall-38643287/?ppe=1>`_ did excellent theoretical work for Owl's underlying distributed computation engine. He also contributed to the NLP module.

- `Tudor Tiplea <https://github.com/tptiplea>`_ contributed the initial Ndarray implementation in the base module.

- `Maria (kanisteri) <https://github.com/kanisteri>`_ contributed several root-finding algorithms. She is also working on other numerical functions in Owl.

- `Jianxin Zhao <https://github.com/jzstark/>`_ optimised some core operations of ndarray, built advanced machine learning and deep neural network applications on top of Owl. He's been working on Zoo system for future service deployment.

- `Pierre Vandenhove <https://www.linkedin.com/in/pierre-vdhove/?originalSubdomain=be>`_ has been working on the optimisation of the computation graph functor stack, improving deep neural networks, as well as building advanced object detection and segmentation applications using Mast RCNN atop of Owl.

- `Gavin Stark <https://github.com/atthecodeface>`_ contributed and reshaped many unit tests. His work has been helping us in identifying and fixing existing bugs and preventing potential ones, greatly assured the quality of Owl.

- `Marshall Abrams <https://github.com/mars0i>`_ has been contributing code to Plot and other modules, improving the documentation. Moreover, he always provide useful feedback and constructive discussion.

- `Sergei Lebedev <https://github.com/superbobry>`_ and `bagmanas <https://github.com/bagmanas>`_ contributed various hypothesis test functions in Stats module.

- Interfacing to other C/C++ libraries (e.g., CBLAS, LAPACKE, Eigen, OpenCL, and etc.) relies on `Jeremy Yallop <https://www.cl.cam.ac.uk/~jdy22/>`_'s `ocaml-ctypes <https://github.com/ocamllabs/ocaml-ctypes>`_.

- The plot module is built on top of `Hezekiah M. Carty <https://github.com/hcarty>`_'s project: `ocaml-plplot <https://github.com/hcarty/ocaml-plplot>`_.

- Many functions rely on `Eigen <http://eigen.tuxfamily.org/index.php?title=Main_Page>`_ and its `OCaml binding <https://github.com/ryanrhymes/eigen>`_. The binding also contains some functions (e.g., convolution functions) from Google's `Tensorflow <https://www.tensorflow.org/>`_.

- `Jérémie Dimino <https://github.com/diml>`_ and many others built the powerful `building system <https://github.com/ocaml/dune>`_ and convenient `toplevel <https://github.com/diml/utop>`_ for OCaml.

- Other projects which have been providing useful insights: `Oml <https://github.com/hammerlab/oml>`_, `pareto <https://github.com/superbobry/pareto>`_.


Open Source Projects
-------------------------------------------------

Owl is partially based on several open-source projects which contribute a significant amount of original novelty.

* `DiffSharp <http://diffsharp.github.io/DiffSharp/>`_ and `Hype <http://hypelib.github.io/Hype/>`_, by `Atilim Gunes Baydin <http://www.cs.nuim.ie/~gunes/>`_, `Barak A. Pearlmutter <http://www.bcl.hamilton.ie/~barak/>`_, and et al. Code ported to Algodiff and Optimise modules.
* `dolog <https://github.com/UnixJunkie/dolog>`_ by `Francois BERENGER <https://github.com/UnixJunkie>`_. Code ported to Log module.
