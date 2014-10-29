package haxe.ui.toolkit.events;

import openfl.events.Event;
import haxe.ui.toolkit.controls.Menu;
import haxe.ui.toolkit.controls.MenuItem;

class MenuEvent extends Event {
	public static var SELECT:String = Event.SELECT;
	public static var OPEN:String = Event.OPEN;
	
	public var menuItem(default, default):MenuItem;
	public var menu(default, default):Menu;
	
	public function new(type:String, menuItem:MenuItem = null) {
		super(type);
		this.menuItem = menuItem;
	}
	
}