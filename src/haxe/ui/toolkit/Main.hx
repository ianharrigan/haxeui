package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.IItemRenderer;
import haxe.ui.toolkit.core.renderers.ComponentItemRenderer;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.hscript.ClientWrapper;
import haxe.ui.toolkit.layout.AbsoluteLayout;
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
		//Toolkit.scaleFactor = 2;
		Toolkit.open(function(root:Root) {
			var view:Component = Toolkit.processXmlResource("assets/test2.xml");
			root.addChild(view);
			
			var b1:Button = view.findChild("b1");
			b1.onClick = function(e) {
				b1.style.color = 0xFF0000;
			};
			var b2:Button = view.findChild("b2");
			b2.onClick = function(e) {
				b2.styleName = "big";
			};
			
	/*		
    var xml:Xml = Xml.parse(ResourceManager.instance.getText("assets/test2.xml"));
    var ui:IDisplayObjectContainer = Toolkit.processXml(xml);
    root.addChild(ui);

    var vbox = cast(ui, VBox);
	vbox.layout = new AbsoluteLayout();

    var t1 = new Text();
    t1.text = "Some info about something";
    t1.style.fontSize = 16;
    t1.style.color = 0xff0000;
	t1.style.backgroundColor = 0x880000;
    t1.percentWidth = 100;
	//t1.id = "bob";

    var t2 = new Text();
	t2.y = 30;
    t2.text = "other new info";
    t2.style.fontSize = 12;
    t2.style.color = 0x0000ee;
	t2.style.backgroundColor = 0x000088;
    t2.percentWidth = 100;
	//t2.id = "bob2";

    var t3 = new Text();
	t3.y = 60;
    t3.text = "something new";
    t3.style.fontSize = 12;
    t3.style.color = 0xffa500;
    t3.style.backgroundColor = 0x88a500;
    t3.percentWidth = 100;
	//t3.id = "bob3";

    vbox.addChild(t1);
    vbox.addChild(t2);
    //vbox.addChild(t3);
		*/	
			
		}/*, {width: 300, height: 300}*/);
	}
}
