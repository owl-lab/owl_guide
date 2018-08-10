Scripting and Zoo System
=================================================

In this chapter, I will introduce the Zoo system in Owl and how to use it to make "small functions", then distribute and share them with other users. Before we start, I want to briefly discuss the motivation of the Zoo system.

It is known that we can use OCaml as a scripting language as Python (at certain performance cost because the code is compiled into bytecode). Even though compiling into native code for production use is recommended, scripting is still useful and convenient, especially for light deployment and fast prototyping. In fact, the performance penalty in most Owl scripts is almost unnoticeable because the heaviest numerical computation part is still offloaded to Owl which runs native code.

While designing Owl, my goal is always to make the whole ecosystem open, flexible, and extensible. Programmers can make their own "small" scripts and share them with others conveniently, so they do not have to wait for such functions to be implemented in Owl's master branch or submit something "heavy" to OPAM.



Typical Scenario
-------------------------------------------------

To illustrate how to use Zoo, let's start with a synthetic scenario. The scenario is very simple: Alice is a data analyst and uses Owl in her daily job. One day, she realised that the functions she needed had not been implemented yet in Owl. Therefore, she spent an hour in her computer and implemented these functions by herself. She thought these functions might be useful to others, e.g., her colleague Bob, she decided to share these functions using Zoo System.

Now let me see how Alice manages to do so in the following, step by step.


Create a Script
-------------------------------------------------

First, Alice needs to create a folder (e.g., ``myscript`` folder) for her shared script. OK, what to put in the folder then?

She needs at least two files in this folder. The first one is of course the file (i.e., ``coolmodule.ml``) implementing the function as below. The function ``sqr_magic`` returns the square of a magic matrix, it is quite useless in reality but serves as an example here.

.. code-block:: ocaml

  #!/usr/bin/env owl

  open Owl

  let sqr_magic n = Mat.(magic n |> sqr)


The second file she needs is a ``#readme.md`` which provides a brief description of the shared script. Note that the first line of the ``#readme.md`` will be used as a short description for the shared scripts. This short description will be displayed when you use ``owl -list`` command to list all the available Zoo code snippets on your computer.

.. code-block:: bash

  Square of Magic Matrix

  ``Coolmodule`` implements a function to generate the square of magic matrices.



Share via Gist
-------------------------------------------------

Second, Alice needs to distribute the files in ``myscript`` folder. But how?

The distribution is done via `gist.github.com <https://gist.github.com/>`_, so you must have ``gist`` installed on your computer. E.g., if you use Mac, you can install ``gist`` with ``brew install gist``. Owl provides a simple command line tool to upload the Zoo code snippets. Note that you need to log into your github account for ``gist`` and ``git``.

.. code-block:: bash

  owl -upload myscript


The ``owl -upload`` command simply uploads all the files in ``myscript`` as a bundle to your `gist.github.com <https://gist.github.com/>`_ page. The command also prints out the url after a successful upload. In our case, you can check the updated bundle on `[this page] <https://gist.github.com/9f0892ab2b96f81baacd7322d73a4b08>`_.



Import in Another Script
-------------------------------------------------

The bundle Alice uploaded before is assigned a unique ``id``, i.e. ``9f0892ab2b96f81baacd7322d73a4b08``. In order to use the ``sqr_magic`` function, Bob only needs to use ``#zoo`` directive in his script e.g. ``bob.ml`` in order to import the function.

.. code-block:: ocaml

  #!/usr/bin/env owl
  #zoo "9f0892ab2b96f81baacd7322d73a4b08"

  let _ = Coolmodule.sqr_magic 4 |> Owl.Mat.print


Bob's script is very simple, but there are a couple of things worth pointing out:

1) Zoo system will automatically download the bundle of a given id if it is not cached locally;

2) All the ``ml`` files in the bundle will be imported as modules, so you need to use ``Coolmodule.sqr_magic`` to access the function.

3) You may also want to use ``chmod +x bob.ml`` to make the script executable. This is obvious if you are a heavy terminal user.


Note that to use ``#zoo`` directive in ``utop`` you need to manually load the ``owl_zoo`` library with ``#require "owl_zoo";;``. Alternatively, you can also load ``owl_top`` using ``#require "owl_top";;`` which is an OCaml toplevel wrapper of Owl.

If you want to make ``utop`` load the library automatically by adding this line to ``~/.ocamlinit``.


Choose a Version of Script
-------------------------------------------------

Alice has modified and uploaded her scripts several times. Each version of her code is assigned a unique ``version id``. Different versions of code may work differently, so how could Bob specify which version to use? Good news is that, he barely needs to change his code.

.. code-block:: ocaml

  #!/usr/bin/env owl
  #zoo "9f0892ab2b96f81baacd7322d73a4b08/71261b317cd730a4dbfb0ffeded02b10fcaa5948"

  let _ = Coolmodule.sqr_magic 4 |> Owl.Mat.print


The only thing he needs to add is a version id after the gist bundle id and a slash. Version id can be obtained from the gist's `[revisions page] <https://gist.github.com/9f0892ab2b96f81baacd7322d73a4b08/revisions>`_. If the version id is not specified, as shown in the previous code snippet, the latest version on the Gist server will be used by default.


Command Line Tool
-------------------------------------------------

That's all. Zoo system is not complicated at all. There will be more features to be added in future. For the time being, you can check all the available options by executing ``owl``.

.. code-block:: text

  $ owl
  Owl's Zoo System

  Usage:
    owl [utop options] [script-file]  execute an Owl script
    owl -upload [gist-directory]      upload code snippet to gist
    owl -download [gist-id] [ver-id]  download code snippet from gist; download the latest version if ver-id not specified
    owl -remove [gist-id]             remove a cached gist
    owl -update [gist-ids]            update (all if not specified) gists
    owl -run [gist-id]                run a self-contained gist
    owl -info [gist-ids]              show the basic information of a gist
    owl -list [gist-id]               list all cached versions of a gist; list all the cached gists if gist-id not specified
    owl -help                         print out help information


Note that both ``run`` and ``info`` commands accept a full gist name in the format of ``gist-id/version-id``. If the version id is not specified, the latest version on the Gist server will be used by default.


Examples
-------------------------------------------------

Despite of its simplicity, Zoo is a very flexible and powerful tool and we have been using it heavily in our daily work. We often use Zoo to share the prototype code and small shared modules which we do not want to bother OPAM, such those used in performance tests.

Moreover, many interesting examples are also built atop of Zoo system.

* `Google Inception V3 for Image Classification <https://gist.github.com/jzstark/9428a62a31dbea75511882ab8218076f>`_

* `Neural Style Transfer <https://gist.github.com/jzstark/6f28d54e69d1a19c1819f52c5b16c1a1>`_
