package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.HSlider;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleManager;

class Main {
	public static function main() {
		#if android
			Macros.addStyleSheet("assets/styles/gradient/gradient_mobile.css");
		#else
			Macros.addStyleSheet("assets/styles/gradient/gradient.css");
		#end
		Macros.addStyleSheet("assets/test.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			var t:TestController = new TestController();
			root.addChild(t.view);
			
			/*
			var t2:TestController2 = new TestController2();
			root.addChild(t2.view);
			*/
		});
	}
}
