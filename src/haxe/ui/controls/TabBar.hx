package haxe.ui.controls;

import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Rectangle;
import haxe.ui.containers.HBox;
import haxe.ui.containers.ScrollView;
import haxe.ui.core.Component;
import haxe.ui.style.StyleManager;

class TabBar extends ScrollView {
	private var buttons:Array<Button>;
	
	public var selectedIndex(default, setSelectedIndex):Int = 0;
	
	public function new() {
		super();
		//addStyleName("TabBar");
		
		buttons = new Array<Button>();
		
		width = 300;
		viewContent = new HBox();
		//viewContent.width = 500;
		//viewContent.addStyleName("TabBar.content");

		scrollSensitivity = 5;
		showHorizontalScroll = false;
		showVerticalScroll = false;
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
	}
	
	//************************************************************
	//                  TAB FUNCTIONS
	//************************************************************
	public function addTab(title:String, buttonId:String = null):Button {
		var button:Button = new Button();
		if (buttonId != null) {
			button.id = buttonId;
		}
		button.styles = "tab";
		button.toggle = true;
		button.text = title;
		button.allowSelection = false;
		if (buttons.length == 0 && selectedIndex == 0)  {
			button.selected = true;
		}
		
		button.addEventListener(MouseEvent.CLICK, buildMouseClickFunction(buttons.length));
		buttons.push(button);
		addChild(button);
		
		return button;
	}
	
	public function buildMouseClickFunction(index:Int) {
		return function(event:MouseEvent) { mouseClickButton(index); };
	}
	
	private function mouseClickButton(index:Int):Void {
		setSelectedIndex(index);
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setSelectedIndex(value:Int):Int {
		if (value != selectedIndex) {
			for (n in 0...buttons.length) {
				var button:Button = buttons[n];
				if (n == value) {
					button.selected = true;
				} else {
					button.selected = false;
				}
			}
			selectedIndex = value;
			
			var event:Event = new Event(Event.CHANGE);
			dispatchEvent(event);
		}
		return value;
	}
}