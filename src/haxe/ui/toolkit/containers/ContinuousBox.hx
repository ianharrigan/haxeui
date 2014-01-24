package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.HorizontalContinuousLayout;

class ContinuousBox extends Component {
	public function new() {
		super();

		autoSize = true;
		_layout = new HorizontalContinuousLayout();
	}
}