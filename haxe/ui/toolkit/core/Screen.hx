package haxe.ui.toolkit.core;

import openfl.Lib;
import openfl.events.MouseEvent;

class Screen {
	private static var _instance:Screen;
	public static var instance(get, null):Screen;
	private static function get_instance():Screen {
		if (_instance == null) {
			_instance = new Screen();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	private var _cursorX:Float = -1;
	private var _cursorY:Float = -1;
	
	public var width(get, null):Float;
	public var height(get, null):Float;
	public var cursorX(get, null):Float;
	public var cursorY(get, null):Float;
	
	public function new() {
		addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}
	
	public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		var target = Lib.current.stage;
		target.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}	
	
	public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		var target = Lib.current.stage;
		target.removeEventListener(type, listener, useCapture);
	}
	
	private function get_width():Float {
		return Lib.current.stage.stageWidth;
	}
	
	private function get_height():Float {
		return Lib.current.stage.stageHeight;
	}

	private function get_cursorX():Float {
		return _cursorX;
	}
	
	private function get_cursorY():Float {
		return _cursorY;
	}
	
	private function _onScreenMouseMove(event:MouseEvent):Void {
		_cursorX = event.stageX;
		_cursorY = event.stageY;
	}
}