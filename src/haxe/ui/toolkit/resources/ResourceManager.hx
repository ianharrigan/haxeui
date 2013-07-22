package haxe.ui.toolkit.resources;

import flash.display.BitmapData;
import haxe.Resource;
import openfl.Assets;

class ResourceManager {
	private static var _instance:ResourceManager;
	public static var instance(get, null):ResourceManager;
	private static function get_instance():ResourceManager {
		if (_instance == null) {
			_instance = new ResourceManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public function new() {
		
	}
	
	public function getText(resourceId:String, locale:String = null):String {
		var str:String = Assets.getText(resourceId);
		#if html5
		str = Resource.getString(resourceId);
		#end
		return str;
	}
	
	public function getBitmapData(resourceId:String, locale:String = null):BitmapData {
		var bmp:BitmapData = Assets.getBitmapData(resourceId, true);
		return bmp;
	}
	
	public function reset():Void {
		Assets.cachedBitmapData = new Map<String, BitmapData>();
	}
}