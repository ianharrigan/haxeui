package haxe.ui.toolkit.core;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import haxe.ds.StringMap;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.IDrawable;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.util.CallStackHelper;
import haxe.ui.toolkit.util.StringUtil;

@:build(haxe.ui.toolkit.core.Macros.addEvents([
	"init", "resize", "ready",
	"click", "mouseDown", "mouseUp", "mouseOver", "mouseOut", "mouseMove", "doubleClick", "rollOver", "rollOut", "change", "scroll", 
	"added", "addedToStage", "removed", "removedFromStage", "activate", "deactivate",
	"glyphClick"
]))
class DisplayObject implements IEventDispatcher implements IDisplayObject implements IDrawable {
	// used in IDisplayObject getters/setters
	private var _parent:IDisplayObjectContainer;
	private var _root:Root;
	private var _id:String;
	private var _x:Float = 0;
	private var _y:Float = 0;
	private var _width:Float = 0;
	private var _height:Float = 0;
	private var _percentWidth:Float = -1;
	private var _percentHeight:Float = -1;
	private var _ready:Bool = false;
	private var _invalidating:Bool = false;
	private var _sprite:Sprite;
	private var _halign:String = "left";
	private var _valign:String = "top";

	private var _eventListeners:StringMap < List < Dynamic->Void >> ;
	
	public function new() {
		_sprite = new Sprite();
		_sprite.tabChildren = false;
		addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 100);
	}

	//******************************************************************************************
	// Overridables
	//******************************************************************************************
	private function preInitialize():Void {
	}
	
	private function initialize():Void {
	}
	
	private function postInitialize():Void {
	}
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onAddedToStage(event:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);

		preInitialize();
		_ready = true;
		initialize();
		postInitialize();
		invalidate(InvalidationFlag.LAYOUT | InvalidationFlag.DISPLAY | InvalidationFlag.SIZE);
		
		var event:UIEvent =  new UIEvent(UIEvent.INIT);
		dispatchEvent(event);
		
		var event:UIEvent =  new UIEvent(UIEvent.READY);
		dispatchEvent(event);
	}
	
	//******************************************************************************************
	// IDisplayObject
	//******************************************************************************************
	public var parent(get, set):IDisplayObjectContainer;
	public var root(get, set):Root;
	public var id(get, set):String;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var percentWidth(get, set):Float;
	public var percentHeight(get, set):Float;
	public var ready(get, null):Bool;
	public var sprite(get, null):Sprite;
	public var stageX(get, null):Float;
	public var stageY(get, null):Float;
	public var visible(get, set):Bool;
	public var horizontalAlign(get, set):String;
	public var verticalAlign(get, set):String;
	
	private function get_parent():IDisplayObjectContainer {
		return _parent;
	}
	
	private function set_parent(value:IDisplayObjectContainer):IDisplayObjectContainer {
		_parent = value;
		return value;
	}
	
	private function get_root():Root {
		return _root;
	}
	
	private function set_root(value:Root):Root {
		_root = value;
		return value;
	}
	
	private function get_id():String {
		return _id;
	}
	
	private function set_id(value:String):String {
		_id = value;
		return value;
	}
	
	private function get_x():Float {
		return _x;
	}
	
	private function set_x(value:Float):Float {
		_x = Std.int(value);
		_sprite.x = _x;
		return value;
	}
	
	private function get_y():Float {
		return _y;
	}
	
	private function set_y(value:Float):Float {
		_y = Std.int(value);
		_sprite.y = _y;
		return value;
	}
	
	private function get_width():Float {
		return _width;
	}
	
	private function set_width(value:Float):Float {
		value = Std.int(value);
		if (_width == value) {
			return value;
		}
		
		_width = value;
		_invalidating = false;
		invalidate(InvalidationFlag.DISPLAY | InvalidationFlag.SIZE);
		if (_parent != null) {
			_parent.invalidate(InvalidationFlag.LAYOUT);
		}
		var event:UIEvent =  new UIEvent(UIEvent.RESIZE);
		dispatchEvent(event);
		
		return value;
	}
	
	private function get_height():Float {
		return _height;
	}
	
	private function set_height(value:Float):Float {
		value = Std.int(value);
		if (_height == value) {
			return value;
		}
		
		_height = value;
		_invalidating = false;
		invalidate(InvalidationFlag.DISPLAY | InvalidationFlag.SIZE);
		if (_parent != null) {
			_parent.invalidate(InvalidationFlag.LAYOUT);
		}
		var event:UIEvent =  new UIEvent(UIEvent.RESIZE);
		dispatchEvent(event);
		
		return value;
	}
	
	private function get_percentWidth():Float {
		return _percentWidth;
	}
	
	private function set_percentWidth(value:Float):Float {
		if (_percentWidth == value) {
			return value;
		}
		
		_percentWidth = value;
		invalidate();
		if (_parent != null) {
			_parent.invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}
	
	private function get_percentHeight():Float {
		return _percentHeight;
	}
	
	private function set_percentHeight(value:Float):Float {
		if (_percentHeight == value) {
			return value;
		}
		
		_percentHeight = value;
		invalidate();
		if (_parent != null) {
			_parent.invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}
	
	private function get_ready():Bool {
		return _ready;
	}

	private function get_sprite():Sprite {
		return _sprite;
	}
	

	private function get_stageX():Float {
		var c:IDisplayObject = cast(this, IDisplayObject);
		var xpos:Float = 0;
		while (c != null) {
			xpos += c.x;
			if (c.sprite.scrollRect != null) {
				xpos -= c.sprite.scrollRect.left;
			}
			c = c.parent;
		}
		//xpos -= root.x;
		return xpos;
	}

	private function get_stageY():Float {
		var c:IDisplayObject = cast(this, IDisplayObject);
		var ypos:Float = 0;
		while (c != null) {
			ypos += c.y;
			if (c.sprite.scrollRect != null) {
				ypos -= c.sprite.scrollRect.top;
			}
			c = c.parent;
		}
		//ypos -= root.y;
		return ypos;
	}

	private function get_visible():Bool {
		return _sprite.visible;
	}
	
	private function set_visible(value:Bool):Bool {
		_sprite.visible = value;
		if (_parent != null) {
			_parent.invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}
	
	private function get_horizontalAlign():String {
		return _halign;
	}
	
	private function set_horizontalAlign(value:String):String {
		_halign = value;
		if (_ready) {
			parent.invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}
	
	private function get_verticalAlign():String {
		return _valign;
	}
	
	private function set_verticalAlign(value:String):String {
		_valign = value;
		if (_ready) {
			parent.invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}
	
	public function hitTest(xpos:Float, ypos:Float):Bool { // co-ords must be stage
		var b:Bool = false;
		var sx:Float = stageX;
		var sy:Float = stageY;
		if (xpos > sx && xpos < sx + width && ypos > sy && ypos < sy + height) {
			b = true;
		}
		
		return b;
	}

	public function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		if (!_ready || _invalidating) {
			return;
		}

		//CallStackHelper.traceCallStack();
		
		_invalidating = true;
		if (type & InvalidationFlag.DISPLAY == InvalidationFlag.DISPLAY
			|| type & InvalidationFlag.STATE == InvalidationFlag.STATE) {
			paint();
		}
		_invalidating = false;
	}
	
	public function dispose():Void {
		// remove all event listeners
		removeAllEventListeners();
	}
	
	private function interceptEvent(event:Event):Void {
		dispatchEvent(new UIEvent(UIEvent.PREFIX + event.type));
	}
	
	//******************************************************************************************
	// IEventDispatcher
	//******************************************************************************************
	public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		if (StringTools.startsWith(type, UIEvent.PREFIX)) {
			var interceptEventType:String = type.substr(UIEvent.PREFIX.length, type.length);
			if (getListenerCount(interceptEventType, interceptEvent) == 0) {
				addEventListener(interceptEventType, interceptEvent, useCapture, priority, useWeakReference);
			}
		}
		
		if (_eventListeners == null) {
			_eventListeners = new StringMap < List < Dynamic->Void >> ();
		}
		
		var list:List < Dynamic->Void > = _eventListeners.get(type);
		if (list == null) {
			list = new List < Dynamic->Void > ();
			_eventListeners.set(type, list);
		}
		list.add(listener);
		
		_sprite.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public function dispatchEvent(event:Event):Bool {
		if (Std.is(event, UIEvent)) {
			cast(event, UIEvent).displayObject = this;
		}
		return _sprite.dispatchEvent(event);
	}
	
	public function hasEventListener(type:String):Bool {
		return _sprite.hasEventListener(type);
	}
	
	public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		if (StringTools.startsWith(type, UIEvent.PREFIX)) {
			var interceptEventType:String = type.substr(UIEvent.PREFIX.length, type.length);
			if (_eventListeners.exists(type) == false || _eventListeners.get(type).length <= 1) {
				removeEventListener(interceptEventType, interceptEvent, useCapture);
			}
		}
		
		if (_eventListeners != null && _eventListeners.exists(type)) {
			var list:List < Dynamic->Void > = _eventListeners.get(type);
			if (list != null) {
				list.remove(listener);
			}
		}
		_sprite.removeEventListener(type, listener, useCapture);
	}
	
	public function willTrigger(type:String):Bool {
		return _sprite.willTrigger(type);
	}
	
	//******************************************************************************************
	// IDrawable
	//******************************************************************************************
	public var graphics(get, null):Graphics;
	
	private function get_graphics():Graphics {
		return _sprite.graphics;
	}
	
	private function paint():Void {
		_sprite.graphics.clear();

		_sprite.graphics.beginFill(0xCCCCCC);
		_sprite.graphics.lineStyle(1, 0x888888);
		_sprite.graphics.drawRect(0, 0, _width, _height);
		_sprite.graphics.endFill();
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public function removeEventListenerType(eventType:String):Void {
		if (_eventListeners != null) {
			var list:List < Dynamic->Void > = _eventListeners.get(eventType);
			if (list != null) {
				while (list.isEmpty() == false) {
					removeEventListener(eventType, list.first());
				}
			}
		}
	}
	
	private function removeAllEventListeners():Void {
		if (_eventListeners != null) {
			for (eventType in _eventListeners.keys()) {
				var list:List <Dynamic->Void> = _eventListeners.get(eventType);
				while (list.isEmpty() == false) {
					removeEventListener(eventType, list.first());
					list = _eventListeners.get(eventType);
				}
			}
		}
	}
	
	private function getListenerCount(type:String, listener:Dynamic->Void):Int {
		var count:Int = 0;
		if (_eventListeners.exists(type)) {
			var list:List < Dynamic->Void > = _eventListeners.get(type); 
			for (l in list) {
				if (l == listener) {
					count++;
				}
			}
		}
		return count;
	}
	
	//******************************************************************************************
	// event handler vars
	//******************************************************************************************
	private function _handleEvent(event:UIEvent):Void {
		var fnName:String = "on" + StringUtil.capitalizeFirstLetter(StringTools.replace(event.type, UIEvent.PREFIX, ""));
		var fn:UIEvent->Void = Reflect.field(this, fnName);
		if (fn != null) {
			var fnEvent:UIEvent = new UIEvent(UIEvent.PREFIX + event.type); 
			fnEvent.displayObject = this;
			fn(fnEvent);
		}
	}
}