package haxe.ui.toolkit.controls;
import flash.events.MouseEvent;
import haxe.ui.events.MenuEvent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;

class MenuButton extends Button {
	private var _menu:Menu;
	
	public function new() {
		super();
		toggle = true;
		allowSelection = false;
	}
	
	public override function initialize():Void {
		super.initialize();
		
		if (_menu != null) {
			_menu.addEventListener(MenuEvent.SELECT, _onMenuSelect);
		}
	}
	
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = null;
		
		if (Std.is(child, MenuItem)) {
			if (_menu == null) {
				_menu = new Menu();
				_menu.root = this.root;
			}
			_menu.addChild(child);
		} else if (Std.is(child, Menu)) {
			_menu = cast(child, Menu);
		} else {
			r = super.addChild(child);
		}
		
		return r;
	}
	
	private override function _onMouseClick(event:MouseEvent):Void {
		if (root.indexOfChild(_menu) == -1) {
			selected = true;
			_menu.x = this.stageX - root.stageX;
			_menu.y = this.stageY + this.height - root.stageY;
			root.addChild(_menu);
			root.addEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
		} else {
			selected = false;
			root.removeChild(_menu, false);
			_menu.hideSubMenus();
			root.removeEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);

		}
	}
	
	private function _onRootMouseDown(event:MouseEvent):Void {
		var mouseIn:Bool = false;
		if (this.hitTest(event.stageX, event.stageY) == true) {
			mouseIn = true;
		}
		if (_menu != null && _menu.hitTest(event.stageX, event.stageY) == true) {
			mouseIn = true;
		}
		if (_menu != null && mouseIn == false) {
			var menu:Menu = _menu.rootMenu;
			while (menu != null) {
				if (menu.hitTest(event.stageX, event.stageY) == true) {
					mouseIn = true;
					break;
				}
				menu = menu.currentSubMenu;
			}
		}
		if (_menu != null && mouseIn == false) {
			selected = false;
			root.removeChild(_menu, false);
			_menu.hideSubMenus();
			root.removeEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
		}
	}
	
	private function _onMenuSelect(event:MenuEvent):Void {
		selected = false;
		root.removeChild(_menu, false);
		_menu.hideSubMenus();
		root.removeEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
		var e:MenuEvent = new MenuEvent(event.menuItem);
		dispatchEvent(e);
	}
}