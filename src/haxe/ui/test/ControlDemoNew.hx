package haxe.ui.test;
import nme.events.Event;
import nme.events.MouseEvent;
import haxe.ui.containers.HBox;
import haxe.ui.containers.ListView;
import haxe.ui.containers.ScrollView;
import haxe.ui.containers.TabView;
import haxe.ui.containers.VBox;
import haxe.ui.controls.Button;
import haxe.ui.controls.CheckBox;
import haxe.ui.controls.DropDownList;
import haxe.ui.controls.HScroll;
import haxe.ui.controls.Image;
import haxe.ui.controls.Label;
import haxe.ui.controls.OptionBox;
import haxe.ui.controls.ProgressBar;
import haxe.ui.controls.RatingControl;
import haxe.ui.controls.TextInput;
import haxe.ui.controls.ValueControl;
import haxe.ui.controls.VScroll;
import haxe.ui.core.Component;
import haxe.ui.popup.Popup;
import haxe.ui.style.StyleManager;

class ControlDemoNew extends Component {
	private var tabView:TabView;
	
	public function new() {
		super();
	}
	
	public override function initialize():Void {
		super.initialize();
	
		tabView = new TabView();
		tabView.percentWidth = 100;
		tabView.percentHeight = 100;
		
		tabView.addPage("List", createPage_LIST(), "favIcon");
		tabView.addPage("Selection", createPage_SELECTION(), "favIcon");
		tabView.addPage("Basic", createPage_BASIC(), "favIcon");
		tabView.addPage("Scrolls", createPage_SCROLLS(), "favIcon");
		tabView.addPage("Styles", createPage_THEME(), "favIcon");
		tabView.addPage("Page 4", null, "favIcon");
		tabView.addPage("Page 5", null, "favIcon");
		tabView.addPage("Page 6", null, "favIcon");
		tabView.addPage("Page 7", null, "favIcon");
		tabView.addPage("Page 8", null, "favIcon");
		tabView.addPage("Page 9", null, "favIcon");
		tabView.addPage("Page0", null, "favIcon");
		
		addChild(tabView);
		
	}
	
	private function createPage_BASIC():Component {
		var c:Component = new VBox();
		
		{
			var hbox:HBox = new HBox();
			
			var button:Button = new Button();
			button.text = "Button";
			hbox.addChild(button);

			var button:Button = new Button();
			button.text = "Styled";
			button.id = "myStyledButton";
			hbox.addChild(button);
			
			var button:Button = new Button();
			button.text = "Toggle 1";
			button.toggle = true;
			button.selected = true;
			hbox.addChild(button);
			
			var button:Button = new Button();
			button.text = "Toggle 2";
			button.toggle = true;
			hbox.addChild(button);
			
			c.addChild(hbox);
		}

		var ratings:RatingControl = new RatingControl();
		c.addChild(ratings);
		
		{
			var hbox:HBox = new HBox();
			
			var progress:ProgressBar = new ProgressBar();
			hbox.addChild(progress);

			var button:Button = new Button();
			button.text = "-";
			button.addEventListener(MouseEvent.CLICK, function (e) {
				progress.value -= 10;
			});
			hbox.addChild(button);
			
			var button:Button = new Button();
			button.text = "+";
			button.addEventListener(MouseEvent.CLICK, function (e) {
				progress.value += 10;
			});
			hbox.addChild(button);
			
			c.addChild(hbox);
		}
		
		{
			var hbox:HBox = new HBox();
			
			var checkbox:CheckBox = new CheckBox();
			checkbox.text = "Checkbox 1";
			hbox.addChild(checkbox);

			var checkbox:CheckBox = new CheckBox();
			checkbox.text = "Checkbox 2";
			checkbox.selected = true;
			hbox.addChild(checkbox);

			var checkbox:CheckBox = new CheckBox();
			checkbox.text = "Checkbox 3";
			hbox.addChild(checkbox);
			
			c.addChild(hbox);
		}

		{
			var hbox:HBox = new HBox();
			
			var optionbox:OptionBox = new OptionBox();
			optionbox.text = "Option 1A";
			optionbox.group = "A";
			optionbox.selected = true;
			hbox.addChild(optionbox);

			var optionbox:OptionBox = new OptionBox();
			optionbox.text = "Option 2A";
			optionbox.group = "A";
			optionbox.selected = false;
			hbox.addChild(optionbox);

			var optionbox:OptionBox = new OptionBox();
			optionbox.text = "Option 3A";
			optionbox.group = "A";
			hbox.addChild(optionbox);

			var optionbox:OptionBox = new OptionBox();
			optionbox.text = "Option 1B";
			optionbox.group = "B";
			hbox.addChild(optionbox);

			var optionbox:OptionBox = new OptionBox();
			optionbox.text = "Option 2B";
			optionbox.group = "B";
			optionbox.selected = true;
			hbox.addChild(optionbox);

			var optionbox:OptionBox = new OptionBox();
			optionbox.text = "Option 3B";
			optionbox.group = "B";
			hbox.addChild(optionbox);
			
			c.addChild(hbox);
		}
		
		{
			var hbox:HBox = new HBox();
			
			var textInput:TextInput = new TextInput();
			textInput.text = "Basic input";
			hbox.addChild(textInput);
			
			var textInput:TextInput = new TextInput();
			textInput.multiline = true;
			textInput.text = "Multiline text";
			textInput.height = 100;
			hbox.addChild(textInput);

			c.addChild(hbox);
		}

		var textInput:TextInput = new TextInput();
		textInput.multiline = true;
		textInput.text = "Multiline text.\nLine 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10";
		textInput.height = 100;
		textInput.percentWidth = 100;
		c.addChild(textInput);
		
		return c;
	}

	private function createPage_SELECTION():Component {
		var c:Component = new VBox();
		
		{
			var hbox:HBox = new HBox();
			
			var dropDown:DropDownList = new DropDownList();
			dropDown.text = "Dropdown list 1";
			dropDown.width = 200;
			dropDown.addItem("Item 1");
			dropDown.addItem("Item 2");
			dropDown.addItem("Item 3");
			dropDown.addItem("Item 4");
			dropDown.addItem("Item 5");
			dropDown.addItem("Item 6");
			dropDown.addItem("Item 7");
			dropDown.addItem("Item 8");
			dropDown.method = "dropdown";
			hbox.addChild(dropDown);

			c.addChild(hbox);
		}
		
		{
			var hbox:HBox = new HBox();
			
			var button:Button = new Button();
			button.text = "List Popup";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				Popup.showList(root, ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8"], "Select Item", 2, function(item) {
				});
			});
			hbox.addChild(button);

			var dropDown:DropDownList = new DropDownList();
			dropDown.text = "Dropdown list 2";
			dropDown.addItem("Item 1");
			hbox.addChild(dropDown);
			
			c.addChild(hbox);
		}

		{
			var hbox:HBox = new HBox();
			
			var button:Button = new Button();
			button.text = "Simple Popup";
			button.addEventListener(MouseEvent.CLICK, function(e) {
				Popup.showSimple(root, "The text", "The Title", true);
			});
			hbox.addChild(button);

			
			var dropDown:DropDownList = new DropDownList();
			dropDown.text = "Dropdown list 3";
			dropDown.addItem("Item 1");
			dropDown.addItem("Item 2");
			dropDown.addItem("Item 3");
			dropDown.addItem("Item 4");
			hbox.addChild(dropDown);

			c.addChild(hbox);
		}
		return c;
	}
	
	private function createPage_THEME():Component {
		var c:Component = new VBox();
		c.percentWidth = 100;
		c.percentHeight = 100;
		
		var hbox:HBox = new HBox();
		
		var b:Button = new Button();
		b.text = "Windows";
		b.addEventListener(MouseEvent.CLICK, function(e) {
			Main.startApp(Main.WINDOWS_SKIN);
		});
		hbox.addChild(b);

		var b:Button = new Button();
		b.text = "Android";
		b.addEventListener(MouseEvent.CLICK, function(e) {
			Main.startApp(Main.ANDROID_SKIN);
		});
		hbox.addChild(b);

		var b:Button = new Button();
		b.text = "Test";
		b.enabled = true;
		b.addEventListener(MouseEvent.CLICK, function(e) {
			Main.startApp(Main.TEST_SKIN);
		});
		hbox.addChild(b);
		
		c.addChild(hbox);
		
		return c;
	}	
	
	private function createPage_SCROLLS():Component {
		var c:Component = new VBox();
		
		{
			var hbox:HBox = new HBox();
			
			var vscroll:VScroll = new VScroll();
			hbox.addChild(vscroll);

			var vscroll:VScroll = new VScroll();
			vscroll.height = 200;
			hbox.addChild(vscroll);

			var vscroll:VScroll = new VScroll();
			vscroll.height = 200;
			vscroll.width = 30;
			hbox.addChild(vscroll);
			
			var image:Image = new Image();
			image.bitmapAssetPath = "img/slinky.jpg";
			var scrollView:ScrollView = new ScrollView();
			scrollView.addChild(image);
			scrollView.width = 200;
			scrollView.height = 200;
			hbox.addChild(scrollView);
			
			c.addChild(hbox);
		}
		
		var hscroll:HScroll = new HScroll();
		c.addChild(hscroll);

		var hscroll:HScroll = new HScroll();
		hscroll.percentWidth = 100;
		c.addChild(hscroll);

		var hscroll:HScroll = new HScroll();
		hscroll.width = 200;
		hscroll.height = 30;
		c.addChild(hscroll);
		
		return c;
	}
	
	private var theList:ListView;
	private function createPage_LIST():Component {
		var c:Component = new VBox();
		c.id = "vbox";
		//c.percentWidth = 100;
		//c.percentHeight = 100;
		
		
	
		{
			var hbox:HBox = new HBox();
			
			var dropDown:DropDownList = new DropDownList();
			dropDown.text = "Dropdown list 1";
			dropDown.width = 200;
			dropDown.addItem({text: "Item 1", type: "progress", value: 15});
			dropDown.addItem({text: "Item 2", subtext: "subtext"});
			dropDown.addItem( { text: "Item 3", type: "button", value:"Dummy", fn: function(e) {
				Popup.showSimple(root, "You clicked 'Dummy'");
			}});
			dropDown.addItem({text: "Item 4", type: "rating", value: 3, fn: function(e) {
				Popup.showSimple(root, "You changed rating to: " + e);
			}});
			dropDown.addItem("Item 5");
			dropDown.addItem("Item 6");
			dropDown.addItem("Item 7");
			dropDown.addItem("Item 8");
			dropDown.method = "dropdown";
			hbox.addChild(dropDown);

			var dropDown:DropDownList = new DropDownList();
			dropDown.text = "Dropdown list 2";
			dropDown.addItem("Item 1");
			hbox.addChild(dropDown);
			
			var dropDown:DropDownList = new DropDownList();
			dropDown.text = "Dropdown list 3";
			dropDown.addItem("Item 1");
			dropDown.addItem("Item 2");
			dropDown.addItem("Item 3");
			dropDown.addItem("Item 4");
			hbox.addChild(dropDown);
			
			
			c.addChild(hbox);
		}
		
		var hbox:HBox = new HBox();
		hbox.percentWidth = 100;
		hbox.percentHeight = 100;
		
		var listCount = 2;
		for (n in 0...listCount) {
			var list:ListView = new ListView();
			list.percentWidth = Std.int(100 / listCount);
			list.percentHeight = 100;
			list.addItem( { text: "Louisa Iman" } );
			list.addItem( { text: "Alana Aikins", enabled: false } );
			list.addItem( { text: "Lonnie Massengill" }, "favIcon");
			list.addItem( { text: "Javier Rank", subtext: "4 item(s) uploading", type: "progress", value: 65 } );
			list.addItem( { text: "Darcy Lanz", subtext: "Feedback requested", type:"rating", value: 4 }, "userIcon");
			list.addItem( { text: "Jeanie Condron", subtext: "11 item(s) ready", type: "button", value: "Send", fn: function(e) {
				Popup.showSimple(root, "You clicked 'Send'");
			}}, "favIcon");
			list.addItem( { text: "Tia Luiz", subtext: "Not available", enabled: false } , "favIcon");
			list.addItem( { text: "Kurt Jamal", subtext: "Not available", enabled: false } );
			
			// button type
			list.addItem( { text: "Basic button", type: "button", value: "Do It!" } );
			list.addItem( { text: "Disabled button", enabled: false, type: "button", value: "Do It!" } );
			list.addItem( { text: "Button + icon", type: "button", value: "Do It!" }, "favIcon");
			list.addItem( { text: "Button + subtext", subtext: "Some subtext", type: "button", value: "Do It!" } );
			list.addItem( { text: "Button + subtext + icon", subtext: "Some subtext", type: "button", value: "Do It!" }, "favIcon");
			list.addItem( { text: "Disabled button + subtext + icon", subtext: "Disabled subtext", enabled: false, type: "button", value: "Do It!" } , "favIcon");

			// progress type
			list.addItem( { text: "Basic progress", type: "progress", value: 75 } );
			list.addItem( { text: "Disabled progress", enabled: false, type: "progress", value: 35 } );
			list.addItem( { text: "Progress + icon", type: "progress", value: 95 }, "favIcon");
			list.addItem( { text: "Progress + subtext", subtext: "Some subtext", type: "progress", value: 50 } );
			list.addItem( { text: "Progress + subtext + icon", subtext: "Some subtext", type: "progress", value: 45 }, "favIcon");
			list.addItem( { text: "Disabled progress + subtext + icon", subtext: "Disabled subtext", enabled: false, type: "progress", value: 55 } , "favIcon");

			// rating type
			list.addItem( { text: "Basic rating", type: "rating", value: 3 } );
			list.addItem( { text: "Disabled rating", enabled: false, type: "rating", value: 4 } );
			list.addItem( { text: "Rating + icon", type: "rating", value: 1 }, "favIcon");
			list.addItem( { text: "Rating + subtext", subtext: "Some subtext", type: "rating", value: 0 } );
			list.addItem( { text: "Rating + subtext + icon", subtext: "Some subtext", type: "rating", value: 1 }, "favIcon");
			list.addItem( { text: "Disabled rating + subtext + icon", subtext: "Disabled subtext", enabled: false, type: "rating", value: 5 } , "favIcon");
			
			
			list.addItem( { text: "Katy Doster" } );
			list.addItem( { text: "Allan Sok" } );
			list.addItem( { text: "Rae Platero" } );
			list.addItem( { text: "Gay Hardimon" } );
			list.addItem( { text: "Lonnie Brekke" } );
			list.addItem( { text: "Clayton Fothergill" } );
			list.addItem( { text: "Jessie Jacquemin" } );
			list.addItem( { text: "Lonnie Lakes" } );
			list.addItem( { text: "Clinton Venturi" } );
			list.addItem( { text: "Neil Lawhon" } );
			list.addItem( { text: "Noemi Crowden" } );
			list.addItem( { text: "Pearlie Caulkins" } );
			list.addItem( { text: "Jeanie Condron" } );
			for (n in 0...30) {
				list.addItem("Item " + n);
			}
			hbox.addChild(list);
			theList = list;
		}


		c.addChild(hbox);
		

		var hbox:HBox = new HBox();
		hbox.horizontalAlign = "left";
		var label:Label = new Label();
		label.width = 70;
		label.verticalAlign = "center";
		label.text = "Text: ";
		hbox.addChild(label);
		var newListItemText:TextInput = new TextInput();
		newListItemText.text = "New item";
		hbox.addChild(newListItemText);
		c.addChild(hbox);

		var hbox:HBox = new HBox();
		hbox.horizontalAlign = "left";
		var label:Label = new Label();
		label.width = 70;
		label.verticalAlign = "center";
		label.text = "Sub text: ";
		hbox.addChild(label);
		var newListItemSubtext:TextInput = new TextInput();
		newListItemSubtext.text = "New item subtext";
		hbox.addChild(newListItemSubtext);
		c.addChild(hbox);
		
		var hbox:HBox = new HBox();
		hbox.horizontalAlign = "left";
		
		theList.addEventListener(Event.CHANGE, function(e) {
			var item:ListViewItem = theList.getListItem(theList.selectedIndex);
			newListItemText.text = item.text;
			newListItemSubtext.text = item.subtext;
		});
		
		
		var button:Button = new Button();
		button.text = "Add Item";
		button.addEventListener(MouseEvent.CLICK, function (e) {
			var item:Dynamic = { };
			if (newListItemText.text.length > 0) {
				item.text = newListItemText.text;
			}
			if (newListItemSubtext.text.length > 0) {
				item.subtext = newListItemSubtext.text;
			}
			theList.addItem(item);
		});
		hbox.addChild(button);
		
		var button:Button = new Button();
		button.text = "Remove Item";
		button.addEventListener(MouseEvent.CLICK, function (e) {
			theList.removeItem(theList.selectedIndex);
		});
		hbox.addChild(button);
		
		c.addChild(hbox);
		/*
		var vbox:VBox = new VBox();
		var button:Button+ = new Button();
		button.text = "Add";
		button.addEventListener(MouseEvent.CLICK, function (e) {
		});
		vbox.addChild(button);
		c.addChild(vbox);
		*/
		
		/*
		var scrollView:ScrollView = new ScrollView();
		scrollView.content = c;
		scrollView.percentWidth = 100;
		scrollView.percentHeight = 100;
		
		return scrollView;
		*/
		return c;
	}
}