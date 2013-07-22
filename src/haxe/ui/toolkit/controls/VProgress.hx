package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.layout.Layout;

class VProgress extends Progress {
	public function new() {
		super();
		direction = Direction.VERTICAL;
	}
}
