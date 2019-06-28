Frequently Asked Questions
==========================

Why do I get `Illegal instruction` error?
-----------------------------------------

The short answer is that the binary of Owl or the program using Owl have
been compiled on one platform and are run on another.

If you use opam or dune to install or build your code you can use ``OWL_CFLAGS``
to override the ``-march``-option that is used to build the binary, by default
it's set to ``native``, but if you want to maximize compatibility you should set
it to ``x86-64``:

.. code-block:: bash

  env OWL_CFLAGS="-g -O3 -Ofast -march=x86-64 -mfpmath=sse -funroll-loops -ffast-math -DSFMT_MEXP=19937 -msse2 -fno-strict-aliasing -Wno-tautological-constant-out-of-range-compare" opam install owl

If you use esy you can inject environment variables into the sandboxed build
environment using the ``resolutions`` field in you package.json:

.. code-block:: json

  {
    "resolutions": {
      "@opam/owl": {
        "source": "owlbarn/owl:owl.opam#7f6ae99",
        "override": {
          "buildEnv": {
            "OWL_CFLAGS": "-g -O3 -Ofast -march=x86-64 -mfpmath=sse -funroll-loops -ffast-math -DSFMT_MEXP=19937 -msse2 -fno-strict-aliasing -Wno-tautological-constant-out-of-range-compare"
          }
        }
      }
    }
  }

The somewhat longer answer is that some parts of Owl are written in C.  Since
Owl is trying to be as performant as possible it is compiled with the CFLAGS
option ``-march=native``. This tells GCC (the c compiler used) to use all
available instruction-sets the machine's current CPU supports aka make the
fastes binary possible. The downside of this is that the compiled binary may not
run on older CPUs.
