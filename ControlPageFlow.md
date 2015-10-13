## How to control the Soma Page Flow ##

You might want in your Soma site to show or not to show pages in some case, for example for if the person is not logged in, or if you want to show a disclaimer before, or for any reason.

It is very easy to control the page flow by adding a listener to Soma and make specific actions in the handler.

In this example, we have a site with 4 pages that have an id of "Page1", "Page2", "Page3" and "Page4" in the XML Site Definition. We are going to monitor the page changes and never showing the page 4, instead we will redirect the user to the page 2.

Here is the XML Site Definition:

```
<?xml version="1.0" encoding="UTF-8"?>
<site>
    <page id="Page1" type="Page1" urlfriendly="page1">
        <title><![CDATA[Page 1]]></title>
        <content>
            <text id="title page 1" style="title" x="130" y="20"><![CDATA[Title Page 1]]></text>
        </content>
    </page>
    <page id="Page2" type="Page2" urlfriendly="page2">
        <title><![CDATA[Page 2]]></title>
        <content>
            <text id="title page 2" style="title" x="130" y="20"><![CDATA[Title Page 2]]></text>
        </content>
    </page>
    <page id="Page3" type="Page3" urlfriendly="page3">
        <title><![CDATA[Page 3]]></title>
        <content>
            <text id="title page 3" style="title" x="130" y="20"><![CDATA[Title Page 3]]></text>
        </content>
    </page>
    <page id="Page4" type="Page4" urlfriendly="page4">
        <title><![CDATA[Page 4]]></title>
        <content>
            <text id="title page 4" style="title" x="130" y="20"><![CDATA[Title Page 4]]></text>
        </content>
    </page>
</site>
```

To achieve this, we first add an event listener to Soma (PageEvent.STARTED). We can do that anywhere in the code, but the simplest is doing that in the Main class. This event occurs before that the Page Manager takes the decision to do anything (like showing the page requested).

```
Soma.getInstance().addEventListener(PageEvent.STARTED, pageEventHandler);
```

Next step is creating the event handler and get 2 important information: the current page displayed and the page that is going to be displayed.

```
private function pageEventHandler(event:PageEvent):void {
    trace(">>> Page Event");
    if (Soma.getInstance().page.currentPage != null) {
        trace("Soma current page is: ", Soma.getInstance().page.currentPage.id);
    }
    trace("Soma is about to show the page: ", event.id);
}
```

Next step is do something when the user is requesting to see the Page 4. We first stop the page flow by preventing the PageManager to make its default action: showing the page. And, when the flow is stopped, we make the PageManager showing the Page 2.

Here is the final code:

```
private function pageEventHandler(event:PageEvent):void {
    trace(">>> Page Event");
    if (Soma.getInstance().page.currentPage != null) {
        trace("Soma current page is: ", Soma.getInstance().page.currentPage.id);
    }
    trace("Soma is about to show the page: ", event.id);
    // specific action
    if (event.id == "Page4") {
        trace("    Page 4 found! I don't want to show that page.");
        event.preventDefault();
        trace("    Show me the Page 2 instead.")
        new PageEvent(PageEvent.SHOW, "Page2").dispatch();
    }
}
```

## Reproduce this tutorial ##

  1. Get [SomaUI](http://www.soundstep.com/blog/source/somaui/soma.zip)
  1. Create a New Project
  1. Set a Project Path in the Project Settings tab (and optionally a project package)
  1. Go to the XML Site Definition tab and paste the XML at the top of this tutorial
  1. Go to the Export tab and click on "Export all and compile"
  1. Open the Main document class (/source/front-end/src/YOUR\_PROJECT\_PACKAGE/Main.as)
  1. Paste the code from the tutorial
  1. Compile again with SomaUI, Flash or the Flex SDK