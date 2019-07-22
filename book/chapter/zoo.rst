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

The distribution is done via `gist.github.com <https://gist.github.com/>`_, so you must have ``gist`` installed on your computer. E.g., if you use Mac, you can install ``gist`` with ``brew install gist``. Owl provides a simple command line tool to upload the Zoo code snippets. Note that you need to log into your Github account for ``gist`` and ``git``.

.. code-block:: bash

  owl -upload myscript


The ``owl -upload`` command simply uploads all the files in ``myscript`` as a bundle to your `gist.github.com <https://gist.github.com/>`_ page. The command also prints out the url after a successful upload. In our case, you can check the updated bundle on `this page <https://gist.github.com/9f0892ab2b96f81baacd7322d73a4b08>`_.



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


Note that to use ``#zoo`` directive in ``utop`` you need to manually load the ``owl-zoo`` library with ``#require "owl-zoo";;``. Alternatively, you can also load ``owl-top`` using ``#require "owl-top";;`` which is an OCaml toplevel wrapper of Owl.

If you want to make ``utop`` load the library automatically by adding this line to ``~/.ocamlinit``.


Choose a Version of Script
-------------------------------------------------

Alice has modified and uploaded her scripts several times. Each version of her code is assigned a unique ``version id``. Different versions of code may work differently, so how could Bob specify which version to use? Good news is that, he barely needs to change his code.

.. code-block:: ocaml

  #!/usr/bin/env owl
  #zoo "9f0892ab2b96f81baacd7322d73a4b08?vid=71261b317cd730a4dbfb0ffeded02b10fcaa5948"

  let _ = Coolmodule.sqr_magic 4 |> Owl.Mat.print


The only thing he needs to add is a version id using the parameter ``vid``. The naming scheme of Zoo is designed to be similar with the field-value pair in a RESTful query. Version id can be obtained from a gist's `revisions page <https://gist.github.com/9f0892ab2b96f81baacd7322d73a4b08/revisions>`_.

Besides specifying a version, it is also quite possible that Bob prefers to use the newest version Alice provides, whatever its id may be. The problem here is that, how often does Bob need to contact the Gist server to retreat the version information? Every time he runs his code? Well, that may not be a good idea in many cases considering the communication overhead and response time. Zoo caches gists locally and tends to use the cached code and data rather than downloading them all the time.

To solve this problem, Zoo provides another parameter in the naming scheme: ``tol``. It is the threshold of a gist's *tolerance* of the time it exists on the local cache. Any gist that exists on a user's local cache for longer than ``tol`` seconds is deemed outdated and thus requires updating the latest ``vid`` information from the Gist server before being used. For example:

.. code-block:: ocaml

  #!/usr/bin/env owl
  #zoo "9f0892ab2b96f81baacd7322d73a4b08?tol=300"

  let _ = Coolmodule.sqr_magic 4 |> Owl.Mat.print


By setting the ``tol`` parameter to 300, Bob indicates that, if Zoo has already fetched the version information of this gist from remote server within the past 300 seconds, then keep using its local cache; otherwise contact the Gist server to check if a newer version is pushed. If so, the newest version is downloaded to local cache before being used. In the case where Bob don't want to miss every single update of Alice's gist code, he can simply set ``tol`` to 0, which means fetching the version information every time he executes his code.

``vid`` and ``tol`` parameters enable users to have fine-grained version control of Zoo gists. Of course, these two parameters should not be used together. When ``vid`` is set in a name, the ``tol`` parameter will be ignored. If both are not set, as shown in the previous code snippet, Zoo will use the latest locally cached version if it exists.


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


Note that both ``run`` and ``info`` commands accept a full gist name that can contain extra parameters, instead of only a gist id.


Examples
-------------------------------------------------

Despite of its simplicity, Zoo is a very flexible and powerful tool and we have been using it heavily in our daily work. We often use Zoo to share the prototype code and small shared modules which we do not want to bother OPAM, such those used in performance tests.

Moreover, many interesting examples are also built atop of Zoo system.

* `Google Inception V3 for Image Classification <https://gist.github.com/jzstark/9428a62a31dbea75511882ab8218076f>`_

* `Neural Style Transfer <https://gist.github.com/jzstark/6f28d54e69d1a19c1819f52c5b16c1a1>`_

* `Fast Neural Style Transfer <https://gist.github.com/jzstark/f937ce439c8adcaea23d42753f487299>`_

For example, you can use Zoo to perform DNN-based image classification in only 6 lines of code:

.. code-block:: ocaml

  #!/usr/bin/env owl
  #zoo "9428a62a31dbea75511882ab8218076f"

  let _ =
    let image  = "/path/to/your/image.png" in
    let labels = InceptionV3.infer image in
    InceptionV3.to_json ~top:5 labels


Please refer to the gist pages listed above and the `zoo demo website <http://demo.ocaml.xyz/zoo.html>`_ for more information.
