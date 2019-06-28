# Owl Tutorial Book and API Reference

Owl is a scientific computing library developed in the OCaml language. This repository contains the parser and tools to automatically build up the API Reference and Tutorial book for [Owl](https://github.com/ryanrhymes/owl).

The built documentation is hosted on [owlbarn.github.io](https://owlbarn.github.io/) and [my lab page](http://www.cl.cam.ac.uk/~lw525/owl/). If you want to build a local copy of the whole documentation, please refer to the following instructions.


## Instructions

**Step 1**: You need to clone Owl's code repository from the Github, because the source files are needed to build up the documentation. The parser needs to parse both `ml` and `mli` files.
You also needs owl-ode's code repository right next to.

```bash
git clone https://github.com/owlbarn/owl.git
git clone https://github.com/owlbarn/owl_ode.git
```

**Step 2**: Install Owl library. The parser needs to call a couple of functions from Owl library so you need to install Owl locally. Please refer to Owl's documentation to see how to install.

**Step 3**: Install Sphinx and plugin. You can use for example `pip` to install them. Python 2.7 should work fine. Owl uses `sphinxcontrib.bibtex` to generate bibliography.

```bash
pip install sphinx
pip install sphinxcontrib.bibtex
```

**Step 4**: When you finish installing all the dependencies, you need some configuration so the parser can find the Owl's source files. Open `Makefile` and edit the second line to make sure `API_SRC` points to the Owl's `src` folder. The following is an example on my laptop.

```bash
# Please only configure API_SRC to point to correct Owl src folder.
API_SRC="/Users/liang.wang/code/owl/src/"
...
```

**Step 5**: Building is simple, simple enter the `owl_guide` root directory, then `make`.

```bash
cd ./owl_guide
make
```

**Step 6**: The script will build both API Reference and Tutorial book locally. To check the building result locally, you can use a browser open the `index.html` saved in the `_build` folder.

```bash
open book/_build/html/index.html
```


## Submit Pull-Request

When you are happy with your edits and how they look on the local copy, it is ready to go for a pull-request. Before you submit the pull-request, you need to first fork [owlbarn.github.io](https://github.com/owlbarn/owlbarn.github.io) to your own github account.

Then you need to install `hub` tool which is an extension of `git`. On Mac OSX, you can use brew to install it.

```bash
brew install hub
```

Then you can simply enter the following command in the `owl_guide` root directory.

```bash
make pull-request
```

It might take a while but you can soon see your pull-request on [this page](https://github.com/owlbarn/owlbarn.github.io/pulls). After I merge these requests, you can immediately see your edits appeared on [owlbarn.github.io](https://owlbarn.github.io/). Hurray!


## Other Formats

Sphinx allows you to build the documentation in other formats such as PDF. In this case, you need to enter into `book` subdirectory and build from there. Type `make` and you can see different options. E.g, build the documentation in PDF will look like this.


```bash
make latexpdf
```


## How to Contribute

It is highly appreciated if you can help me in improving Owl's documentation, it benefits the whole community of functional languages and scientific computing.

* If you want to improve the Tutorial Book, you need to edit the files in `owl_guide/book/chapter` directly in [this repo](https://github.com/owlbarn/owl_guide). Then submit the PR and I will review it.

* If you want to improve the API Reference, you need to edit the corresponding `mli` files in [Owl's repo](https://github.com/owlbarn/owl) then submit the PR to source code repository.
