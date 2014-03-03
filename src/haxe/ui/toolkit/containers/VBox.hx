package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.VerticalLayout;

/**
 Vertical layout container
 **/
class VBox extends Container implements IClonable<VBox> {
	public function new() {
		super();
		
		autoSize = true;
		layout = new VerticalLayout();
	}
}