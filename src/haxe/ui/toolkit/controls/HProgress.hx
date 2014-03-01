package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.layout.Layout;

/**
 Horizontal progress bar control
 
 <b>Events:</b>
 
 * `Event.CHANGE` - Dispatched when value of the progess bar has changed
 **/
 
class HProgress extends Progress implements IClonable<HProgress> {
	public function new() {
		super();
		direction = Direction.HORIZONTAL;
	}
	
	//******************************************************************************************
	// Clone
	//******************************************************************************************
	public override function self():HProgress return new HProgress();
	public override function clone():HProgress {
		var c:HProgress = cast super.clone();
		return c;
	}
}
