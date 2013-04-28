package haxe.ui.core;

import haxe.ui.containers.ListView;
import haxe.ui.containers.ScrollView;
import haxe.ui.layout.Layout;
import nme.Assets;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.IEventDispatcher;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.style.StyleHelper;
import haxe.ui.style.StyleManager;

class Component implements IEventDispatcher {
	private var childComponents:Array<Component>;
	
	public var id:String;
	public var sprite(getSprite, null):Sprite;
	public var x(getX, setX):Float = 0;
	public var y(getY, setY):Float = 0;
	public var width(getWidth, setWidth):Float = 0;
	public var height(getHeight, setHeight):Float = 0;
	public var percentWidth:Int = -1;
	public var percentHeight:Int = -1;
	public var visible(getVisible, setVisible):Bool;
	public var innerWidth(getInnerWidth, null):Float;
	public var innerHeight(getInnerHeight, null):Float;
	public var enabled(default, setEnabled):Bool = true;
	public var text(getText, setText):String = "";
	
	private var stateNames:Array<String>;
	public var registeredStateNames(getRegisteredStateNames, null):Array<String>;
	private var stateStyles:Hash<Dynamic>;
	public var currentStyle(getCurrentStyle, setCurrentStyle):Dynamic;
	
	public var stageX(getStageX, null):Float;
	public var stageY(getStageY, null):Float;

	public var horizontalAlign:String;
	public var verticalAlign:String;
	
	public var parent:Component;
	public var root:Root;
	
	public var ready:Bool = false;
	public var autoSize:Bool = true;
	
	public static var invalidationCount:Int = 0; // debug/optimization
	
	private var rawX:Float = 0; // x value used in setter 
	private var rawY:Float = 0; // y value user in setter
	
	private var childrenToAdd:Array<Dynamic>; // TODO: this is a workaround so you can add children before the parent is ready

	private var eventListeners:Hash < List < Dynamic->Void >> ;
	private var eventListenersCopy:Hash < List < Dynamic->Void >> ; // when we disable a component we will hold onto a subset of event listeners so if we reenable it everything works
	
	public var styles:String;
	public var layout:Layout;
	
	public function new() {
		registerState("normal");
		childComponents = new Array<Component>();
		eventListeners = new Hash < List < Dynamic->Void >>();
		sprite = new Sprite();
		
		addEventListener(Event.ADDED_TO_STAGE, onReady);
		layout = new Layout();
	}
	
	public function invalidate(recursive:Bool = true):Void {
		invalidateSize(recursive);
	}
	
	public function invalidateSize(recursive:Bool = true):Void {
		if (ready == false) {
			return;
		}

		var skipInvalidate:Bool = false;
		if (parent != null) {
			if (percentWidth > 0) {
				var ucx:Float = parent.getUsableWidth(this);
				var newWidth:Float = Std.int(ucx * percentWidth / 100);
				if (newWidth != width && newWidth > -1) {
					skipInvalidate = true;
					width = newWidth;
				}
			}
			
			if (percentHeight > 0) {
				var ucy:Float = parent.getUsableHeight(this);
				var newHeight:Float = Std.int(ucy * percentHeight / 100);
				if (newHeight != height && newHeight > -1) {
					skipInvalidate = true;
					height = newHeight;
				}
			}
		}
		
		if (skipInvalidate == true) {
			return;
		}
		
		if (width > 0 && height > 0) {
			if (recursive == true) {
				for (child in childComponents) {
					if (child.percentWidth > 0 || child.percentHeight > 0) {
						child.invalidateSize(recursive);
					}
				}
			}

			resize();
			layout.repositionChildren();
			
			invalidationCount++;
		}
	}
	
	private function getUsableWidth(c:Component = null):Float {
		var ucx:Float = width - (layout.padding.left + layout.padding.right);
		return ucx;
	}
	
	private function getUsableHeight(c:Component = null):Float {
		var ucy:Float = height - (layout.padding.top + layout.padding.bottom);
		return ucy;
	}
	
	//************************************************************
	//                  OVERRIDABLES
	//************************************************************
	public function initialize():Void {
	}
	
	public function resize():Void {
		applyStyle();
	}

	private function calcSize():Point {
		var size:Point = new Point(width, height);
		if (autoSize == true) {
			size.x = layout.calcWidth();
			size.y = layout.calcHeight();
		}

		width = size.x;
		height = size.y;
		return size;
	}
	
	public function dispose():Void {
		for (c in childComponents) {
			c.dispose();
			try {
				removeChild(c);
			} catch (e:Dynamic) {
				trace("problem removing component: " + this + ", " + c + "(" + e + ")");
			}
		}
		
		removeAllEventListeners();
		while (sprite.numChildren > 0) { // just to remove any disply objects that were also added (ie, not YAHUI components)
			sprite.removeChild(sprite.getChildAt(0));
		}
	}
	
	//************************************************************
	//                  STYLE FUNCTIONS
	//************************************************************
	public function getRegisteredStateNames():Array<String> {
		return stateNames;
	}
	
	public function registerState(stateName:String):Void {
		if (stateNames == null) {
			stateNames = new Array<String>();
		}
		stateNames.push(stateName);
	}
	
	private function applyStyle():Void {
		if (currentStyle != null && ready == true) {
			var rc:Rectangle = new Rectangle(0, 0, width, height);
			StyleHelper.paintStyle(this.sprite.graphics, currentStyle, rc);
			if (currentStyle.alpha != null) {
				sprite.alpha = currentStyle.alpha;
			}
		}
	}
	
	private function hasStateSyle(stateName:String):Bool {
		return stateStyles.exists(stateName);
	}
	
	private function showStateStyle(stateName:String):Void {
		var stateStyle:Dynamic = stateStyles.get(stateName);
		if (stateStyle != null) {
			currentStyle = stateStyle;
			applyStyle();
		}
	}
	
	public function getCurrentStyle():Dynamic {
		return currentStyle;
	}
	
	public function setCurrentStyle(value:Dynamic):Dynamic {
		currentStyle = value;
		applyStyle();
		return value;
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onReady(event:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, onReady);
		
		currentStyle = StyleManager.buildStyle(this);
		if (stateStyles == null) {
			stateStyles = new Hash<Dynamic>();
		}
		for (state in getRegisteredStateNames()) {
			var stateStyle:Dynamic = StyleManager.buildStyle(this, state);
			stateStyles.set(state, stateStyle);
		}
		
		if (currentStyle.width != null && width == 0) {
			width = currentStyle.width;
		}
		if (currentStyle.height != null && height == 0) {
			height = currentStyle.height;
		}

		if (currentStyle.percentWidth != null && percentWidth == -1) {
			percentWidth = currentStyle.percentWidth;
		}
		if (currentStyle.percentHeight != null && percentHeight == -1) {
			percentHeight = currentStyle.percentHeight;
		}
		
		layout.component = this;
		ready = true;
		initialize();
		calcSize();
		invalidate();
		
		// we want a bulk add here, we want to add all the sprites AFTER all the components have been added in childComponents
		if (childrenToAdd != null) {
			var c:Dynamic;
			for (c in childrenToAdd) {
				if (Std.is(c, Component)) {
					childComponents.push(c);
					c.root = this.root;
					c.parent = this;
					if (this.enabled == false) {
						cast(c, Component).enabled = this.enabled;
					}
					c = untyped c.sprite;
				}
			}
			
			for (c in childrenToAdd) {
				if (Std.is(c, Component)) {
					c = untyped c.sprite;
				}
				sprite.addChild(cast(c, DisplayObject));
			}
			childrenToAdd = null;
		}
		calcSize();
		layout.repositionChildren();
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function getSprite():Sprite {
		return sprite;
	}
	
	public function getX():Float {
		return rawX;
	}

	public function setX(value:Float):Float {
		rawX = value;
		if (parent != null && parent.layout != null) {
			value += parent.layout.padding.left;
		}
		sprite.x = value;
		return rawX;
	}
	
	public function getY(): Float {
		return rawY;
	}

	public function setY(value:Float):Float {
		rawY = value;
		if (parent != null && parent.layout != null) {
			value += parent.layout.padding.top;
		}
		sprite.y = value;
		return rawY;
	}
	
	public function getWidth():Float {
		return width;
	}
	
	public function setWidth(value:Float):Float {
		if (value == width) {
			return value;
		}
		
		width = value;
		invalidateSize();
		return value;
	}
	
	public function getHeight():Float {
		return height;
	}
	
	public function setHeight(value:Float):Float {
		if (value == height) {
			return value;
		}
		
		height = value;
		invalidateSize();
		return value;
	}
	
	public function setVisible(value:Bool):Bool {
		sprite.visible = value;
		return value;
	}
	
	public function getVisible():Bool {
		return sprite.visible;
	}

	public function getStageX():Float {
		var xpos:Float = x;// + (root.component.x + root.component.padding.left);
		var p:Component = this.parent;
		while (p != null) {
			xpos += p.x + p.layout.padding.left;
			p = p.parent;
		}
		return xpos;
	}
	
	public function getStageY():Float {
		var ypos:Float = y;// + (root.component.y + root.component.padding.top);
		var p:Component = this.parent;
		while (p != null) {
			ypos += p.y + p.layout.padding.top;
			p = p.parent;
		}
		return ypos;
	}
	
	public function getInnerWidth():Float {
		return width - (layout.padding.left + layout.padding.right);
	}
	
	public function getInnerHeight():Float {
		return height - (layout.padding.top + layout.padding.bottom);
	}
	
	public function setEnabled(value:Bool):Bool {
		if (value == enabled) {
			return value;
		}
		
		enabled = value;
		if (value == false) {
			if (parent == null || parent.enabled == true) {
				sprite.alpha = .5;
			}

			copyEventListeners(MouseEvent.MOUSE_OVER);
			copyEventListeners(MouseEvent.MOUSE_DOWN);
			copyEventListeners(MouseEvent.MOUSE_UP);
			copyEventListeners(MouseEvent.MOUSE_MOVE);
			copyEventListeners(MouseEvent.CLICK);
			copyEventListeners(Event.CHANGE);

			removeEventListenerType(MouseEvent.MOUSE_OVER);
			removeEventListenerType(MouseEvent.MOUSE_DOWN);
			removeEventListenerType(MouseEvent.MOUSE_UP);
			removeEventListenerType(MouseEvent.MOUSE_MOVE);
			removeEventListenerType(MouseEvent.CLICK);
			removeEventListenerType(Event.CHANGE);
			
			for (child in listChildComponents()) {
				child.enabled = false;
			}
		} else {
			sprite.alpha = 1;
			if (eventListenersCopy != null) {
				for (eventType in eventListenersCopy.keys()) {
					var list:List < Dynamic->Void > = eventListenersCopy.get(eventType);
					if (list != null) {
						for (listener in list) {
							addEventListener(eventType, listener);
						}
					}
				}
				eventListenersCopy = null;
			}
		}
		
		return value;
	}
	
	public function getText():String {
		return text;
	}
	
	public function setText(value:String):String { // TODO: potential localization here. Something like @#helloWorld
		text = value;
		return value;
	}
	
	//************************************************************
	//                  IEventDispatcher
	//************************************************************
	public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		if (listener == null) { // no point in continuing
			return;
		}
		
		if (eventListeners == null) {
			eventListeners = new Hash<List<Dynamic->Void>>();
		}

		if (enabled == false && (type == MouseEvent.MOUSE_OVER || type == MouseEvent.MOUSE_DOWN || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_MOVE || type == MouseEvent.CLICK || type == Event.CHANGE)) {
			if (eventListenersCopy == null) {
				eventListenersCopy = new Hash<List<Dynamic->Void>>();
			}
			var list:List<Dynamic->Void> = eventListenersCopy.get(type);
			if (list == null) {
				list = new List<Dynamic->Void>();
				list.add(listener);
				eventListenersCopy.set(type, list);
			} else {
				list.add(listener);
			}
		} else {
			var list:List<Dynamic->Void> = eventListeners.get(type);
			if (list == null) {
				list = new List<Dynamic->Void>();
				list.add(listener);
				eventListeners.set(type, list);
			} else {
				list.add(listener);
			}
			
			sprite.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}

	public function dispatchEvent(event:Event):Bool {
		return sprite.dispatchEvent(event);
	}

	public function hasEventListener(type:String):Bool {
		return sprite.hasEventListener(type);
	}

	public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		if (eventListeners != null && eventListeners.exists(type)) {
			eventListeners.get(type).remove(listener);
		}
		sprite.removeEventListener(type, listener, useCapture);
	}

	public function willTrigger(type:String):Bool {
		return sprite.willTrigger(type);
	}
	
	//************************************************************
	//                  DISPLAY LIST OPERATIONS
	//************************************************************
	public function addChildAt(c:Dynamic, index:Int):Dynamic {
		if (c == null) {
			return c;
		}
		
		if (ready == false) { // TODO: workaround, if there parent is not ready you can still add children and they will be added when ready
			if (childrenToAdd == null) {
				childrenToAdd = new Array<Dynamic>();
			}
			if (Std.is(c, Component)) {
				c.root = this.root;
				c.parent = this;
			}
			childrenToAdd.push(c);
			return null;
		}
		
		if (Std.is(c, Component)) {
			childComponents.push(c);
			c.root = this.root;
			c.parent = this;
			if (this.enabled == false) {
				cast(c, Component).enabled = false;
			}
			c = untyped c.sprite;
		}
		
		sprite.addChildAt(c, index);
		calcSize();
		layout.repositionChildren();
		return c;
	}
	
	public function addChild(c:Dynamic):Dynamic {
		return addChildAt(c, sprite.numChildren);
	}
	
	public function contains(c:Dynamic):Bool {
		if (Std.is(c, Component)) {
			c = untyped c.sprite;
		}
		return sprite.contains(c);
	}

	public function removeChild(c:Dynamic):DisplayObject {
		if (c == null) {
			return c;
		}
		
		if (Std.is(c, Component)) {
			childComponents.remove(c);
			c = untyped c.sprite;
		}

		var r:Dynamic = null;
		r = sprite.removeChild(c);
		calcSize();
		layout.repositionChildren();
		return r;
	}
	
	public function getChildAt(index:Int):DisplayObject {
		return sprite.getChildAt(index);
	}
	
	public function getNumChildren():Int {
		return sprite.numChildren;
	}
	
	public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void {
		sprite.swapChildren(child1, child2);
	}
	
	public function bringToFront(c:Dynamic):Void {
		if (c != null) {
			if (Std.is(c, Component)) {
				c = untyped c.sprite;
			}
			if (sprite.contains(c)) {
				sprite.setChildIndex(c, sprite.numChildren - 1);
			}
		}
	}

	public function sendToBack(c:Dynamic):Void {
		if (c != null) {
			if (Std.is(c, Component)) {
				c = untyped c.sprite;
			}
			if (sprite.contains(c)) {
				try {
					sprite.setChildIndex(c, 0);
				} catch (e:Dynamic) {
					trace("Unknown exception : "+Std.string(e));
				}
				
			}
		}
	}
	
	public function setScrollRect(x:Float, y:Float, cx:Float, cy:Float):Void {
		sprite.scrollRect = new Rectangle(x, y, cx, cy);
	}
	
	public function listChildComponents():Array<Component> {
		var arr:Array<Component> = new Array<Component>();
		if (childrenToAdd != null) {
			for (child in childrenToAdd) {
				if (Std.is(child, Component)) {
					arr.push(child);
				}
			}
		}
		if (childComponents != null) {
			for (child in childComponents) {
				arr.push(child);
			}
		}
		return arr;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	public function hitTest(xpos:Float, ypos:Float):Bool { // if the coords are in the control (use stage coords)
		var b:Bool = false;
		var sx:Float = stageX;
		var sy:Float = stageY;
		if (xpos >= sx && xpos <= sx + width && ypos >= sy && ypos <= sy + height) {
			b = true;
		}
		
		return b;
	}
	
	public function removeEventListenerType(eventType:String):Void {
		if (eventListeners != null) {
			var list:List < Dynamic->Void > = eventListeners.get(eventType);
			if (list != null) {
				while (list.isEmpty() == false) {
					removeEventListener(eventType, list.first());
				}
			}
		}
	}
	
	private function removeAllEventListeners():Void {
		if (eventListeners != null) {
			for (eventType in eventListeners.keys()) {
				var list:List <Dynamic->Void> = eventListeners.get(eventType);
				while (list.isEmpty() == false) {
					removeEventListener(eventType, list.first());
					list = eventListeners.get(eventType);
				}
			}
		}
	}
	
	private function copyEventListeners(type:String):Void {
		if (eventListeners != null) {
			var src:List < Dynamic->Void > = eventListeners.get(type);
			if (src != null) {
				if (eventListenersCopy == null) {
					eventListenersCopy = new Hash < List < Dynamic->Void > > ();
				}
				
				var dst:List < Dynamic->Void > = new List < Dynamic->Void > ();
				for (listener in src) {
					dst.add(listener);
				}
				eventListenersCopy.set(type, dst);
			}
		}
	}
}