package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.HorizontalLayout;

/**
 Horizontal layout container
 **/
class HBox extends Container implements IClonable<HBox> {
	public function new() {
		super();

		autoSize = true;
		layout = new HorizontalLayout();
	}
}