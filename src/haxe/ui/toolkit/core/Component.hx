package haxe.ui.toolkit.core;

import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import haxe.ds.StringMap.StringMap;
import haxe.ui.toolkit.core.base.State;
import haxe.ui.toolkit.core.Client;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IComponent;
import haxe.ui.toolkit.core.interfaces.IDraggable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.resources.ResourceManager;

class Component extends StyleableDisplayObject implements IComponent implements IClonable<StyleableDisplayObject> {
	private var _text:String;
	private var _clipContent:Bool = false;
	private var _disabled:Bool = false;
	
	public function new() {
		super();
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		if (Std.is(this, IDraggable)) {
			addEventListener(MouseEvent.MOUSE_DOWN, _onComponentMouseDown);
		}
	}
	
	private override function postInitialize():Void { 
		if (_disabled == true) {
			disabled = true;
		}
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		if (!_ready || _invalidating) {
			return;
		}
		
		super.invalidate(type, recursive);
		_invalidating = true;
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE && _clipContent == true) {
			sprite.scrollRect = new Rectangle(0, 0, width, height);
		}
		_invalidating = false;
	}
	
	//******************************************************************************************
	// Component methods/properties
	//******************************************************************************************
	@:clonable
	public var text(get, set):String;
	public var clipWidth(get, set):Float;
	public var clipHeight(get, set):Float;
	public var clipContent(get, set):Bool;
	@:clonable
	public var disabled(get, set):Bool;
	@:clonable
	public var userData(default, default):Dynamic;
	@:clonable
	public var value(get, set):Dynamic;
	
	private function get_text():String {
		return _text;
	}
	
	private function set_text(value:String):String {
		if (value != null) {
			if (StringTools.startsWith(value, "@#")) {
				value = value.substr(2, value.length) + "_" + Client.instance.language;
			} else if (StringTools.startsWith(value, "asset://")) {
				var assetId:String = value.substr(8, value.length);
				value = ResourceManager.instance.getText(assetId);
				value = StringTools.replace(value, "\r", "");
			}
			_text = value;
		}
		return value;
	}
	
	
	private function get_clipWidth():Float {
		if (sprite.scrollRect == null) {
			return width;
		}
		return sprite.scrollRect.width;
	}
	
	private function set_clipWidth(value:Float):Float {
		sprite.scrollRect = new Rectangle(0, 0, value, clipHeight);
		return value;
	}
	
	private function get_clipHeight():Float {
		if (sprite.scrollRect == null) {
			return height;
		}
		return sprite.scrollRect.height;
	}
	
	private function set_clipHeight(value:Float):Float {
		sprite.scrollRect = new Rectangle(0, 0, clipWidth, value);
		return value;
	}
	
	private function get_clipContent():Bool {
		return _clipContent;
	}
	
	private function set_clipContent(value:Bool):Bool {
		_clipContent = value;
		if (_clipContent == false) {
			clearClip();
		}
		invalidate(InvalidationFlag.SIZE);
		return value;
	}
	
	public function clearClip():Void {
		sprite.scrollRect = null;
	}
	
	private function get_disabled():Bool {
		return _disabled;
	}
	
	private function set_disabled(value:Bool):Bool {
		if (value == true) {
			if (_cachedListeners == null) {
				_cachedListeners = new StringMap < List < Dynamic->Void >> ();
			}
			
			for (type in _eventListeners.keys()) {
				if (disablableEventType(type) == true) {
					var list:List < Dynamic->Void > = _eventListeners.get(type);
					var cachedList:List < Dynamic->Void > = _cachedListeners.get(type);
					if (cachedList == null) {
						cachedList = new List < Dynamic->Void > ();
						_cachedListeners.set(type, cachedList);
					}
					for (listener in list) {
						cachedList.push(listener);
						removeEventListener(type, listener);
					}
				}
			}
		}
		
		_disabled = value;
		for (child in children) {
			if (Std.is(child, Component)) {
				cast(child, Component).disabled = value;
			}
		}
		
		if (value == false) { // add event listeners
			if (_cachedListeners != null) {
				for (type in _cachedListeners.keys()) {
					var list:List < Dynamic->Void > = _cachedListeners.get(type);
					for (listener in list) {
						addEventListener(type, listener);
					}
					list.clear();
				}
				_cachedListeners = null;
			}
		}
		
		if (Std.is(this, StateComponent)) {
			var stateComponent:StateComponent = cast(this, StateComponent);
			if (value == true) {
				if (stateComponent.hasState(State.DISABLED)) {
					stateComponent.state = State.DISABLED;
				}
			} else {
				if (stateComponent.hasState(State.NORMAL)) {
					stateComponent.state = State.NORMAL;
				}
			}
		}
		
		return value;
	}
	
	private function get_value():Dynamic {
		return text;
	}
	
	private function set_value(newValue:Dynamic):Dynamic {
		text = newValue;
		return newValue;
	}
	
	//******************************************************************************************
	// Event dispatcher overrides
	//******************************************************************************************
	private var _cachedListeners:StringMap < List < Dynamic->Void >> ; // for disabling
	public override function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		if (_disabled == true && disablableEventType(type) == true) {
			if (_cachedListeners == null) {
				_cachedListeners = new StringMap < List < Dynamic->Void >> ();
			}
			var list:List < Dynamic->Void > = _cachedListeners.get(type);
			if (list == null) {
				list = new List < Dynamic->Void > ();
				_cachedListeners.set(type, list);
			}
			list.push(listener);
			return;
		}
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public override function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		if (_disabled == true && disablableEventType(type) == true) {
			if (_cachedListeners != null) {
				var list:List < Dynamic->Void > = _cachedListeners.get(type);
				if (list != null) {
					list.remove(listener);
					if (list.length == 0) {
						_cachedListeners.remove(type);
					}
				}
			}
			return;
		}
		super.removeEventListener(type, listener, useCapture);
	}
	
	private function disablableEventType(type:String):Bool {
		return (type == MouseEvent.MOUSE_DOWN
				|| type == MouseEvent.MOUSE_MOVE
				|| type == MouseEvent.MOUSE_OVER
				|| type == MouseEvent.MOUSE_OUT
				|| type == MouseEvent.MOUSE_UP
				|| type == MouseEvent.MOUSE_WHEEL
				|| type == MouseEvent.CLICK
		);
	}
	//******************************************************************************************
	// Drag functions
	//******************************************************************************************
	private var mouseDownPos:Point;
	private function _onComponentMouseDown(event:MouseEvent):Void {
		if (Std.is(this, IDraggable)) {
			if (cast(this, IDraggable).allowDrag(event) == false) {
				return;
			}
		}
		
		mouseDownPos = new Point(event.stageX - stageX, event.stageY - stageY);
		root.addEventListener(MouseEvent.MOUSE_MOVE, _onComponentMouseMove);
		root.addEventListener(MouseEvent.MOUSE_UP, _onComponentMouseUp);
	}
	
	private function _onComponentMouseUp(event:MouseEvent):Void {
		root.removeEventListener(MouseEvent.MOUSE_MOVE, _onComponentMouseMove);
		root.removeEventListener(MouseEvent.MOUSE_UP, _onComponentMouseUp);
	}
	
	private function _onComponentMouseMove(event:MouseEvent):Void {
		this.x = event.stageX - mouseDownPos.x;
		this.y = event.stageY - mouseDownPos.y;
	}
}