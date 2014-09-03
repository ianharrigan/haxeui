package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;

class Main {
	public static function main() {
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
			//root.addChild(Toolkit.processXmlResource("assets/test2.xml"));
			
			var button:Button = new Button();
			button.x = 100;
			button.y = 100;
			button.style.width = 150;
			button.style.height = 100;
			button.style.color = 0xFF00FF;
			button.style.backgroundColor = 0x00FF00;
			button.style.icon = "img/slinky_small.jpg";
			button.style.iconPosition = "top";
			button.text = "Styled";
			root.addChild(button);
		});
	}
}
