package haxe.ui.containers;

import haxe.ui.core.Component;
import haxe.ui.layout.HorizonalLayout;

class HBox extends Component {
	public function new() {
		super();
		layout = new HorizonalLayout();
	}
	
	private override function getUsableWidth(c:Component = null):Float {
		var ucx:Float = super.getUsableWidth();
		for (child in childComponents) {
			if (child.percentWidth <= 0 && child.width > 0) {
				ucx -= child.width;
			}
		}
		if (childComponents.length > 1) {
			ucx -= layout.spacingX * (childComponents.length - 1);
		}
		return ucx;
	}
}