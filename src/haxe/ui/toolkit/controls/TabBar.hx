package haxe.ui.toolkit.controls;

import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;

class TabBar extends ScrollView {
	private var _content:HBox;

	private var _selectedIndex:Int = 0;
	
	public function new() {
		super();
		autoSize = false;
		_scrollSensitivity = 5;
		_showHScroll = _showVScroll = false;
		_content = new HBox();
		_content.percentHeight = 100;
		addChild(_content);
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
	}

	//******************************************************************************************
	// Getters/setters
	//******************************************************************************************
	public var selectedIndex(get, set):Int;
	
	private function get_selectedIndex():Int {
		return _selectedIndex;
	}
	
	private function set_selectedIndex(value:Int):Int {
		if (value != _selectedIndex) {
			for (n in 0..._content.children.length) {
				var button:Button = cast(_content.children[n], Button);
				if (n == value) {
					button.selected = true;
				} else {
					button.selected = false;
				}
			}
			_selectedIndex = value;
			
			var event:Event = new Event(Event.CHANGE);
			dispatchEvent(event);
		}
		return value;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public function addTab(text:String):Void {
		var button:Button = new Button();
		button.text = text;
		button.toggle = true;
		button.id = "tabButton";
		button.allowSelection = false;
		_content.addChild(button);
		button.selected = (_content.children.length - 1 == _selectedIndex);
		button.addEventListener(MouseEvent.CLICK, buildMouseClickFunction(_content.children.length - 1));
	}
	
	private function buildMouseClickFunction(index:Int) {
		return function(event:MouseEvent) { mouseClickButton(index); };
	}
	
	private function mouseClickButton(index:Int):Void {
		selectedIndex = index;
	}
}