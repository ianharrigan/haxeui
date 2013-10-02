package haxe.ui.toolkit.core;

import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.ui.toolkit.core.Client;
import haxe.ui.toolkit.core.interfaces.IDraggable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.resources.ResourceManager;

class Component extends StyleableDisplayObject {
	private var _text:String;
	private var _clipContent:Bool = false;
	
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
	
	public override function invalidate(type:Int = InvalidationFlag.ALL):Void {
		super.invalidate(type);
		
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE && _clipContent == true) {
			sprite.scrollRect = new Rectangle(0, 0, width, height);
		}
	}
	
	//******************************************************************************************
	// Component methods/properties
	//******************************************************************************************
	public var text(get, set):String;
	public var clipWidth(get, set):Float;
	public var clipHeight(get, set):Float;
	public var clipContent(get, set):Bool;
	
	private function get_text():String {
		return _text;
	}
	
	private function set_text(value:String):String {
		if (StringTools.startsWith(value, "@#")) {
			value = value.substr(2, value.length) + "_" + Client.instance.language;
		} else if (StringTools.startsWith(value, "asset://")) {
			var assetId:String = value.substr(8, value.length);
			value = ResourceManager.instance.getText(assetId);
		}
		_text = value;
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
		invalidate(InvalidationFlag.SIZE);
		return value;
	}
	
	public function clearClip():Void {
		sprite.scrollRect = null;
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