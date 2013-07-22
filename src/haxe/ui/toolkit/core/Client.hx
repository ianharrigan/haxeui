package haxe.ui.toolkit.core;

import flash.system.Capabilities;

class Client {
	private static var _instance:Client;
	public static var instance(get, null):Client;
	private static function get_instance():Client {
		if (_instance == null) {
			_instance = new Client();
			_instance.init();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public function new() {
		
	}
	
	public function init():Void {
	}
	
	public var language(get, null):String;
	public var dpi(get, null):Float;
	public var target(get, null):String;
	public var screenWidth(get, null):Float;
	public var screenHeight(get, null):Float;

	private function get_language():String {
		return Capabilities.language;
	}
	
	private function get_dpi():Float {
		return Capabilities.screenDPI;
	}

	private function get_target():String {
		#if flash return "flash"; #end
		#if html5 return "html5"; #end
		#if windows return "windows"; #end
		#if neko return "neko"; #end
		#if android return "android"; #end
	}
	
	private function get_screenWidth():Float {
		return Capabilities.screenResolutionX;
	}
	
	private function get_screenHeight():Float {
		return Capabilities.screenResolutionY;
	}
}