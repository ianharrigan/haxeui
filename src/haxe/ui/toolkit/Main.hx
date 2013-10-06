package haxe.ui.toolkit;

import haxe.ui.test.TestController;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;

class Main {
	public static function main() {
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new TestController().view);
		});
	}
}
