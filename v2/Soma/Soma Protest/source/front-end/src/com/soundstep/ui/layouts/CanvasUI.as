package com.soundstep.ui.layouts {
	import com.soundstep.ui.BaseUI;
	import com.soundstep.ui.ElementUI;
	import com.soundstep.ui.events.BaseEventUI;
	import com.soundstep.ui.layouts.core.Mask;
	import com.soundstep.ui.layouts.core.Wrapper;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;

	/**
	 * <b>Author:</b> Romuald Quantin - <a href="http://www.soundstep.com/" target="_blank">www.soundstep.com</a><br />
	 * <b>Class version:</b> 3.0.2<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 * <b>Copyright:</b>
	 * Creative Commons Attribution-ShareAlike 3.0 Unported License<br /> 
	 * <a href="http://creativecommons.org/licenses/by-sa/3.0/" target="_blank">http://creativecommons.org/licenses/by-sa/3.0/</a><br />
	 * You can use BaseUI in any flash site, except to include/distribute it in another framework, application, template, component or structure that is meant to build, scaffold or generate source files.<br />
	 * <br />
	 * <b>Date:</b> 08-2008<br />
	 * <b>Usage:</b><br />
	 * A CanvasUI layout container defines a rectangular region in which you place children DisplayObject. It is the only container that lets you explicitly specify the location of its children.<br>
	 * CanvasUI is a subclass of MovieClip, you have the choice to use addChild or addChildUI, this last method will automaticaly create an ElementUI instance and make you able to use properties like top, bottom, left, right and all other properties of the Element class.<br>
	 * Not only for the children, you can use the Element properties on the canvas itself, the difference with the ElementUI properties is that you have specific properties for the percentage size: percentWidth and percentHeight.<br>
	 * Methods to manage the ElementUI instances have been added, like for example getChildUI or removeChildUI.<br>
	 * The CanvasUI constructor takes 4 optionals parameters: width, height, layoutScroll and layout mask.<br>
	 * By default, CanvasUI build a mask to show only the content within the size specified and creates scrollbars (scrollpane instance) if the content is bigger than the size specified.<br>
	 * @example
	 * <listing version="3.0">
	 * // create layout
	 * var canvas:CanvasUI = new CanvasUI();
	 * addChild(canvas);
	 * canvas.canvasAlpha = .2;
	 * // add children
	 * var s:Sprite = new Sprite();
	 * s.name = "mySprite";
	 * s.graphics.beginFill(0x0000FF, .5);
	 * s.graphics.drawRect(0, 0, 150, 300);
	 * canvas.addChildUI(s);
	 * canvas.getChildUIByName("mySprite").right = 20;
	 * canvas.getChildUI(s).bottom = 20;
	 * var txt:TextField = new TextField();
	 * txt.name = "myTextField";
	 * txt.autoSize = TextFieldAutoSize.LEFT;
	 * txt.text = "TextField test";
	 * canvas.addChildUI(txt);
	 * canvas.getChildUIByName("myTextField").horizontalCenter = 0;
	 * canvas.getChildUI(txt).verticalCenter = 0;
	 * // change canvas ui property 
	 * canvas.ratio = ElementUI.RATIO_IN;
	 * canvas.properties = {top:10, bottom:10, left:10, right:10};
	 * </listing>
	 */
	 
	public class CanvasUI extends MovieClip {

		//------------------------------------
		// private properties
		//------------------------------------
		
		/** @private */
		// instance of the Sprite that contains all children added with addChild and addChildUI
		internal var _container:Sprite;
		/** @private */
		// instance of the Mask created to show only the content in the canvas
		internal var _layoutMask:Mask;
		/** @private */
		// instance of the Wrapper used to set the size and position of the canvas
		internal var _wrapper:Wrapper;
		/** @private */
		// BaseUI instance used for the children added with addChild and addChildUI
		internal var _baseUI:BaseUI;
		/** @private */
		// internal BaseUI instance used for the wrapper, the mask, the container and the scrollpane 
		internal var _internalBaseUI:BaseUI;
		// ElementUI instance of the wrapper
		/** @private */
		internal var _ui:ElementUI;
		// instance of the scrollpane
		/** @private */
		internal var _scrollPane:*;
		// color of the canvas background 
		private var _canvasColor:uint;
		// alpha of the canvas background
		private var _canvasAlpha:Number;

		//------------------------------------
		// public properties
		//------------------------------------
		
		
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		/**
		 * Constructor
		 * Create an instance of the CanvasUI class
		 * @param widthLayout width of the canvas
		 * @default 100 
		 * @param heightLayout height of the canvas 
		 * @default 100 
		 * @param layoutScrollbar whether or not the canvas creates and uses a mask to show only the content within the canvas
		 * @default true
		 * @param layoutMask whether or not the canvas creates and uses scrollbars if the content is bigger than the canvas (scrollpane instance)
		 * @default true
		 */
		public function CanvasUI(widthLayout:Number = 100, heightLayout:Number = 100, layoutScrollbar:Boolean = true, layoutMask:Boolean = true) {
			initCanvas(widthLayout, heightLayout, layoutScrollbar, layoutMask);
			super();
		}
		
		//
		// PRIVATE, PROTECTED, INTERNAL
		//________________________________________________________________________________________________
		
		/** @private */
		// initialize the variables of the canvas
		private function initCanvas(widthLayout:Number, heightLayout:Number, layoutScrollbar:Boolean = true, layoutMask:Boolean = true):void {
			_canvasColor = 0x000000;
			_canvasAlpha = 0;
			_wrapper = new Wrapper();
			_wrapper.name = "wrapper";
			drawWrapper(widthLayout, heightLayout);
			super.addChild(_wrapper);
			_container = new Sprite();
			_container.name = "container";
			super.addChild(_container);
			_internalBaseUI = new BaseUI(this);
			_internalBaseUI.autoRefresh = false;
			_baseUI = new BaseUI(this);
			_ui = _internalBaseUI.add(_wrapper);
			_ui.autoRefresh = false;
			_ui.addEventListener(BaseEventUI.UPDATED, updateUI);
			if (layoutScrollbar) buildScrollPane();
			if (layoutMask) buildMask(widthLayout, heightLayout);
		}
		
		/** @private */
		// build the scrollpane if the parameter layoutScroll in the constructor is set to true
		private function buildScrollPane():void {
			try {
				var ScrollPaneClass:Class = getDefinitionByName("fl.containers.ScrollPane") as Class;
				_scrollPane = new ScrollPaneClass();
				_scrollPane['name'] = "scrollPane";
				_scrollPane['source'] = _container;
				super.addChild(_scrollPane as DisplayObject);
				_internalBaseUI.add(_scrollPane as DisplayObject);
			}
			catch (e:Error) {
				if (e.errorID == 1065) {
					var msg:String = e + "\r";
					msg += "By default a ScrollPane component is built to handle the scroll, to use it you must import the ScrollPane class and skin.\r";
					msg += "Flash IDE: drag the component in the library.\r";
					msg += "Flex SDK: import a SWC containing the ScrollPane class and skin.\r";
					msg += "To avoid using the ScrollPane component, you can set the layoutScrollbar to false in the constructor, example: new CanvasUI(200, 200, false)";
					throw new Error(msg);
				}
				else throw e;
			}
		}
		
		/** @private */
		// build the mask if the parameter layoutMask in the constructor is set to true
		private function buildMask(maskWidth:Number, maskHeight:Number):void {
			_layoutMask = new Mask();
			_layoutMask.name = "layoutMask";
			_layoutMask.graphics.clear();
			_layoutMask.graphics.beginFill(0xFF0000, .5);
			_layoutMask.graphics.drawRect(0, 0, maskWidth, maskHeight);
			_layoutMask.graphics.endFill();
			super.addChild(_layoutMask);
			_internalBaseUI.add(_layoutMask);
			this.mask = _layoutMask;
		}

		/** @private */
		// redraw the wrapper
		private function drawWrapper(wrapperWidth:Number, wrapperHeight:Number):void {
			_wrapper.graphics.clear();
			_wrapper.graphics.beginFill(_canvasColor, _canvasAlpha);
			_wrapper.graphics.drawRect(0, 0, wrapperWidth, wrapperHeight);
			_wrapper.graphics.endFill();
		}
		
		/** @private */
		// update the mask and scrollpane instance to match the new size of the wrapper
		protected function updateUI(e:BaseEventUI = null):void {
			if (_layoutMask != null) {
				_internalBaseUI.getElement(_layoutMask).properties = _ui.properties;
			}
			if (_scrollPane != null) {
				_internalBaseUI.getElement(_scrollPane as DisplayObject).properties = _ui.properties;
				_scrollPane['refreshPane']();
			}
			else {
				_container.x = _wrapper.x;
				_container.y = _wrapper.y;
			}
		}
		
		/** @private */
		// check the percent value of percentWidth and percentHeight to match the Element syntax: "80%" 
		private function convertPercent(value:*):String {
			var percent:String = String(value);
			if (Number(percent) < 0) percent = String(Number(percent) * -1);
			if (percent.indexOf("%") == -1) percent += "%";
			return percent;
		}
		
		// PUBLIC
		//________________________________________________________________________________________________
		
		/**
		 * refresh the canvas elements and its children position
		 */
		public function refresh(e:BaseEventUI = null):void {
			_ui.forceRefresh();
			if (_layoutMask != null) _internalBaseUI.getElement(_layoutMask).refresh();
			if (_scrollPane != null) _internalBaseUI.getElement(_scrollPane as DisplayObject).refresh();
			else {
				_container.x = _wrapper.x;
				_container.y = _wrapper.y;
			}
		}
		
		/**
		 * function to force the size of the container (will update the scrollbars if used)
		 * @param width Number 
		 * @param height Number 
		 */
		public function forceSizeContainer(width:Number, height:Number):void {
			_container.graphics.clear();
			_container.graphics.beginFill(0xFFFF00, 0);
			_container.graphics.drawRect(0, 0, width, height);
			_container.graphics.endFill();
		}
		
		/**
		 * add a child DisplayObject instance to the canvas and create a ElementUI instance
		 * @param child DisplayObject 
		 * @return ElementUI instance of the DisplayObject
		 */
		public function addChildUI(child:DisplayObject):ElementUI {
			if (!_baseUI.contains(child)) {
				var el:ElementUI = _baseUI.add(child);
				el.name = child.name;
				el.reference = _wrapper;
				addChild(child);
				return el;
			}
			trace(child, " has been already added");
			return null;
		}
		
		/**
		 * remove a child from the BaseUI instance
		 * @param child DisplayObject 
		 */
		public function removeChildUI(child:DisplayObject):void {
			_baseUI.remove(child);
		}
		
		/**
		 * get a child ElementUI instance 
		 * @param child DisplayObject 
		 * @return ElementUI instance of the DisplayObject
		 */
		public function getChildUI(child:DisplayObject):ElementUI {
			return _baseUI.getElement(child);
		}
		
		/**
		 * get a child ElementUI instance using the name
		 * @param name String 
		 * @return ElementUI instance of the DisplayObject
		 */
		public function getChildUIByName(name:String):ElementUI {
			for each (var el:ElementUI in _baseUI.elements) {
				if (el.name == name) return el;
			}
			return null;
		}
		
		/**
		 * get a the wrapper ElementUI instance
		 * @return ElementUI instance of the Wrapper
		 */
		public function get ui():ElementUI {
			return _ui;
		}
		
		/**
		 * background color of the canvas
		 * @default uint 0x000000
		 * @return uint color
		 */
		public function get canvasColor():uint {
			return _canvasColor;
		}
		
		public function set canvasColor(canvasColor:uint):void {
			_canvasColor = canvasColor;
			drawWrapper(_wrapper.width, _wrapper.height);
		}
		
		/**
		 * background alpha of the canvas
		 * @default Number 0
		 * @return Number alpha
		 */
		public function get canvasAlpha():Number {
			return _canvasAlpha;
		}
		
		public function set canvasAlpha(canvasAlpha:Number):void {
			_canvasAlpha = canvasAlpha;
			drawWrapper(_wrapper.width, _wrapper.height);
		}
		
		/**
		 * get the instance of the container, it contains the children added with addChild and addChildUI
		 * @return Sprite instance of the container
		 */
		public function get container():Sprite {
			return _container;
		}
		
		/**
		 * get the instance of the scrollpane used for the scrollbars<br>
		 * you must cast the return: Scrollpane(canvas.scrollpane), the wild card has been used not to import the SCrollpane classes if not used
		 * @return Scrollpane instance of the container
		 */
		public function get scrollPane():* {
			return _scrollPane;
		}
		
		/**
		 * get the instance of the mask
		 * @return Mask
		 */
		public function get layoutMask():Mask {
			return _layoutMask;
		}
		
		/**
		 * get the instance of the wrapper
		 * @return Wrapper
		 */
		public function get wrapper():Wrapper {
			return _wrapper;
		}
		
		/**
		 * get the instance of the BaseUI class, used for the children added with addChild or addChildUI
		 * @return BaseUI
		 */
		public function get baseUI():BaseUI {
			return _baseUI;
		}
		
		/**
		 * width of the canvas
		 */
		override public function get width():Number {
			return _wrapper.width;
		}

		override public function set width(value:Number):void {
			_ui.width = value;
		}

		/**
		 * set the width percentage (will accept Number or String, with or without the percentage character
		 */
		public function set percentWidth(value:*):void {
			_ui.width = convertPercent(value);
		}

		/**
		 * height of the canvas
		 */
		override public function get height():Number {
			return _wrapper.height;
		}

		override public function set height(value:Number):void {
			_ui.height = value;
		}

		/**
		 * set the height percentage (will accept Number or String, with or without the percentage character
		 */
		public function set percentHeight(value:*):void {
			_ui.height = convertPercent(value);
		}

		/**
		 * x position of the canvas, Number or String
		 */
		override public function get x():Number {
			return _wrapper.x;
		}

		override public function set x(value:Number):void {
			_ui.x = value;
		}

		/**
		 * y position of the canvas
		 */
		override public function get y():Number {
			return _wrapper.y;
		}

		override public function set y(value:Number):void {
			_ui.y = value;
		}

		/**
		 * top value (from the reference), Number or String
		 */
		public function get top():Number {
			return _ui.top;
		}

		public function set top(value:*):void {
			_ui.top = value;
		}

		/**
		 * bottom value (from the reference), Number or String
		 */
		public function get bottom():Number {
			return _ui.bottom;
		}

		public function set bottom(value:*):void {
			_ui.bottom = value;
		}

		/**
		 * left value (from the reference), Number or String
		 */
		public function get left():Number {
			return _ui.left;
		}

		public function set left(value:*):void {
			_ui.left = value;
		}
		
		/**
		 * right value (from the reference), Number or String
		 */
		public function get right():Number {
			return _ui.right;
		}

		public function set right(value:*):void {
			_ui.right = value;
		}
		
		/**
		 * horizontal center value (from the reference), Number or String
		 */
		public function get horizontalCenter():Number {
			return _ui.horizontalCenter;
		}

		public function set horizontalCenter(value:*):void {
			_ui.horizontalCenter = value;
		}

		/**
		 * vertical center value (from the reference), Number or String
		 */
		public function get verticalCenter():Number {
			return _ui.verticalCenter;
		}

		public function set verticalCenter(value:*):void {
			_ui.verticalCenter = value;
		}
		
		/**
		 * type of ratio of the CanvasUI, can be ElementUI.RATIO_IN or ElementUI.RATIO_OUT<br/>
		 * any other String will set the ratio to none <br/>
		 * the following properties cannot be set or are not used a ratio has been specified:<br/>
		 * x, y, width, height, horizontalCenter and verticalCenter 
		 */
		public function get ratio():String {
			return _ui.ratio;
		}

		public function set ratio(value:String):void {
			_ui.ratio = value;
		}
		
		// TODO: create Properties class
		/**
		 * Object to get or set the CanvasUI properties, for example:<br/>
		 * <code>element.properties = {top:0, bottom:"20", onStage:false, width:"50%"};</code>
		 */
		public function get properties():Object {
			return _ui.properties;
		}

		public function set properties(prop:Object):void {
			_ui.properties = prop;
		}
		
		/**
		 * horizontal alignment when the property ratio is set to ElementUI.RATIO_IN or ElementUI.RATIO_OUT<br/>
		 * can accept ElementUI.ALIGN_LEFT, ElementUI.ALIGN_RIGHT, ElementUI.ALIGN_CENTER
		 */
		public function get alignX():String {
			return _ui.alignX;
		}

		public function set alignX(value:String):void {
			_ui.alignX = value;
		}
		
		/**
		 * vertical alignment when the property ratio is set to ElementUI.RATIO_IN or ElementUI.RATIO_OUT<br/>
		 * can accept ElementUI.ALIGN_CENTER, ElementUI.ALIGN_TOP, ElementUI.ALIGN_BOTTOM 
		 */
		public function get alignY():String {
			return _ui.alignY;
		}

		public function set alignY(value:String):void {
			_ui.alignY = value;
		}
		
		/**
		 * whether or not the DisplayObject will be resized (not working with ratio set to RATIO_IN or RATIO_OUT)
		 */
		public function get bypassSize():Boolean {
			return _ui.bypassSize;
		}

		public function set bypassSize(value:Boolean):void {
			_ui.bypassSize = value;
		}
		
		/**
		 * width of the DisplayObject when added to the BaseUI instance
		 */
		public function get initialWidth():Number {
			return _ui.initialWidth;
		}

		public function set initialWidth(value:Number):void {
			_ui.initialWidth = value;
		}
		
		/**
		 * keep a DisplayObject in the screen
		 */
		public function get keepOnScreen():Boolean {
			return _ui.keepOnScreen;
		}

		public function set keepOnScreen(value:Boolean):void {
			_ui.keepOnScreen = value;
		}
		
		/**
		 * set the stage as a reference to calculate position ans sizes, if false the parent will be the reference
		 */
		public function get onStage():Boolean {
			return _ui.onStage;
		}

		public function set onStage(value:Boolean):void {
			_ui.onStage = value;
		}
		
		/**
		 * specify a DisplayObjectContainer reference on which the size and position of the ElementUI will refer to<br/>
		 * if not set, the onStage property value is the reference (onStage true = stage, onStage false = parent)
		 */
		public function get reference():DisplayObjectContainer {
			return _ui.reference;
		}

		public function set reference(value:DisplayObjectContainer):void {
			_ui.reference = value;
		}
		
		/**
		 * use the size that has been recorded when the DisplayObject has been added to the BaseUI instance<br/>
		 * useful when a mask or other DisplayObject can disturb the real size of the DisplayObject 
		 */
		public function get useInitialSize():Boolean {
			return _ui.useInitialSize;
		}

		public function set useInitialSize(value:Boolean):void {
			_ui.useInitialSize = value;
		}
		
		/**
		 * force the width of the reference
		 */
		public function get forceReferenceWidth():Number {
			return _ui.forceReferenceWidth;
		}

		public function set forceReferenceWidth(value:Number):void {
			_ui.forceReferenceWidth = value;
		}
		
		/**
		 * force the height of the reference
		 */
		public function get forceReferenceHeight():Number {
			return _ui.forceReferenceHeight;
		}

		public function set forceReferenceHeight(value:Number):void {
			_ui.forceReferenceHeight = value;
		}
		
		/**
		 * Adds a child DisplayObject instance to this CanvasUI container
		 * @param child DisplayObject
		 * @return DisplayObject
		 */
		override public function addChild(child:DisplayObject):DisplayObject {
			return _container.addChild(child);
		}
		
		/**
		 * Removes the specified child DisplayObject instance from the child list of the CanvasUI container
		 * @param child DisplayObject
		 * @return DisplayObject
		 */
		override public function removeChild(child:DisplayObject):DisplayObject {
			return _container.removeChild(child);
		}
		
		/**
		 * Returns the child display object that exists with the specified name
		 * @param name String
		 * @return DisplayObject
		 */
		override public function getChildByName(name:String):DisplayObject {
			return _container.getChildByName(name);
		}
		
		/**
		 * Returns the index position of a child DisplayObject instance
		 * @param child DisplayObject
		 * @return int
		 */
		override public function getChildIndex(child:DisplayObject):int {
			return _container.getChildIndex(child);
		}
		
		/**
		 * Changes the position of an existing child in the CanvasUI container
		 * @param child DisplayObject
		 * @param index int new depth
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void {
			_container.setChildIndex(child, index);
		}
		
		/**
		 * Adds a child DisplayObject instance to the CanvasUI container
		 * @param child DisplayObject
		 * @param index int depth
		 * @return DisplayObject
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			return _container.addChildAt(child, index);
		}
		
		/**
		 * Determines whether or not the specified display object is a child of the CanvasUI container or the instance itself
		 * @param child DisplayObject
		 * @return Boolean
		 */
		override public function contains(child:DisplayObject):Boolean {
			return _container.contains(child);
		}
		
		/**
		 * Returns the number of children of the CanvasUI container
		 * @return int
		 */
		override public function get numChildren():int {
			return _container.numChildren;
		}
		
		/**
		 * Swaps the z-order (front-to-back order) of the child objects at the two specified index positions in the child list.
		 * @param index1 int
		 * @param index2 int
		 */
		override public function swapChildrenAt(index1:int, index2:int):void {
			_container.swapChildrenAt(index1, index2);
		}
		
		/**
		 * Returns the child display object instance that exists at the specified index
		 * @param index int
		 * @return DisplayObject
		 */
		override public function getChildAt(index:int):DisplayObject {
			return _container.getChildAt(index);
		}
		
		/**
		 * Swaps the z-order (front-to-back order) of the two specified child objects
		 * @param child1 DisplayObject		 * @param child2 DisplayObject
		 */
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void {
			_container.swapChildren(child1, child2);
		}
		
		/**
		 * Determines whether or not the children of the object are mouse enabled
		 * @return Boolean
		 */
		override public function get mouseChildren():Boolean {
			return _container.mouseChildren;
		}
		
		override public function set mouseChildren(value:Boolean):void {
			_container.mouseChildren = value;
		}
		
		/**
		 * Specifies the button mode of this sprite
		 * @return Boolean
		 */
		override public function get buttonMode():Boolean {
			return _container.buttonMode;
		}
		
		override public function set buttonMode(value:Boolean):void {
			_container.buttonMode = value;
		}
		
		/**
		 * Removes a child DisplayObject from the specified index position in the child list of the DisplayObjectContainer
		 * @param index int
		 * @return DisplayObject
		 */
		override public function removeChildAt(index:int):DisplayObject {
			return _container.removeChildAt(index);
		}

	}
}