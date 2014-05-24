package haxe.ui.toolkit;

import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.util.CallStackHelper;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/test2.xml"))
class TestController2 extends XMLController {
	public function new() {
		
		documenttabs.onReady = function(e) {
			documenttabs.getTabButton(0).icon = "img/rtfview/edit-alignment-center.png";
			documenttabs.getTabButton(1).icon = "img/rtfview/edit-alignment-center.png";
			//documenttabs.getTabButton(2).icon = "img/rtfview/edit-alignment-center.png";
			documenttabs.getTabButton(3).icon = "img/rtfview/edit-alignment-center.png";
		};
		
		/*
		bigger.onClick = function(e) {
			documenttabs.setTabText(0, "The tab text is now bigger");
		}

		theInput.onChange = function(e) {
			trace("change");
		}
		*/
		
		/*
		smaller.onClick = function(e) {
			documenttabs.setTabText(0, "Small");
		}
		*/
		
		/*
		test.onClick = function(e) {
			//showSimplePopup("The theme has been changed. You must restart (or refresh) the application to use the new theme");
			theButton2.icon = ResourceManager.instance.getBitmapData("img/slinky_small.jpg");
		};
		*/
		
		/*
		test.onReady = function(e) {
		};
		*/
		

		/*
		dd1.onChange = function(e:UIEvent) {
			
			trace("onChange - " + dd1.selectedItems[0].data.text);
		};
		*/
		
		/*
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
		*/
	}
}