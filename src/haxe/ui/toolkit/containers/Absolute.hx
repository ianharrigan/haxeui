package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.AbsoluteLayout;

class Absolute extends Container implements IClonable<Absolute> {
	public function new() {
		super();
		
		autoSize = false;
		layout = new AbsoluteLayout();
	}
}