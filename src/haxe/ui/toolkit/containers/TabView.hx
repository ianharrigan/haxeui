package haxe.ui.toolkit.containers;

import flash.events.Event;
import haxe.ui.toolkit.controls.TabBar;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.layout.HorizontalLayout;
import haxe.ui.toolkit.layout.VerticalLayout;

class TabView extends Component {
	private var _tabs:TabBar;
	private var _stack:Stack;
	
	public function new() {
		super();
		_layout = new VerticalLayout();
		
		_tabs = new TabBar();
		_tabs.percentWidth = 100;
		_tabs.id = "tabs";
		_tabs.addEventListener(Event.CHANGE, _onTabsChange);
		addChild(_tabs);
		
		_stack = new Stack();
		_stack.percentWidth = _stack.percentHeight = 100;
		_stack.id = "stack";
		addChild(_stack);
	}

	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onTabsChange(event:Event):Void {
		_stack.selectedIndex = _tabs.selectedIndex;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = null;
		if (child.id == "tabs" || child.id == "stack") {
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
		return _stack.children.length;
	}
}