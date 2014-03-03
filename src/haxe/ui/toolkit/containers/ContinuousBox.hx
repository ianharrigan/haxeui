package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.HorizontalContinuousLayout;

class ContinuousBox extends Container implements IClonable<ContinuousBox> {
	public function new() {
		super();

		autoSize = true;
		_layout = new HorizontalContinuousLayout();
	}
}