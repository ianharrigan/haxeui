package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.core.renderers.ComponentItemRenderer;
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
			var lv:ListView = new ListView();
			lv.width = 400;
			lv.height = 400;
			
			lv.itemRenderer = "haxe.ui.toolkit.core.renderers.ComponentItemRenderer";
			for (a in 0...10) {
				var o = {
					text: "Item " + a,
					componentType: "button",
					componentValue: "Click Me!",
					controlId: "sendButton",
					subtext: "Sub text",
					icon: "img/slinky_tiny.jpg"
				}
				
				if (a == 2) {
					o.subtext = "This is some extra long sub text to make sure that it all works as expected. The list item should size correctly, and it should all work, etc, etc.";
				}
				
				lv.dataSource.add(o);
			}
			
			root.addChild(lv);
		});
	}
}
