package haxe.ui.toolkit.controls;

import openfl.events.Event;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.events.UIEvent;

/**
 Horizontally scrollable tab bar
 **/
 
@:event("UIEvent.CHANGE", "Dispatched when the selection is changed") 
class TabBar extends ScrollView {
	private var _content:HBox;

	private var _selectedIndex:Int = -1;
	
	public function new() {
		super();
		autoSize = false;
		_scrollSensitivity = 5;
		_showHScroll = _showVScroll = false;
		_content = new HBox();
		_content.id = "content";
		_content.percentHeight = 100;
		_content.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
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
	/**
	 Gets (or sets) the selected button index for the tab bar
	 **/
	public var selectedIndex(get, set):Int;
	public var numTabs(get, null):Int;
	
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
	
	private function get_numTabs():Int {
		return _content.numChildren;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	/**
	 Adds a new button to the tab bar with the specified `text`
	 **/
	public function addTab(text:String):Button {
		var button:Button = new Button();
		button.text = text;
		button.toggle = true;
		button.id = "tabButton";
		button.allowSelection = false;
		_content.addChild(button);
		button.selected = (_content.children.length - 1 == _selectedIndex);
		button.addEventListener(UIEvent.CLICK, tabButtonClick, false, 1);
		button.addEventListener(UIEvent.GLYPH_CLICK, tabGlyphClick);
		return button;
	}
	
	public function removeTab(index:Int):Void {
		_content.removeChildAt(index);
		var newIndex:Int = selectedIndex;
		if (newIndex > _content.numChildren - 1) {
			newIndex = _content.numChildren - 1;
		}
		selectedIndex = -1;
		selectedIndex = newIndex;
	}
	
	public function getTabButton(index:Int):Button {
		return cast _content.getChildAt(index);
	}
	
	public function removeAllTabs():Void {
		_content.removeAllChildren();
		_selectedIndex = -1;
	}
	
	public function setTabText(index:Int, text:String):Void {
		var button:Button = cast(_content.getChildAt(index), Button);
		button.text = text;
	}
	
	private function tabButtonClick(event:UIEvent):Void {
		selectedIndex = _content.indexOfChild(event.displayObject);
	}
	
	private function tabGlyphClick(event:UIEvent):Void {
		var newEvent:UIEvent = new UIEvent(UIEvent.GLYPH_CLICK);
		newEvent.data = _content.indexOfChild(event.displayObject);
		dispatchEvent(newEvent);
	}
	
	private override function _onMouseWheel(event:MouseEvent):Void {
		if (_hscroll != null && _content.width > layout.usableWidth) {
			if (event.delta != 0) {
				if (event.delta < 0) {
					_hscroll.incrementValue();
				} else if (event.delta > 0) {
					_hscroll.deincrementValue();
				}
			}
		}
	}
}