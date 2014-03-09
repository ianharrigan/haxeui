package haxe.ui.toolkit;

import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/test2.xml"))
class TestController2 extends XMLController {
	public function new() {
		PopupManager.instance.defaultTitle = "Popup Tests!";
		
		simple1.onClick = function(e) {
			showPopup("This is a test");
		};
		
		simple2.onClick = function(e) {
			showPopup("This is a test", PopupButton.OK | PopupButton.CANCEL);
		};
		
		simple3.onClick = function(e) {
			showPopup("This is a test", PopupButton.OK | PopupButton.CANCEL, function(r:Dynamic) {
				
			});
		};
		
		simple4.onClick = function(e) {
			showPopup("This is a test", [PopupButton.OK, PopupButton.CANCEL], function(r:Dynamic) {
				
			});
		};
		
		simple5.onClick = function(e) {
			showPopup("This is a test", [{text: "Custom 1"}, {text: "Custom 2"}], function(r:Dynamic) {
				
			});
		};
		
		simple6.onClick = function(e) {
			showPopup("This is a test", {buttons: [{text: "Custom 1"}, {text: "Custom 2"}], modal: false}, function(r:Dynamic) {
				
			});
		};
		
		custom1.onClick = function(e) {
			showCustomPopup("assets/custom.xml");
		};
		
		list1.onClick = function(e) {
			showListPopup(["Item 1", "Item 2", "Item 3", "Item 4"]);
		}
		
		busy1.onClick = function(e) {
			showBusyPopup("Wait", 2000);
		}
		
		cal1.onClick = function(e) {
			showCalendarPopup();
		}
	}
}