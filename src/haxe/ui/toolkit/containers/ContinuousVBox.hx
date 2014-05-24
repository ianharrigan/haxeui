package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.VerticalContinuousLayout;

class ContinuousVBox extends Container implements IClonable<ContinuousVBox> {
	public function new() {
		super();
		
		autoSize = true;
		_layout = new VerticalContinuousLayout();
	}
}