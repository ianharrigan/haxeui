package haxe.ui.toolkit;

import haxe.ui.test.TestController;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;

class Main {
	public static function main() {
		#if android
			Macros.addStyleSheet("assets/styles/gradient/gradient_mobile.css");
		#else
			Macros.addStyleSheet("assets/styles/gradient/gradient.css");
		#end
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new TestController().view);
		});
	}
}
