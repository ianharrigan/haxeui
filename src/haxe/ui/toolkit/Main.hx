package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IItemRenderer;
import haxe.ui.toolkit.core.renderers.ComponentItemRenderer;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.events.UIEvent;
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

		/*
		var b:Bitmap = new Bitmap(ResourceManager.instance.getBitmapData("img/slinky_small.jpg"));
		Lib.current.stage.addChild(b);
		b.width = 800;
		b.height = 600;
		*/
		
		Toolkit.open(function(root:Root) {
			var view:Component = Toolkit.processXmlResource("assets/test2.xml");
			/*
			var theList:ListView = view.findChild("theList", null, true);
			var text1:TextInput = view.findChild("text1", null, true);
			*/
			//view.sprite.scaleX = 2;
			//view.sprite.scaleY = 2;
			/*
			text1.onClick = function(e) {
				if (text1.text == "") {
					text1.text = " ";
					text1.text = "";
				}
			};
			*/
			/*
			view.findChild("test1", null, true).addEventListener(UIEvent.CLICK, function(e) {
				//var item:ComponentItemRenderer = cast theList.getItem(2);
				//trace(item.component.text);
				text1.text = "bob";
			});
			*/
			root.addChild(view);
			//root.addChild(new TestController().view);
		}/*, {width: 300, height: 300}*/);
	}
}
