Run Your Owl Computation on TensorFlow
===========================================

After two years of intense development, Owl has achieved a full stack support for numerical computing and analysis. It provides clean syntax and powerful functionalities such as linear algebra, algorithmic differentiation, and deep neural network.
We've also made a lot of efforts in improving its performance towards state of the art.
Now we turn to computation interoperability with existing libraries such as TensorFlow.
The target is to have the best of both worlds.
On one hand, we can define "how to compute" on Owl with its elegant and powerful syntax;
on the other hand, we can execute the computation efficiently across various hardware devices, such as GPU and TPU, that TensorFlow supports (standing on Google' shoulders).


Computation Graph as an Intermediate Representation
---------------------------------------------------

Recent efforts such as `ONNX <https://onnx.ai/>`_ and `NNEF <https://www.khronos.org/nnef>`_ aim to provide a standard exchange format for neural network interoperability across various platforms.
However, we believe that, despite the wide application of Deep Neural Network (DNN) and Machine Learning, computation graph, instead of neural network, should be the fundamental abstraction for exchanging computation between frameworks.

A *computation graph* (CGraph) is a way to represent a function in the form of graph. In a CGraph, nodes are either input values or functions for processing values. A node's incoming and outgoing links are its input and output.
It is widely used as an intermediate representation of computation in current systems.
TensorFlow uses `graph <https://www.tensorflow.org/guide/graphs>`_ to represent its computation, with support of nearly a thousand operations.
Similar graph model is also adopted by `CUDA <https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#cuda-graphs>`_. The practise of separating graph definition and execution on CUDA enables a number of optimisation opportunities.
Even the neural network standards themself use computation graph as a fundamental building blocks, as can be seen from, e.g. the `NNEF specification <https://www.khronos.org/registry/NNEF/specs/1.0/nnef-1.0.html#fundamentals>`_.
Last but not the least, Owl also provides support for CGraph in the form of a stack of functors. See `doc <http://ocaml.xyz/chapter/cgraph_intro.html>`_ for more information.


Design and Implementation
---------------------------------------------------

Now that we decide to use CGraph as the intermediate representation to transfer computation, the next question is, how?
Since TensorFlow's Python library interfaces to its C++ implementation, one possible way then is to provide similar interfaces for Owl.
Sounds doable, but may need some significant engineering effort.

We instead utilise the `Save and Restore <https://www.tensorflow.org/guide/saved_model>`_ mechanism in TensorFlow.
It provides methods for loading CGraph definition from a metagraph file. All we need to do now is to generate this metagraph file from Owl CGraph.
Towards this end, we are building an experimental system **converter**.
It aims to export CGraph defined in Owl and execute it in TensorFlow.
Its workflow is simple:

1. define a CGraph in Owl;
2. convert this graph into a ``tensorflow_cgraph`` in converter (explained later);
3. parse this ``tensorflow_cgraph`` into string format and write to a ``.pbtxt`` file;
4. load the ``.pbtxt`` file into TensorFlow using its Save/Restore mechanism.

Note that currently we only focus on the case of executing one CGraph once, instead of iteratively re-evaluating it (as in the case of DNN training). Also we do not consider pass data from Owl to TensorFlow.

In designing the system, we start with the abstraction of TensorFlow CGraph. Unlike Owl CGraph, which is amlost a plain graph structure, a `TensorFlow CGraph <https://www.tensorflow.org/api_guides/python/meta_graph>`_ contains more meta information, which consists of four parts:

.. code-block:: ocaml

    type tensorflow_cgraph = {
        mutable tfmeta  : tfmeta;   (* MetaInfoDef *)
        mutable tfgraph : tfgraph;  (* GraphDef *)
        mutable tfsaver : tfsaver;  (* SaverDef *)
        mutable tfcolls : tfcolls;  (* CollectionDef *)
    }


The ``MetaInforDef`` contains operations used in a CGraph, and meta information such as version number.
The ``SaverDef`` specifies checkpoint file name, which operation to run when saving and loading variables, and then maximum number of checkpoints to keep, etc.
The ``CollectionInfo`` is for collecting certain nodes and variables in the graph.
The core part of the whole graph lies in ``GraphDef``. It is an array of TensorFlow operation nodes, each has its own attributes.

Note that the mapping between Owl CGraph nodes and TensorFlow nodes is not very straightforward.
For many math operations such as ``sin`` and ``mul``, a one-to-one projection suffices.
But there are also other cases where multiple Owl operations map to one TensorFlow operation, or the other way around: one Owl operation to multiple Tensorflow ones, sometimes with modification of parameters.

So the most important part of the converter is proper representation of TensorFlow nodes, each as a stand-alone module.
Above this layer, we specify the rules about how each Owl node should be mapped to TensorFlow node(s).
Given a Owl CGraph, the converter traverses the whole graph and maps the Owl nodes one by one according to those rules.
Besides, we apply a simple naming rule for each node.
For Owl's node, they are each assigned a unique id. If not specifically named by user, they are named in the format of ``owlnode+id``. During the Owl-to-TensorFlow node mapping, if it's a one-to-one mapping, the name stays unchanged, otherwise the new nodes will be named in the format of ``owlname+id/subnode_type_and_id``.


Examples
---------------------------------------------------

In the rest of this section, we assume you have basic understanding of both Owl and TensorFlow, especially with its `algorithmic differentiation <http://ocaml.xyz/chapter/algodiff.html>`_, `lazy evaluation <http://ocaml.xyz/chapter/cgraph_intro.html>`_ and `computation graph <http://ocaml.xyz/chapter/cgraph_intro.html>`_.

Example 1: Simple Math Operations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First, let's look at a simple example.
Suppose we want to construct such a computation: ``f(x, y) = 2 * (x * W + y) + 1``, where ``x`` and ``W`` are matrices and ``y`` is a float number. We can construct the CGraph in this way:

.. code-block:: ocaml

    module N = Dense.Ndarray.S
    module G = Owl_computation_cpu_engine.Make (N)
    include Owl_algodiff_generic.Make (G)

    let f x y =
      let weight = Mat.ones 3 3 in
      Maths.( (pack_flt 2.) * (x *@ weight + y) + (pack_flt 1.))

    let x = G.var_arr "x" |> pack_arr
    let y = G.var_elt "y" |> pack_elt
    let z = f x y

    let output = [| unpack_arr z |> G.arr_to_node |]
    let input  = [|
      unpack_arr x |> G.arr_to_node;
      unpack_elt y |> G.elt_to_node
    |]
    let g = G.make_graph ~input ~output "example_graph"


We first define a function ``f``, then two input placeholders ``x`` and ``y``. After getting the computing output ``z``, we create a CGraph ``g`` by linking output and input nodes together.
To convert this graph into a ``pbtxt`` file, we simply use the converter with one line of code:

.. code-block:: ocaml

    module T = Owl_converter.Make (G)

    let pbtxt = T.(convert g |> to_pbtxt)
    let _ = Owl_io.write_file "test_cgraph.pbtxt" pbtxt


It uses two APIs provided by the converter: ``convert`` creates a ``tensorflow_cgraph``, and then ``to_pbtxt`` parses this graph into string format.

Then we turn to the Python script:

.. code-block:: python

    filename = 'test_cgraph'
    with open(filename + '.pbtxt', 'r') as f:
        metagraph_def = tf.MetaGraphDef()
        file_content = f.read()
        text_format.Merge(file_content,metagraph_def)

        graph_io.write_graph(metagraph_def,
            os.path.dirname(filename),
            os.path.basename(filename) + '.pb',
            as_text=False)


This snippet reads the generated ``test_cgraph.pbtxt`` file into a MetaGraph data structure, then serialize it to a protobuf binary file.
This file can be loaded by the model saver of TensorFlow, as shown below:

.. code-block:: python

    with tf.Graph().as_default():
        sess = tf.Session()
        saver = tf.train.import_meta_graph('test_cgraph.pb')
        graph = tf.get_default_graph()

        x = graph.get_tensor_by_name('x:0')
        y = graph.get_tensor_by_name('y:0')
        z = tf.get_collection("result")[0]

        init = tf.global_variables_initializer()
        sess.run(init)

        x_data = np.ones((3, 3))
        y_data = 2.
        result = sess.run(z, feed_dict={x:x_data, y:y_data})


After the graph is loaded into a TensorFlow session, we can get its inputs by names (assuming they are already known), get the output from the "result" collection, and then proceed to evaluation with ``sess.run()``.
The full code of this example is listed `here <https://gist.github.com/jzstark/c35847ca2ace09af7bf617b704ce5c95>`_.

Example 2: Deep Neural Network Inference
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Next, let's look at some more real-world examples. The code structure keeps similar. Please follow provided links to check the code if you are interested.
Again, in all these examples, we define a CGraph in Owl and execute it in TensorFlow.

The second example is `DNN inference <https://gist.github.com/jzstark/1ceebcdbdeee1ada39e9df4a8819c532>`_. Here the CGraph is defined by constructing a VGG-like DNN in Owl.
As shown in the figure below, it represents a typical CGraph structure used in DNN.

.. figure:: ../figure/graphdef_mnist.svg
   :width: 100%
   :align: center
   :alt: MNIST_OWL

As shown below, the converted Tensorflow CGraph looks similar when imported and shown in TensorBoard, the visualisation tool of TensorFlow.
The only difference is that one Owl node tends to be converted to multiple TensorFlow nodes, and extra nodes are also required to be added for saving and loading variables.

.. figure:: ../figure/graphdef_mnist_tf.png
   :width: 100%
   :align: center
   :alt: MNIST_TF

Example 3: Periodic Oscillator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The third example is a simple `periodic oscillator <https://gist.github.com/jzstark/aa4fa6e82667d4fc89214e47febfafb1>`_.
This example covers a different set of operations than the previous one, and contains a loop structure.
In this case, we use a loop size of three, so you may notice that the whole graph consists of three identical sub-graphs.

.. figure:: ../figure/graphdef_oscillator.svg
   :width: 100%
   :align: center
   :alt: MNIST_OWL

Example 4: Higher-Order Derivatives
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the `final example <https://gist.github.com/jzstark/80a0c6d9d861cb7b48d11ec162d2a129>`_, we first define a function ``f0``, then construct the computation graph of from the first to the fourth derivative by calling ``diff`` function from Owl's algorithmic differentiation module.
If you are interested enough to look at the code, you will see how easy it is to construct this graph of derivatives.
The graph is shown as below. What's different in this graph is that it contains multiple outputs.

.. figure:: ../figure/graphdef_diff.svg
   :width: 100%
   :align: center
   :alt: Graphdef_diff

These functions are then evaluated in TensorFlow, and drawn in the same Python script as below:

.. figure:: ../figure/graphdef_algdiff.png
   :width: 80%
   :align: center
   :alt: Algodiff_derivatives


Next Step
---------------------------------------------------

Currently the system is still in initial development phase so there still remains a lot to do.
Not all Owl CGraph nodes are supported. Besides, iteratively updating variable and passing data from Owl to TensorFlow is not yet considered.
Tools such as Python script automatic generation will further simplified the process. They should be provided separately.
Also, operations such as condition and loop that are not yet supported in Owl CGraph, but nevertheless important. How to support these operations needs some further thought.

But in general, the current progress looks promising. If you are interested, please try the converter with provided examples and example of your own if you like. The dev code is maintained on ``graphdef`` branch of Owl.
Currently we are looking at polishing the system with more application examples, and any help and feedback would be much appreciated.
