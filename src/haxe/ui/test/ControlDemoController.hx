package haxe.ui.test;
import nme.events.MouseEvent;
import haxe.ui.containers.ListView;
import haxe.ui.controls.DropDownList;
import haxe.ui.controls.ProgressBar;
import haxe.ui.controls.TextInput;
import haxe.ui.core.ComponentParser;
import haxe.ui.core.Controller;
import haxe.ui.popup.Popup;

class ControlDemoController extends Controller {
	public function new() {
		super(ComponentParser.fromXMLAsset("ui/controlDemo.xml"));
		
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
		
		attachEvent("addListItem", MouseEvent.CLICK, function (e) {
			var item:Dynamic = { };
			if (getComponentAs("newItemText", TextInput).text.length > 0) {
				item.text = getComponentAs("newItemText", TextInput).text;
			}
			if (getComponentAs("newItemSubtext", TextInput).text.length > 0) {
				item.subtext = getComponentAs("newItemSubtext", TextInput).text;
			}
			getComponentAs("theList", ListView).addItem(item); // TODO: should just append to data source
		});

		attachEvent("removeListItem", MouseEvent.CLICK, function (e) {
			getComponentAs("theList", ListView).removeItem(getComponentAs("theList", ListView).selectedIndex); // TODO: should delete from datasource
		});
		
		// theme switching is just for testing at the moment, simply recreates the entire app
		attachEvent("windowsTheme", MouseEvent.CLICK, function (e) {
			Main.startApp(Main.WINDOWS_SKIN);
		});

		attachEvent("androidTheme", MouseEvent.CLICK, function (e) {
			Main.startApp(Main.ANDROID_SKIN);
		});

		attachEvent("iosTheme", MouseEvent.CLICK, function (e) {
			Main.startApp(Main.IOS_SKIN);
		});
		
		attachEvent("testTheme", MouseEvent.CLICK, function (e) {
			Main.startApp(Main.TEST_SKIN);
		});
		
		// TODO: temporary, will eventually come from datasource
		getComponentAs("dropdown1", DropDownList).addItem("Item 1");
		getComponentAs("dropdown1", DropDownList).addItem("Item 2");
		getComponentAs("dropdown1", DropDownList).addItem("Item 3");
		getComponentAs("dropdown1", DropDownList).addItem("Item 4");
		getComponentAs("dropdown1", DropDownList).addItem("Item 5");
		getComponentAs("dropdown1", DropDownList).addItem("Item 6");
		getComponentAs("dropdown1", DropDownList).addItem("Item 7");
		getComponentAs("dropdown1", DropDownList).addItem("Item 8");
		
		getComponentAs("dropdown2", DropDownList).addItem("Item 1");
		
		getComponentAs("dropdown3", DropDownList).addItem("Item 1");
		getComponentAs("dropdown3", DropDownList).addItem("Item 2");
		getComponentAs("dropdown3", DropDownList).addItem("Item 3");
		getComponentAs("dropdown3", DropDownList).addItem("Item 4");
		
		
		getComponentAs("dropdownlist1", DropDownList).addItem("Item 1");
		getComponentAs("dropdownlist1", DropDownList).addItem("Item 2");
		getComponentAs("dropdownlist1", DropDownList).addItem("Item 3");
		getComponentAs("dropdownlist1", DropDownList).addItem("Item 4");
		getComponentAs("dropdownlist1", DropDownList).addItem("Item 5");
		getComponentAs("dropdownlist1", DropDownList).addItem("Item 6");
		getComponentAs("dropdownlist1", DropDownList).addItem("Item 7");
		getComponentAs("dropdownlist1", DropDownList).addItem("Item 8");
		
		getComponentAs("dropdownlist2", DropDownList).addItem("Item 1");
		
		getComponentAs("dropdownlist3", DropDownList).addItem("Item 1");
		getComponentAs("dropdownlist3", DropDownList).addItem("Item 2");
		getComponentAs("dropdownlist3", DropDownList).addItem("Item 3");
		getComponentAs("dropdownlist3", DropDownList).addItem("Item 4");

		// list data
		getComponentAs("theList", ListView).addItem( { text: "Louisa Iman" } );
		getComponentAs("theList", ListView).addItem( { text: "Alana Aikins", enabled: false } );
		getComponentAs("theList", ListView).addItem( { text: "Lonnie Massengill" }, "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Javier Rank", subtext: "4 item(s) uploading", type: "progress", value: 65 } );
		getComponentAs("theList", ListView).addItem( { text: "Darcy Lanz", subtext: "Feedback requested", type:"rating", value: 4 }, "userIcon");
		getComponentAs("theList", ListView).addItem( { text: "Jeanie Condron", subtext: "11 item(s) ready", type: "button", value: "Send", fn: function(e) {
			Popup.showSimple(view.root, "You clicked 'Send'");
		}}, "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Tia Luiz", subtext: "Not available", enabled: false } , "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Kurt Jamal", subtext: "Not available", enabled: false } );
		
		// button type
		getComponentAs("theList", ListView).addItem( { text: "Basic button", type: "button", value: "Do It!" } );
		getComponentAs("theList", ListView).addItem( { text: "Disabled button", enabled: false, type: "button", value: "Do It!" } );
		getComponentAs("theList", ListView).addItem( { text: "Button + icon", type: "button", value: "Do It!" }, "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Button + subtext", subtext: "Some subtext", type: "button", value: "Do It!" } );
		getComponentAs("theList", ListView).addItem( { text: "Button + subtext + icon", subtext: "Some subtext", type: "button", value: "Do It!" }, "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Disabled button + subtext + icon", subtext: "Disabled subtext", enabled: false, type: "button", value: "Do It!" } , "favIcon");

		// progress type
		getComponentAs("theList", ListView).addItem( { text: "Basic progress", type: "progress", value: 75 } );
		getComponentAs("theList", ListView).addItem( { text: "Disabled progress", enabled: false, type: "progress", value: 35 } );
		getComponentAs("theList", ListView).addItem( { text: "Progress + icon", type: "progress", value: 95 }, "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Progress + subtext", subtext: "Some subtext", type: "progress", value: 50 } );
		getComponentAs("theList", ListView).addItem( { text: "Progress + subtext + icon", subtext: "Some subtext", type: "progress", value: 45 }, "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Disabled progress + subtext + icon", subtext: "Disabled subtext", enabled: false, type: "progress", value: 55 } , "favIcon");

		// rating type
		getComponentAs("theList", ListView).addItem( { text: "Basic rating", type: "rating", value: 3 } );
		getComponentAs("theList", ListView).addItem( { text: "Disabled rating", enabled: false, type: "rating", value: 4 } );
		getComponentAs("theList", ListView).addItem( { text: "Rating + icon", type: "rating", value: 1 }, "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Rating + subtext", subtext: "Some subtext", type: "rating", value: 0 } );
		getComponentAs("theList", ListView).addItem( { text: "Rating + subtext + icon", subtext: "Some subtext", type: "rating", value: 1 }, "favIcon");
		getComponentAs("theList", ListView).addItem( { text: "Disabled rating + subtext + icon", subtext: "Disabled subtext", enabled: false, type: "rating", value: 5 } , "favIcon");
		
		
		getComponentAs("theList", ListView).addItem( { text: "Katy Doster" } );
		getComponentAs("theList", ListView).addItem( { text: "Allan Sok" } );
		getComponentAs("theList", ListView).addItem( { text: "Rae Platero" } );
		getComponentAs("theList", ListView).addItem( { text: "Gay Hardimon" } );
		getComponentAs("theList", ListView).addItem( { text: "Lonnie Brekke" } );
		getComponentAs("theList", ListView).addItem( { text: "Clayton Fothergill" } );
		getComponentAs("theList", ListView).addItem( { text: "Jessie Jacquemin" } );
		getComponentAs("theList", ListView).addItem( { text: "Lonnie Lakes" } );
		getComponentAs("theList", ListView).addItem( { text: "Clinton Venturi" } );
		getComponentAs("theList", ListView).addItem( { text: "Neil Lawhon" } );
		getComponentAs("theList", ListView).addItem( { text: "Noemi Crowden" } );
		getComponentAs("theList", ListView).addItem( { text: "Pearlie Caulkins" } );
		getComponentAs("theList", ListView).addItem( { text: "Jeanie Condron" } );
		for (n in 0...30) {
			getComponentAs("theList", ListView).addItem("Item " + n);
		}
		
	}
	
}