package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.VerticalLayout;

class VBox extends Component {
	public function new() {
		super();
		
		autoSize = true;
		layout = new VerticalLayout();
	}
}