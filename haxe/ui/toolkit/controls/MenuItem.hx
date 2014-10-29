package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.controls.Button;

class MenuItem extends Button {
	public function new() {
		super();
		toggle = true;
		allowSelection = false;
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
}