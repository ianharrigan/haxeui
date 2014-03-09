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
			var original:IDisplayObject = Toolkit.processXmlResource("assets/test.xml");
			original.id = "ORG";
			root.addChild(original);
			*/

			/*
			var clone = original.clone();
			clone.x += 250;
			clone.id = "CLONE";
			root.addChild(clone);

			var clone2 = clone.clone();
			clone2.x += 250;
			clone2.id = "CLONE2";
			root.addChild(clone2);
			*/
			
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
