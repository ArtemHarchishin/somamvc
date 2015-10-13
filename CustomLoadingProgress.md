## Create a custom loading progress ##

#### 1. Use BasicLoading ####

When you load some pictures that are "image assets" in the XML Site Definition, you will see that Soma uses a loading progress display. This is the BasicLoading class exported by default with SomaUI.

YOUR\_PROJECT\_PATH/source/front-end/src/YOUR\_PACKAGE/loading/basicloading

You can change this class to fit your design. The loading display is part of the [SomaLoader](http://code.google.com/p/somaloader/) library.

#### 2. Start from scratch using SomaUI ####

Still using SomaUI, before exporting you can change, in the projects settings, the "Loading Class". The default is "basic.BasicLoading" which is creating the default Basic Loading. If you change this class name, you can replace "basic.BasicLoading" by "MyLoading", for example. It will create an empty Sprite that implements ILoading. You can then use that class to build your own loading display.

You will receive, in the methods required by the interface, the data needed to display the loading progress for each items or the queue.

#### 3. Start from scratch without SomaUI ####

See the [SomaLoader Loading Display page](http://code.google.com/p/somaloader/wiki/LoadingDisplay).