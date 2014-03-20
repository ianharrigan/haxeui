package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IClonable;

/**
 Vertical progress bar control
 **/
 
class VProgress extends Progress implements IClonable<VProgress> {
	public function new() {
		super();
		direction = Direction.VERTICAL;
	}
}
