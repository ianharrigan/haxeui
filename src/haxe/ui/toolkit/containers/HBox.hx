package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.HorizontalLayout;

class HBox extends Component {
	public function new() {
		super();
		
		autoSize = true;
		layout = new HorizontalLayout();
	}
}