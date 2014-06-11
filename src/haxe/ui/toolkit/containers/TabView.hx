package haxe.ui.toolkit.containers;

import openfl.events.Event;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.TabBar;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.layout.VerticalLayout;

class TabView extends Component {
	private var _tabs:TabBar;
	private var _stack:Stack;
	
	public function new() {
		super();
		_layout = new VerticalLayout();
		
		_tabs = new TabBar();
		_tabs.percentWidth = 100;
		_tabs.addEventListener(Event.CHANGE, _onTabsChange);
		_tabs.addEventListener(UIEvent.GLYPH_CLICK, _onGlyphClick);
		addChild(_tabs);
		
		_stack = new Stack();
		_stack.percentWidth = _stack.percentHeight = 100;
		_stack.styleName = "page";
		addChild(_stack);
	}

	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onTabsChange(event:Event):Void {
		_stack.selectedIndex = _tabs.selectedIndex;
		
		var event:UIEvent = new UIEvent(UIEvent.CHANGE);
		dispatchEvent(event);
	}
	
	private function _onGlyphClick(event:UIEvent):Void {
		var newEvent:UIEvent = new UIEvent(UIEvent.GLYPH_CLICK);
		newEvent.data = event.data;
		dispatchEvent(newEvent);
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function initialize():Void {
		super.initialize();
		selectedIndex = 0;
	}
	
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = null;
		if (child == _tabs || child == _stack) {
			r = super.addChild(child);
		} else {
			r = _stack.addChild(child);
			var label:String = "";
			if (Std.is(child, Component)) {
				label = cast(child, Component).text;
			}
			_tabs.addTab(label);
		}
		return r;
	}

	public override function addChildAt(child:IDisplayObject, index:Int):IDisplayObject {
		var r = null;
		if (child == _tabs || child == _stack) {
			r = super.addChildAt(child, index);
		} else {
			r = _stack.addChildAt(child, index);
			var label:String = "";
			if (Std.is(child, Component)) {
				label = cast(child, Component).text;
			}
			_tabs.addTab(label);
		}
		return r;
	}
	
	public override function removeChild(child:IDisplayObject, dispose:Bool = true):IDisplayObject {
		var r = null;
		if (child == _tabs || child == _stack) {
			r = super.removeChild(child, dispose);
		} else {
			r = _stack.removeChild(child, dispose);
		}
		return r;
	}
	
	//******************************************************************************************
	// Getters/setters
	//******************************************************************************************
	public var selectedIndex(get, set):Int;
	public var pageCount(get, null):Int;
	
	private function get_selectedIndex():Int {
		return _tabs.selectedIndex;
	}
	
	private function set_selectedIndex(value:Int):Int {
		_tabs.selectedIndex = value;
		return value;
	}
	
	private function get_pageCount():Int {
		return _stack.numChildren;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public function setTabText(index:Int, text:String):Void {
		_tabs.setTabText(index, text);
	}
	
	public function removeTab(index:Int):Void {
		_stack.removeChildAt(index);
		_tabs.removeTab(index);
	}
	
	public function getTabButton(index:Int):Button {
		return cast _tabs.getTabButton(index);
	}
	
	public function removeAllTabs():Void {
		_stack.removeAllChildren();
		_tabs.removeAllTabs();
	}
}