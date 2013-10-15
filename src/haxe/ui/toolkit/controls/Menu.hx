package haxe.ui.toolkit.controls;

import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.events.MenuEvent;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;

class Menu extends VBox {
	private var _subMenus:Map<MenuItem, Menu>;
	private var _currentItem:MenuItem;
	private var _currentSubMenu:Menu;
	private var _parentMenu:Menu;

	public function new() {
		super();
		_subMenus = new Map<MenuItem, Menu>();
	}
	
	private override function initialize():Void {
		super.initialize();
		
		if (rootMenu == this) {
			root.addEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
		}
	}
	
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = null;

		if (Std.is(child, MenuItem)) {
			cast(child, MenuItem).addEventListener(MouseEvent.MOUSE_OVER, buildMouseOverFunction(this.numChildren));
			cast(child, MenuItem).addEventListener(MouseEvent.CLICK, buildMouseClickFunction(this.numChildren));
			r = super.addChild(child);
		} else if (Std.is(child, Menu)) {
			var item:MenuItem = new MenuItem();
			cast(child, Menu)._parentMenu = this;
			item.text = cast(child, Menu).text;
			item.styleName = "expandable";
			_subMenus.set(item, cast(child, Menu));
			addChild(item);
		}
		
		return r;
	}
	
	private function _onRootMouseDown(event:MouseEvent):Void {
		var mouseIn:Bool = false;
		var menu:Menu = rootMenu;
		while (menu != null) {
			if (menu.hitTest(event.stageX, event.stageY) == true) {
				mouseIn = true;
				break;
			}
			menu = menu._currentSubMenu;
		}
		
		if (mouseIn == false) {
			rootMenu.hideSubMenus();
		}
	}
	
	private function buildMouseOverFunction(index:Int) {
		return function(event:MouseEvent) { mouseOverItem(index); };
	}
	
	private function buildMouseClickFunction(index:Int) {
		return function(event:MouseEvent) { mouseClickItem(index); };
	}

	private function mouseClickItem(index:Int):Void {
		var item:MenuItem = cast(this.getChildAt(index), MenuItem);
		rootMenu.hideSubMenus();
		var e:MenuEvent = new MenuEvent(item);
		rootMenu.dispatchEvent(e);
	}
	
	private function mouseOverItem(index:Int):Void {
		var item:MenuItem = cast(this.getChildAt(index), MenuItem);
		var subMenu:Menu = _subMenus.get(item);
		
		if (_currentItem != null) {
			_currentItem.selected = false;
			_currentItem = null;
		}
		
		if (_currentSubMenu != null && _currentSubMenu != subMenu) {
			hideSubMenus();
		}
		
		if (subMenu != null) {
			subMenu.x = item.stageX + item.width;
			subMenu.y = item.stageY;
			item.selected = true;
			root.addChild(subMenu);
			_currentItem = item;
			_currentSubMenu = subMenu;
		} else {
			//item.selected = false;
		}
	}
	
	public function hideSubMenus():Void {
		if (_currentSubMenu == null) {
			return;
		}

		_currentSubMenu.hideSubMenus();
		root.removeChild(_currentSubMenu, false);
		if (_currentItem != null) {
			_currentItem.selected = false;
			_currentItem = null;
		}
		_currentSubMenu = null;
	}
	
	public var currentSubMenu(get, null):Menu;
	public var parentMenu(get, null):Menu;
	public var rootMenu(get, null):Menu;
	
	private function get_currentSubMenu():Menu {
		return _currentSubMenu;
	}
	
	private function get_parentMenu():Menu {
		return _parentMenu;
	}
	
	private function get_rootMenu():Menu {
		var menu:Menu = this;
		while (menu._parentMenu != null) {
			menu = menu._parentMenu;
		}
		
		return menu;
	}
}