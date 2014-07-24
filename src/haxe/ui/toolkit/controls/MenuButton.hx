package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.events.UIEvent;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.events.MenuEvent;
import motion.Actuate;
import motion.easing.Linear;

class MenuButton extends Button {
	private var _menu:Menu;
	
	private static var _currentMenuButton:MenuButton;
	
	public function new() {
		super();
		toggle = true;
		allowSelection = false;
	}
	
	public override function initialize():Void {
		super.initialize();
		
		if (_menu != null) {
			_menu.addEventListener(MenuEvent.SELECT, _onMenuSelect);
			_menu.addEventListener(MenuEvent.OPEN, _onMenuOpen);
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
	
	private override function _onMouseOver(event:MouseEvent):Void {
		super._onMouseOver(event);
		if (_currentMenuButton != null && _currentMenuButton != this) {
			_currentMenuButton.hideMenu();
			this.showMenu();
		}
	}
	
	private override function _onMouseClick(event:MouseEvent):Void {
		if (root.indexOfChild(_menu) == -1) {
			showMenu();
		} else {
			hideMenu();
		}
	}
	
	private override function set_selected(value:Bool):Bool {
		_selected = value;
		if (_selected == true) {
			state = Button.STATE_DOWN;
		} else {
			state = Button.STATE_NORMAL;
		}
		return value;
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
			hideMenu();
		}
	}
	
	private function _onMenuSelect(event:MenuEvent):Void {
		hideMenu();
		var e:MenuEvent = new MenuEvent(MenuEvent.SELECT, event.menuItem);
		dispatchEvent(e);

		var uiEvent:UIEvent = new UIEvent(UIEvent.MENU_SELECT, event.menuItem);
		dispatchEvent(uiEvent);
	}

	private function _onMenuOpen(event:MenuEvent):Void {
		var e:MenuEvent = new MenuEvent(MenuEvent.OPEN);
		e.menu = event.menu;
		dispatchEvent(e);
	}
	
	private function showMenu():Void {
		selected = true;
		_menu.x = this.stageX - root.stageX;
		_menu.y = this.stageY + this.height - root.stageY;
		root.addChild(_menu);
		root.addEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
		_currentMenuButton = this;
		
		var transition:String = Toolkit.getTransitionForClass(Menu);
		if (transition == "slide") {
			_menu.clipHeight = 0;
			_menu.sprite.alpha = 1;
			_menu.visible = true;
			Actuate.tween(_menu, .1, { clipHeight: _menu.height }, true).ease(Linear.easeNone).onComplete(function() {
				_menu.clearClip();
			});
		} else if (transition == "fade") {
			_menu.sprite.alpha = 0;
			_menu.visible = true;
			Actuate.tween(_menu.sprite, .1, { alpha: 1 }, true).ease(Linear.easeNone).onComplete(function() {
			});
		} else {
			_menu.sprite.alpha = 1;
			_menu.visible = true;
		}
		
		var event:MenuEvent = new MenuEvent(MenuEvent.OPEN);
		event.menu = _menu;
		dispatchEvent(event);
	}

	private function hideMenu():Void {
		selected = false;
		
		_menu.hideSubMenus();
		root.removeEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
		
		var transition:String = Toolkit.getTransitionForClass(Menu);
		if (transition == "slide") {
			_menu.sprite.alpha = 1;
			Actuate.tween(_menu, .1, { clipHeight: 0 }, true).ease(Linear.easeNone).onComplete(function() {
				_menu.visible = false;
				_menu.clearClip();
				root.removeChild(_menu, false);
			});
		} else if (transition == "fade") {
			Actuate.tween(_menu.sprite, .1, { alpha: 0 }, true).ease(Linear.easeNone).onComplete(function() {
				_menu.visible = false;
				root.removeChild(_menu, false);
			});
		} else {
			_menu.sprite.alpha = 1;
			_menu.visible = false;
			root.removeChild(_menu, false);
		}
		
		_currentMenuButton = null;
		this.selected = false;
	}
}