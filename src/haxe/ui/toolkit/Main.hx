package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.themes.DefaultTheme;

class Main {
	public static function main() {
		Toolkit.defaultTransition = "none";
		Toolkit.setTransitionForClass(Accordion, "slide");
		Toolkit.setTransitionForClass(Stack, "fade");
		Toolkit.theme = new DefaultTheme();
		//Macros.addStyleSheet("assets/test.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			/*
			var t:TestController = new TestController();
			root.addChild(t.view);
			*/
			var t2:TestController2 = new TestController2();
			root.addChild(t2.view);
		});
	}
}
