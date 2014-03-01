package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;

class Container extends Component implements IClonable<Container> {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Clone
	//******************************************************************************************
	public override function self():Container return new Container();
	public override function clone():Container {
		var c:Container = cast super.clone();
		for (child in this.children) {
			c.addChild(child.clone());
		}
		return c;
	}
}