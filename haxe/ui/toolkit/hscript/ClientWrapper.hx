package haxe.ui.toolkit.hscript;

import haxe.ui.toolkit.core.Client;

class ClientWrapper {
	public var language:String;
	public var dpi:Float;
	public var platform:String;
	public var target:String;
	public var mobile:Bool;
	public var screenWidth:Float;
	public var screenHeight:Float;
	public var windowWidth:Float;
	public var windowHeight:Float;
	
	public function new() {
		language = Client.instance.language;
		dpi = Client.instance.dpi;
		platform = Client.instance.platform;
		target = Client.instance.target;
		mobile = Client.instance.mobile;
		screenWidth = Client.instance.screenWidth;
		screenHeight = Client.instance.screenHeight;
		windowWidth = Client.instance.windowWidth;
		windowHeight = Client.instance.windowHeight;
	}
}
