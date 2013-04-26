package haxe.ui.test;
import haxe.ui.containers.ListView;
import haxe.ui.controls.Button;
import haxe.ui.controls.CheckBox;
import haxe.ui.controls.DropDownList;
import haxe.ui.controls.HSlider;
import haxe.ui.controls.ProgressBar;
import haxe.ui.controls.RatingControl;
import haxe.ui.controls.TextInput;
import haxe.ui.core.ComponentParser;
import haxe.ui.core.Controller;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.JSONDataSource;
import haxe.ui.popup.Popup;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.system.Capabilities;

class ControlDemoController extends Controller {
	public function new() {
		super(ComponentParser.fromXMLResource("ui/controlDemo.xml"));
		
		attachEvent("myButton", MouseEvent.CLICK, function (e) {
			Popup.showSimple(view.root, "You clicked the button!", "Clicked!", true);
		});
		
		attachEvent("addButton", MouseEvent.CLICK, function (e) {
			getComponentAs("progressBar", ProgressBar).value += 10;
		});
		attachEvent("minusButton", MouseEvent.CLICK, function (e) {
			getComponentAs("progressBar", ProgressBar).value -= 10;
		});
		
		attachEvent("listPopup", MouseEvent.CLICK, function (e) {
			Popup.showList(view.root, ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8"], "Select Item", 2, function(item) {
				Popup.showSimple(view.root, "You selected: " + item.text, "Selection", true);
			});
		});
		
		attachEvent("simplePopup", MouseEvent.CLICK, function (e) {
			Popup.showSimple(view.root, "The text", "The Title", true);
		});

		attachEvent("busyPopup", MouseEvent.CLICK, function (e) {
			Popup.showBusy(view.root, "Please wait...", 3000);
		});

		attachEvent("customPopup", MouseEvent.CLICK, function (e) {
			var popupController:Controller = new Controller(ComponentParser.fromXMLResource("ui/customPopup.xml"));
			var customPopup:Popup = Popup.showCustom(view.root, popupController.view, "Enter Name", true);
			popupController.attachEvent("cancelButton", MouseEvent.CLICK, function (e) {
				Popup.hidePopup(customPopup);
			});
			popupController.attachEvent("confirmButton", MouseEvent.CLICK, function (e) {
				Popup.hidePopup(customPopup);
				var text:String = "Hello, " + popupController.getComponent("firstName").text + " " + popupController.getComponent("lastName").text;
				Popup.showSimple(view.root, text, "Welcome");
			});
		});
		
		attachEvent("addListItem", MouseEvent.CLICK, function (e) {
			var item:Dynamic = { };
			if (getComponentAs("newItemText", TextInput).text.length > 0) {
				item.text = getComponentAs("newItemText", TextInput).text;
			}
			if (getComponentAs("newItemSubtext", TextInput).text.length > 0) {
				item.subtext = getComponentAs("newItemSubtext", TextInput).text;
			}
			getComponentAs("theList", ListView).dataSource.add(item);
		});

		attachEvent("removeListItem", MouseEvent.CLICK, function (e) {
			getComponentAs("theList", ListView).removeItem(getComponentAs("theList", ListView).selectedIndex); // TODO: should delete from datasource
		});
		
		// theme switching is just for testing at the moment, simply recreates the entire app
		attachEvent("windowsTheme", MouseEvent.CLICK, function (e) {
			Main.startApp(Main.WINDOWS_SKIN, getComponentAs("asPopup", CheckBox).selected);
		});

		attachEvent("androidTheme", MouseEvent.CLICK, function (e) {
			Main.startApp(Main.ANDROID_SKIN, getComponentAs("asPopup", CheckBox).selected);
		});

		attachEvent("gradientTheme", MouseEvent.CLICK, function (e) {
			Main.startApp(Main.GRADIENT_SKIN, getComponentAs("asPopup", CheckBox).selected);
		});
		
		getComponentAs("asPopup", CheckBox).selected = Main.asPopup;
	
		var value = getComponentAs("hslider", HSlider).value;
		getComponent("hsliderValue").text = "Value: " + value;
		attachEvent("hslider", Event.CHANGE, function (e) {
			var value = getComponentAs("hslider", HSlider).value;
			getComponent("hsliderValue").text = "Value: " + value;
		});
		
		getComponent("capsLang").text = "Capabilities.language: " + Capabilities.language;
		#if !(cpp || neko || html5)
		getComponent("capsOS").text = "Capabilities.os: " + Capabilities.os;
		#end
		getComponent("capsAspectRatio").text = "Capabilities.pixelAspectRatio: " + Capabilities.pixelAspectRatio;
		getComponent("capsDPI").text = "Capabilities.screenDPI: " + Capabilities.screenDPI;
		getComponent("capsResX").text = "Capabilities.screenResolutionX: " + Capabilities.screenResolutionX;
		getComponent("capsResY").text = "Capabilities.screenResolutionY: " + Capabilities.screenResolutionY;

		attachEvent("list1", ListViewEvent.COMPONENT_EVENT, function(e:ListViewEvent) {
			if (e.typeComponent.id == "sendButton") {
				Popup.showSimple(view.root, "You clicked the send button", "Send");
			}
		});

		attachEvent("theList", ListViewEvent.COMPONENT_EVENT, function(e:ListViewEvent) {
			if (Std.is(e.typeComponent, HSlider)) {
				e.item.subtext = "Slider value: " + cast(e.typeComponent, HSlider).value;
			} else if (Std.is(e.typeComponent, DropDownList)) {
				e.item.subtext = "Option selected: " + cast(e.typeComponent, DropDownList).text;
			} else if (Std.is(e.typeComponent, Button)) {
				Popup.showSimple(view.root, "You clicked: " + e.typeComponent.text, "Click!");
			} else if (Std.is(e.typeComponent, RatingControl)) {
				e.item.subtext = "Rating set to: " + cast(e.typeComponent, RatingControl).rating;
			}
		});
		
		//getComponentAs("theList", ListView).dataSource = JSONDataSource.fromResource("data/theList.json");
		//getComponentAs("theList", ListView).dataSource =v JSONDataSource.fromResource("data/dropdown.json");
		attachEvent("theList", Event.SCROLL, function(e) {
			if (getComponentAs("theList", ListView).vscrollPosition >= getComponentAs("theList", ListView).vscrollMax) {
				// TODO: append more to data source if available (test network/db)
				//getComponentAs("theList", ListView).dataSource.addAll(JSONDataSource.fromResource("data/dropdown.json"));
			}
		});

		getComponentAs("dropdown1", DropDownList).dataSource = JSONDataSource.fromResource("data/dropdown.json");
		getComponentAs("dropdown2", DropDownList).dataSource.add( { text: "Item 1" } );
		getComponentAs("dropdown3", DropDownList).dataSource = new ArrayDataSource([
			{ text: "Item 1" },
			{ text: "Item 2" },
			{ text: "Item 3" },
			{ text: "Item 4" }
		]);
	}
	
}