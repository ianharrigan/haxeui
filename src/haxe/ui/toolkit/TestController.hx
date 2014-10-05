package haxe.ui.toolkit;

import haxe.ui.toolkit.core.XMLController;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/test2.xml"))
class TestController extends XMLController {
	public function new() {
		button1.onClick = function(e) {
			trace("You clicked button 1");
		};
	}
}