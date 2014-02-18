package haxe.ui.toolkit.events;

import flash.events.Event;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;

class UIEvent extends Event {
	public static inline var PREFIX:String = "haxeui_";
	
	public static inline var INIT:String = PREFIX + "init";
	public static inline var RESIZE:String = PREFIX + "resize";
	public static inline var READY:String = PREFIX + "ready";
	
	public static inline var CLICK:String = PREFIX + "click";
	public static inline var MOUSE_DOWN:String = PREFIX + "mouseDown";
	public static inline var MOUSE_UP:String = PREFIX + "mouseUp";
	public static inline var MOUSE_OVER:String = PREFIX + "mouseOver";
	public static inline var MOUSE_OUT:String = PREFIX + "mouseOut";
	public static inline var MOUSE_MOVE:String = PREFIX + "mouseMove";
	public static inline var DOUBLE_CLICK:String = PREFIX + "doubleClick";
	public static inline var ROLL_OVER:String = PREFIX + "rollOver";
	public static inline var ROLL_OUT:String = PREFIX + "rollOut";
	public static inline var CHANGE:String = PREFIX + "change";
	public static inline var SCROLL:String = PREFIX + "scroll";

	public static inline var ADDED:String = PREFIX + "added";
	public static inline var ADDED_TO_STAGE:String = PREFIX + "addedToStage";
	public static inline var REMOVED:String = PREFIX + "removed";
	public static inline var REMOVED_FROM_STAGE:String = PREFIX + "removedFromStage";
	public static inline var ACTIVATE:String = PREFIX + "activate";
	public static inline var DEACTIVATE:String = PREFIX + "deactivate";
	
	public static inline var GLYPH_CLICK:String = PREFIX + "glyphClick"; // for button images
	
	public var displayObject(default, default):IDisplayObject;
	public var component(get, null):Component;
	public var data(default, default):Dynamic;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) {
		super(type, bubbles, cancelable);
	}
	
	public override function clone():Event {
		var c:UIEvent = new UIEvent(type, bubbles, cancelable);
		c.displayObject = displayObject;
		return c;
	}
	
	private function get_component():Component {
		if (displayObject == null || Std.is(displayObject, Component) == false) {
			return null;
		}
		return cast(displayObject, Component);
	}
}