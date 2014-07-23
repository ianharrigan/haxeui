package haxe.ui.toolkit;

import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.renderers.ComponentItemRenderer;
import haxe.ui.toolkit.core.RootManager;
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
	
	private static function onTest(event:UIEvent):Void {
		trace("Clicked");
	}
	static var _temp:Int = 0;
	
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

			
			/*
			var t:TestClass = new TestClass();
			t.doTest();
			
			return;
			*/
			
			var vbox:VBox = Toolkit.processXmlResource("assets/test.xml");
			root.addChild(vbox);
			
			var test:Button = vbox.findChild("test");
			test.addEventListener(UIEvent.CLICK, onTest);
			test.removeEventListener(UIEvent.CLICK, onTest);
			test.addEventListener(UIEvent.CLICK, onTest);
			test.removeEventListener(UIEvent.CLICK, onTest);
			var lv:ListView = vbox.findChild("lv");
			
			lv.dataSource.removeAll();
			lv.invalidate(InvalidationFlag.DATA);
			for (x in 0...10) {
				var o = {
					text: "Text" + x,
					controlId: "modifyButton",
					componentType: "button",
					componentValue: "Modify " + x,
				}
				lv.dataSource.add(o);
			}
			

			lv.onComponentEvent = function(e:UIEvent) {
				trace("Component event - " + e.component.text);
			};
			
			test.onClick = function(e) {
				lv.disabled = true;
					lv.dataSource.moveFirst();
					do {
						var data:Dynamic = lv.dataSource.get();
						data.text = "Changed " + _temp;
						
					} while (lv.dataSource.moveNext()); 
					lv.invalidate(InvalidationFlag.DATA);
					_temp++;
				lv.disabled = false;	
			};
		});
	}
}
