package haxe.ui.containers;

import haxe.ui.core.Component;

class VBox extends Component {
	public function new() {
		super();
		addStyleName("VBox");
	}

	private override function repositionChildren():Void {
		var ypos:Float = 0;
		for (child in childComponents) {
			child.verticalAlign = "top";

			var childX:Float = child.x;
			if (child.horizontalAlign == "left") {
				childX = 0;
			} else if (child.horizontalAlign == "right") {
				childX = width - (padding.left + padding.right + child.width);
			} else if (child.horizontalAlign == "center") {
				childX = ((width - padding.left - padding.right) / 2) - (child.width / 2);
			}
			
			child.x = childX;
			child.y = ypos;
			
			ypos += child.height + spacingY;
		}
	}
	
	private override function calcHeight():Float {
		var maxHeight:Float = padding.top + padding.bottom;
		for (child in childComponents) {
			maxHeight += child.height + spacingY;
		}
		maxHeight -= spacingY;
		if (height > maxHeight) {
			//maxHeight = height;
		}
		return maxHeight;
	}

	public override function getUsableHeight():Float {
		var ucy:Float = super.getUsableHeight();
		for (child in childComponents) {
			if (child.percentHeight <= 0 && child.height > 0) {
				ucy -= child.height + spacingY;
			}
		}
		ucy -= spacingY;
		return ucy;
	}
}