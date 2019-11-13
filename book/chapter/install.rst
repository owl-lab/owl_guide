Installation
=================================================

Owl requires OCaml ``>=4.06.0``. Please make sure you have a working OCaml environment before you start installing Owl. Here is a guide on `[Install OCaml] <https://ocaml.org/docs/install.html>`_.

Owl's installation is rather trivial. There are four possible ways as shown below, from the most straightforward one to the least one.



Option 1: Install from OPAM
-------------------------------------------------

Thanks to the folks in `OCaml Labs <http://ocamllabs.io/>`_, OPAM makes package management in OCaml much easier than before. You can simply type the following in the command line to start.

.. code-block:: bash

  opam depext owl
  opam install owl

If you want to try the newest development features, I recommend the other ways to install Owl, as below.

In case of linking issues, known to happen on `ubuntu`-based distribution. You will need to compile `openblas` by hand, and use the appropriate environment variables to point at your newly compiled library. You can use `owl's docker file <https://github.com/owlbarn/owl/blob/master/docker/Dockerfile.ubuntu>` as a reference for this.

Option 2: Pull from Docker Hub
-------------------------------------------------

`Owl's docker image <https://hub.docker.com/r/ryanrhymes/owl/>`_ is perfectly synced with master branch. The image is always automatically built whenever there are new commits. You can check the building history on `[Docker Hub] <https://hub.docker.com/r/ryanrhymes/owl/builds/>`_.

You only need to pull the image then start a container.

.. code-block:: bash

  docker pull ryanrhymes/owl
  docker run -t -i ryanrhymes/owl

Besides the complete Owl system, the docker image also contains an enhanced OCaml toplevel - ``utop``. You can start ``utop`` in the container and try out some examples.

The source code of Owl is stored in `/root/owl` directory. You can modify the source code and rebuild the system directly in the started container.



Option 3: Pin the Dev-Repo
-------------------------------------------------

``opam pin`` allows you to pin the local code to Owl's development repository on Github. The first command ``opam depext`` installs all the dependencies Owl needs.

.. code-block:: bash

  opam depext owl
  opam pin add owl --dev-repo



Option 4: Compile from Source
-------------------------------------------------

This is my favourite option. First, you need to clone the repository.

.. code-block:: bash

  git clone git@github.com:ryanrhymes/owl.git


Second, you need to figure out the missing dependencies and install them.

.. code-block:: bash

  jbuilder external-lib-deps --missing @install


Last, this is perhaps the most classic step.

.. code-block:: bash

  make && make install

If your OPAM is older than ``V2 beta4``, you need one extra steps. This is due to a bug in OPAM which copies the compiled library into ``/.opam/4.06.0/lib/stubslibs`` rather than ``/.opam/4.06.0/lib/stublibs``. If you don't upgrade OPAM, then you need to manually move ``dllowl_stubs.so`` file from ``stubslib`` to ``stublib`` folder, then everything should work.



CBLAS/LAPACKE Dependency
-------------------------------------------------

The most important dependency is `OpenBLAS <https://github.com/xianyi/OpenBLAS>`_. Linking to the correct OpenBLAS is the key to achieve the best performance. Depending on the specific platform, you can use ``yum``, ``apt-get``, ``brew`` to install the binary format. For example on my Mac OSX, the installation looks like this:

.. code-block:: bash

  brew install homebrew/science/openblas


However, installing from OpenBLAS source code leads to way better performance in my own experiment. OpenBLAS already contains an implementation of LAPACKE, as long as you have a Fortran complier installed on your computer, the LAPACKE will be compiled and included in the installation automatically.

Another benefit of installing from OpenBLAS source is: some systems' native package management tool installs very old version of OpenBLAS which misses some functions Owl requires.



Integration to Toplevel
-------------------------------------------------

Owl is well integrated with ``utop``. You can use ``utop`` to try out the experiments in our tutorials. If you want ``utop`` to automatically load Owl for you, you can also edit ``.ocamlinit`` file in your home folder by adding the following lines. (Note that the library name is ``owl`` with lowercase ``o``.)

.. code-block:: ocaml

  #require "owl_top"


The ``owl_top`` is the toplevel library of Owl, it automatically loads ``owl`` core library and installs the corresponding pretty printers of various data types.
