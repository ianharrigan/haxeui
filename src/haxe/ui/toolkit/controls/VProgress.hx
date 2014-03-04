package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.layout.Layout;

/**
 Vertical progress bar control
 **/
 
class VProgress extends Progress implements IClonable<VProgress> {
	public function new() {
		super();
		direction = Direction.VERTICAL;
	}
}
