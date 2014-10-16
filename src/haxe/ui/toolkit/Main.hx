package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.hscript.ClientWrapper;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleManager;
import openfl.display.Bitmap;
import openfl.Lib;

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
		//Toolkit.addScriptletClass("Client", ClientWrapper);
		Toolkit.init();

		var b:Bitmap = new Bitmap(ResourceManager.instance.getBitmapData("img/slinky_small.jpg"));
		Lib.current.stage.addChild(b);
		b.width = 800;
		b.height = 600;
		
		Toolkit.open(function(root:Root) {
			var view:IDisplayObject = Toolkit.processXmlResource("assets/test2.xml");
			root.addChild(view);
			//root.addChild(new TestController().view);
		}, {width: 300, height: 300});
	}
}
