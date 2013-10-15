package haxe.ui.toolkit.events;

import flash.events.Event;
import haxe.ui.toolkit.controls.MenuItem;

class MenuEvent extends Event {
	public static var SELECT:String = Event.SELECT;
	
	public var menuItem(default, default):MenuItem;
	
	public function new(menuItem:MenuItem = null) {
		super(SELECT);
		this.menuItem = menuItem;
	}
	
}