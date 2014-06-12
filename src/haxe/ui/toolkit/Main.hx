package haxe.ui.toolkit;

import openfl.display.Sprite;
import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.themes.DefaultTheme;
import haxe.ui.toolkit.themes.GradientTheme;
import haxe.ui.toolkit.themes.WindowsTheme;

class Main {
	static var buttons:Array<Button>;
	
	public static function main() {
		buttons = new Array<Button>();
		Toolkit.defaultTransition = "none";
		Toolkit.setTransitionForClass(Accordion, "slide");
		Toolkit.setTransitionForClass(Stack, "fade");
		//Toolkit.theme = new DefaultTheme();
		//Toolkit.theme = new GradientTheme();
		//Toolkit.theme = new WindowsTheme();
		Toolkit.theme = "gradient";
		//Macros.addStyleSheet("assets/test.css");
		Toolkit.setTransitionForClass(Stack, "none");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			//var t2:TestController2 = new TestController2();
			//root.addChild(t2.view);
			//root.addChild(Toolkit.processXmlResource("assets/test2.xml"));
			//root.addChild(new TestController().view);
			
			var b:Button = new Button();
			b.text = "Create";
			b.x = 100;
			root.addChild(b);
			b.addEventListener(UIEvent.CLICK, function(e) {
				for (x in 0...100) {
					var test:Button = new Button();
					test.text = "" + x;
					root.addChild(test);
					buttons.push(test);
				}
			});

			var b:Button = new Button();
			b.text = "Destroy";
			b.x = 200;
			root.addChild(b);
			b.addEventListener(UIEvent.CLICK, function(e) {
				for (test in buttons) {
					root.removeChild(test);
				}
				buttons = new Array<Button>();
			});
			
		});
	}
}
