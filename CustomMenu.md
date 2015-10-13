## Make a custom menu ##

#### 1. Use BasicMenu ####

SomaUI by default is exporting a basic menu, useful for development or to start with. This is located in this folder:

YOUR\_PROJECT\_PATH/source/front-end/src/YOUR\_PACKAGE/menu/basicmenu/

You can change this menu to fit your design. You will find the CSS styles used in the global stylesheet SomaUI is exporting (www/css/flash\_global.css).

```
.menuItem {
   font-family: "Arial";
   font-size: 8;
}
.colorMenuItemOut {
   color: #D3D3D3;
}
.colorMenuItemOver {
   color: #FFFFFF;
}
```

#### 2. Start from scratch using SomaUI ####

Still using SomaUI, before exporting you can change, in the projects settings, the "Menu Class". The default is "basic.BasicMenu" which is creating the default Basic Menu. If you change this class name, you can replace "basic.BasicMenu" by "MyMenu", for example. It will create an empty Menu class (that extends Sprite) and that implements IMenu. You can then use that class to build your own menu.

Note: if you want to make it dynamic with the XML, you can retrieve the XML Site Definition this way:

```
Soma.getInstance().content.data
```

And open pages this way:

```
new PageEvent(PageEvent.SHOW, "myPageID").dispatch();
```

You will receive updates from the framework in the OpenMenu method, for example when the URL change when press back and forward in the browser. You will receive the ID of the current page so you can update you menu accordingly.

#### 3. Start from scratch without SomaUI ####

To build you own menu class, you must create a class that extends com.soma.view.Menu and implements com.soma.interfaces.IMenu. Let's use a MyMenu.as class in this example.

The interface IMenu has only one function to implement:

```
function openMenu(id:String):void;
```

You will receive updates from the framework in the OpenMenu method, for example when the URL change when press back and forward in the browser. You will receive the ID of the current page so you can update you menu accordingly.

There is two steps more to register the menu with Soma. In the config file you're using with Soma, usually "/source/front-end/YOUR\_PACKAGE/Config.as"

  * 1. import the menu class:
```
Soma.getInstance().registerClass(MyMenu);
```

  * 2. return the menu class name in the method required:
```
public function get menuClassName():String {
    return "MyMenu";
}
```