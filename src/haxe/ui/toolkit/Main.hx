package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.HSlider;
import haxe.ui.toolkit.controls.Text;
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
			var button:Button = new Button();
			button.disabled = true;
			button.x = 100;
			button.y = 100;
			button.width = 100;
			button.height = 100;
			button.text = "Test Button";
			root.addChild(button);
			*/

			/*
			var s:Text = new Text();
			s.text = "Bob";
			root.addChild(s);
			*/
		});
	}
}
