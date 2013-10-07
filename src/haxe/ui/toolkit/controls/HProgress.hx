package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.layout.Layout;

/**
 Horizontal progress bar control
 
 <b>Events:</b>
 
 * `Event.CHANGE` - Dispatched when value of the progess bar has changed
 **/
 
class HProgress extends Progress {
	public function new() {
		super();
		direction = Direction.HORIZONTAL;
	}
	
}
