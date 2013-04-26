package haxe.ui.containers;

import haxe.ui.core.Component;
import haxe.ui.layout.VerticalLayout;

class VBox extends Component {
	public function new() {
		super();
		layout = new VerticalLayout();
	}

	private override function getUsableHeight(c:Component = null):Float {
		var ucy:Float = super.getUsableHeight();
		for (child in childComponents) {
			if (child.percentHeight <= 0 && child.height > 0) {
				ucy -= child.height;
			}
		}
		if (childComponents.length > 1) {
			ucy -= layout.spacingY * (childComponents.length - 1);
		}
		return ucy;
	}
}