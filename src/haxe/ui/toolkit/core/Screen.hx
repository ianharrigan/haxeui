package haxe.ui.toolkit.core;

import flash.Lib;

class Screen {
	private static var _instance:Screen;
	public static var instance(get, null):Screen;
	public static function get_instance():Screen {
		if (_instance == null) {
			_instance = new Screen();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public var width(get, null):Float;
	public var height(get, null):Float;
	
	public function new() {
		
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
}