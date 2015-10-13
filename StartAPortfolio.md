## How to start a portfolio with SomaUI ##

Here are two different ways to start a portfolio and show a thumbnail, how you show and animate the pictures will be up to you.

1. Method one, load a bunch of pictures dynamically from the XML

  * open SomaUI
  * create a new project
  * paste the following XML in the XML Site Definition tab
  * export the project
  * in the folder where you have exported the project ("YOUR\_PROJECT\_PATH/www/images/"), add 6 images in the images folder, named thumb1.jpg, thumb2.jpg, thumb3.jpg, etc

```
    <?xml version="1.0" encoding="UTF-8"?>
    <site>
      <page id="Portfolio" type="Portfolio" urlfriendly="Portfolio">
        <title><![CDATA[Portfolio]]></title>
        <content>
          <text id="portfolio intro" x="130" y="70" style="body" multiline="true" wordWrap="true" width="370"><![CDATA[
              Art is the process or product of deliberately arranging elements
              in a way that appeals to the senses or emotions.]]></text>
          <text id="portfolio title" x="130" y="25" style="title"><![CDATA[Portfolio]]></text>
          <image id="thumb1" file="images/thumb1.jpg" x="130" y="160"/>
          <image id="thumb2" file="images/thumb2.jpg" x="300" y="160"/>
          <image id="thumb3" file="images/thumb3.jpg" x="470" y="160"/>
          <image id="thumb4" file="images/thumb4.jpg" x="640" y="160"/>
          <image id="thumb5" file="images/thumb5.jpg" x="130" y="270"/>
          <image id="thumb6" file="images/thumb6.jpg" x="300" y="270"/>
        </content>
      </page>
    </site>
```

In this way, you are loading external pictures. Alternatively, you can use the a bitmap or movieclip XML node instead of an image XML node, and import images in the Main Flash file (/source/front-end/src/Main.fla), or create MovieClip with the right linkage name.

See the [Soma Protest Assets page](http://www.soundstep.com/somaprotest/www/#/assets/) for more information.

2. Method two, only for Flash IDE user, here is another approach that doesn't require any code (not dynamic). The principle is using a MovieClip as a page, and build and animate your portfolio inside Flash.

  * open SomaUI
  * create a new project
  * paste the following XML in the XML Site Definition tab
  * export
  * open /source/front-end/src/Main.fla
  * open the page folder in the Flash library and open your MovieClip page "Portfolio"
  * add your images on the stage (in the MovieClip Portfolio) and animate them with the timeline for example
  * compile from Flash (ctrl + Enter, cmd + Enter)

```
    <?xml version="1.0" encoding="UTF-8"?>
    <site>
      <page id="Portfolio" type="Portfolio" urlfriendly="Portfolio" movieclip="true">
        <title><![CDATA[Portfolio]]></title>
      </page>
    </site>
```