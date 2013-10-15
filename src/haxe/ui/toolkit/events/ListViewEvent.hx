package haxe.ui.toolkit.events;

import flash.events.Event;
import haxe.ui.toolkit.containers.ListView.ListViewItem;
import haxe.ui.toolkit.core.Component;

class ListViewEvent extends Event {
	public static var COMPONENT_EVENT:String = "ComponentEvent";
	
	private var li:ListViewItem;
	private var c:Component;

	public var item(get, null):ListViewItem;
	public var component(get, null):Component;

	public function new(type:String, listItem:ListViewItem, component:Component) {
		super(type);
		li = listItem;
		c = component;
	}
	
	public function get_item():ListViewItem {
		return li;
	}
	
	public function get_component():Component {
		return c;
	}
}
