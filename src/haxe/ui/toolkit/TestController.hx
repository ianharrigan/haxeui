package haxe.ui.toolkit;

import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/test.xml"))
class TestController extends XMLController {
	public function new() {
		testButton.addEventListener(UIEvent.CLICK, function (e) {
			trace("clicked");
		});
	}
	
}