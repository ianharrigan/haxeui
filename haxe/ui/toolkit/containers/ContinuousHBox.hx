package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.HorizontalContinuousLayout;

class ContinuousHBox extends Container implements IClonable<ContinuousHBox> {
	public function new() {
		super();

		autoSize = true;
		_layout = new HorizontalContinuousLayout();
	}
}