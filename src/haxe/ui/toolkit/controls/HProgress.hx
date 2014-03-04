package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.layout.Layout;

/**
 Horizontal progress bar control
 **/
 
class HProgress extends Progress implements IClonable<HProgress> {
	public function new() {
		super();
		direction = Direction.HORIZONTAL;
	}
}
