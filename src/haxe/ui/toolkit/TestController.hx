package haxe.ui.toolkit;

import flash.events.MouseEvent;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.util.StringUtil;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/test.xml"))
class TestController extends XMLController {
	public function new() {
		/*
		testButton.addEventListener(UIEvent.CLICK, function (e) {
			trace("clicked");
		});
		*/
		
		testButton.onClick = function(e:UIEvent) {
			mainTabs.removeAllTabs();
		};

		testButton2.onClick = function(e:UIEvent) {
			var c:Component = Toolkit.processXmlResource("assets/tab2.xml");

			var container:VBox = new VBox();
			//container.percentWidth = container.percentHeight = 100;
			container.text = "Bob";
			container.addChild(c);
			mainTabs.addChild(container);
			
			mainTabs.selectedIndex = 0;
			container.invalidate();
			container.onAddedToStage = function(e) {
				trace("added");
			};
		};
		
		testButton.onMouseOver = function(e:UIEvent) {
			//trace("over");
		};

		attachEvent("showSimplePopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showSimple(root, "Basic poup text", "Simple Popup");
		});
	}
	
}