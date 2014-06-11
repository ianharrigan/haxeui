package haxe.ui.toolkit;

import haxe.ui.toolkit.core.interfaces.IModule;
import haxe.ui.toolkit.themes.Theme;

class TestModule implements IModule {
	public function new() {
	}
	
	public function init():Void {
		//trace("test module init");
		//Theme.addPublicAsset("assets/test.css");
	}
}