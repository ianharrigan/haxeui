package haxe.ui.toolkit.core;

import openfl.system.Capabilities;

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
	public var platform(get, null):String;
	public var screenWidth(get, null):Float;
	public var screenHeight(get, null):Float;
	public var windowWidth(get, null):Float;
	public var windowHeight(get, null):Float;
	public var target(get, null):String;
	
	private function get_language():String {
		return Capabilities.language;
	}
	
	private function get_dpi():Float {
		return Capabilities.screenDPI;
	}

	private function get_platform():String {
		#if air return "air"; #end
		#if flash return "flash"; #end
		#if html5 return "html5"; #end
		#if windows return "windows"; #end
		#if neko return "neko"; #end
		#if android return "android"; #end
		#if linux return "linux"; #end
		
		return null;
	}

	private function get_target():String {
		#if air return "air"; #end
		#if flash return "flash"; #end
		#if html5 return "html5"; #end
		#if cpp return "cpp"; #end
		#if neko return "neko"; #end
		
		return null;
	}
	
	private function get_screenWidth():Float {
		return Capabilities.screenResolutionX;
	}
	
	private function get_screenHeight():Float {
		return Capabilities.screenResolutionY;
	}

    private function get_windowWidth():Float {
      return openfl.Lib.current.stage.stageWidth;
    }

    private function get_windowHeight():Float {
      return openfl.Lib.current.stage.stageHeight;
    }
}
