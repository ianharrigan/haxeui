package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;

/**
 General purpose spacer component
 **/
class Spacer extends Component implements IClonable<Spacer> {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Clone
	//******************************************************************************************
	public override function self():Spacer return new Spacer();
	public override function clone():Spacer {
		var c:Spacer = cast super.clone();
		return c;
	}
}