package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.DisplayObject;
import haxe.ui.toolkit.core.interfaces.IClonable;

class Container extends Component implements IClonable<Container> {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Clone
	//******************************************************************************************
	public override function clone():Container {
		for (child in this.children) {
			c.addChild(cast(child, DisplayObject).clone());
		}
	}
}