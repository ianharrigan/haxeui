package haxe.ui.test;

import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.HSlider;
import haxe.ui.toolkit.controls.OptionBox;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.selection.List;
import haxe.ui.toolkit.controls.Slider;
import haxe.ui.toolkit.controls.VScroll;
import haxe.ui.toolkit.core.Controller;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.Main;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.controls.Progress;
import haxe.ui.toolkit.style.StyleManager;

class TestController extends XMLController {
	public function new() {
		var resourceId:String = "ui/test02.xml";
		super(resourceId);
		
		if (resourceId != "ui/test02.xml") {
			return;
		}

		attachEvent("perfButton", MouseEvent.CLICK, function(e) {
			trace("perf");
			var b:Button = getComponentAs("perfButton", Button);
			for (x in 0...354) {
				//StyleManager.instance.buildStyleFor(b);
			}
			
			StyleManager.instance.dump();
		});
		
		attachEvent("showSimplePopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showSimple(root, "Basic poup text", "Simple Popup");
		});

		attachEvent("showConfirmPopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showSimple(root, "Are you sure you wish to perform this action?\n\nBad things could happen!", "Confirm Action", PopupButtonType.YES | PopupButtonType.NO, function(b) {
				if (b == PopupButtonType.YES) {
					PopupManager.instance.showSimple(root, "You clicked 'Yes'.", "Result");
				} else if (b == PopupButtonType.NO) {
					PopupManager.instance.showSimple(root, "You clicked 'No'.", "Result");
				}
			});
		});

		attachEvent("showCustomPopup", MouseEvent.CLICK, function(e) {
			var popupController:XMLController = new XMLController("ui/customPopup.xml");
			PopupManager.instance.showCustom(root, popupController.view, "Enter Name", PopupButtonType.CONFIRM | PopupButtonType.CANCEL, function (b) {
				if (b == PopupButtonType.CONFIRM) {
					var name:String = popupController.getComponent("firstName").text + " " + popupController.getComponent("lastName").text;
					PopupManager.instance.showSimple(root, "Hello " + name + "!!!", "Welcome!");
				}
			});
		});

		attachEvent("showListPopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showList(root, ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"], "Select Item", 1, function (item:ListViewItem) {
				PopupManager.instance.showSimple(root, "You selected '" + item.text + "'", "Selection");
			});
		});

		attachEvent("showCalendarPopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showCalendar(root, "Select Date");
		});
		
		attachEvent("theList", ListViewEvent.COMPONENT_EVENT, function (e:ListViewEvent) {
			if (Std.is(e.component, Button)) {
				PopupManager.instance.showSimple(root, "You clicked: " + e.component.text + "!", "Alert!");
			} else if (Std.is(e.component, HSlider)) {
				e.item.subtext = "Slider value: " + Std.int(cast(e.component, HSlider).pos);
			}
		});
		
		attachEvent("styleList", Event.CHANGE, function(e) {
			var style:String = getComponentAs("styleList", List).selectedItems[0].text.toLowerCase();
			RootManager.instance.destroyAllRoots();
			//Toolkit.defaultStyle = style;
			StyleManager.instance.clear();
			ResourceManager.instance.reset();
			if (style == "gradient") {
				Macros.addStyleSheet("assets/styles/gradient/gradient.css");
			} else if (style == "gradient mobile") {
				Macros.addStyleSheet("assets/styles/gradient/gradient_mobile.css");				
			} else if (style == "windows") {
				Macros.addStyleSheet("assets/styles/windows/windows.css");
				Macros.addStyleSheet("assets/styles/windows/buttons.css");
				Macros.addStyleSheet("assets/styles/windows/tabs.css");
				Macros.addStyleSheet("assets/styles/windows/listview.css");
				Macros.addStyleSheet("assets/styles/windows/scrolls.css");
				Macros.addStyleSheet("assets/styles/windows/sliders.css");
				Macros.addStyleSheet("assets/styles/windows/accordion.css");
				Macros.addStyleSheet("assets/styles/windows/rtf.css");
				Macros.addStyleSheet("assets/styles/windows/calendar.css");
				Macros.addStyleSheet("assets/styles/windows/popups.css");
			}
			Toolkit.openFullscreen(function(root:Root) {
				root.addChild(new TestController().view);
			});
		});

		// set demo tab values
		{
			var accordionTrans:String = Toolkit.getTransitionForClass(Accordion);
			if (accordionTrans == "none") {
				getComponentAs("accordionTransNone", OptionBox).selected = true;
			} else if (accordionTrans == "fade") {
				getComponentAs("accordionTransFade", OptionBox).selected = true;
			} else if (accordionTrans == "slide") {
				getComponentAs("accordionTransSlide", OptionBox).selected = true;
			}
			
			attachEvent("accordionTransNone", Event.CHANGE, function(e) {
				if (getComponentAs("accordionTransNone", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Accordion, "none");
				}
			});
			attachEvent("accordionTransFade", Event.CHANGE, function(e) {
				if (getComponentAs("accordionTransFade", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Accordion, "fade");
				}
			});
			attachEvent("accordionTransSlide", Event.CHANGE, function(e) {
				if (getComponentAs("accordionTransSlide", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Accordion, "slide");
				}
			});
		}
		
		{
			var stackTrans:String = Toolkit.getTransitionForClass(Stack);
			if (stackTrans == "none") {
				getComponentAs("tabViewTransNone", OptionBox).selected = true;
			} else if (stackTrans == "fade") {
				getComponentAs("tabViewTransFade", OptionBox).selected = true;
			} else if (stackTrans == "slide") {
				getComponentAs("tabViewTransSlide", OptionBox).selected = true;
			}
			
			attachEvent("tabViewTransNone", Event.CHANGE, function(e) {
				if (getComponentAs("tabViewTransNone", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Stack, "none");
				}
			});
			attachEvent("tabViewTransFade", Event.CHANGE, function(e) {
				if (getComponentAs("tabViewTransFade", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Stack, "fade");
				}
			});
			attachEvent("tabViewTransSlide", Event.CHANGE, function(e) {
				if (getComponentAs("tabViewTransSlide", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Stack, "slide");
				}
			});
		}
		
		{
			var dropDownTrans:String = Toolkit.getTransitionForClass(List);
			if (dropDownTrans == "none") {
				getComponentAs("dropDownTransNone", OptionBox).selected = true;
			} else if (dropDownTrans == "fade") {
				getComponentAs("dropDownTransFade", OptionBox).selected = true;
			} else if (dropDownTrans == "slide") {
				getComponentAs("dropDownTransSlide", OptionBox).selected = true;
			}
			
			attachEvent("dropDownTransNone", Event.CHANGE, function(e) {
				if (getComponentAs("dropDownTransNone", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(List, "none");
				}
			});
			attachEvent("dropDownTransFade", Event.CHANGE, function(e) {
				if (getComponentAs("dropDownTransFade", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(List, "fade");
				}
			});
			attachEvent("dropDownTransSlide", Event.CHANGE, function(e) {
				if (getComponentAs("dropDownTransSlide", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(List, "slide");
				}
			});
		}
		
		{
			var popupsTrans:String = Toolkit.getTransitionForClass(Popup);
			if (popupsTrans == "none") {
				getComponentAs("popupsTransNone", OptionBox).selected = true;
			} else if (popupsTrans == "fade") {
				getComponentAs("popupsTransFade", OptionBox).selected = true;
			} else if (popupsTrans == "slide") {
				getComponentAs("popupsTransSlide", OptionBox).selected = true;
			}
			
			attachEvent("popupsTransNone", Event.CHANGE, function(e) {
				if (getComponentAs("popupsTransNone", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Popup, "none");
				}
			});
			attachEvent("popupsTransFade", Event.CHANGE, function(e) {
				if (getComponentAs("popupsTransFade", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Popup, "fade");
				}
			});
			attachEvent("popupsTransSlide", Event.CHANGE, function(e) {
				if (getComponentAs("popupsTransSlide", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Popup, "slide");
				}
			});
		}
	}
	
}