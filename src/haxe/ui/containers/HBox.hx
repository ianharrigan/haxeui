package haxe.ui.containers;

import haxe.ui.core.Component;

class HBox extends Component {
	public function new() {
		super();
		addStyleName("HBox");
	}
	
	private override function repositionChildren():Void {
		var xpos:Float = 0;
		for (child in childComponents) {
			child.horizontalAlign = "left";
			var childY:Float = child.y;
			
			var childY:Float = child.y;
			if (child.verticalAlign == "top") {
				childY = 0;
			} else if (child.verticalAlign == "bottom") {
				childY = height - (padding.top + padding.bottom + child.height);
			} else if (child.verticalAlign == "center") {
				childY = ((height - padding.top - padding.bottom) / 2) - (child.height / 2);
			}
			
			child.x = xpos;
			child.y = childY;
			
			xpos += child.width + spacingX;
		}
	}
	
	private override function calcWidth():Float {
		var maxWidth:Float = padding.left + padding.right;
		for (child in childComponents) {
			maxWidth += child.width + spacingX;
		}
		maxWidth -= spacingX;
		if (width > maxWidth) {
			//maxWidth = width;
		}
		return maxWidth;
	}

	public override function getUsableWidth():Float {
		var ucx:Float = super.getUsableWidth();
		for (child in childComponents) {
			if (child.percentWidth <= 0 && child.width > 0) {
				ucx -= child.width;
			}
		}
		if (childComponents.length > 1) {
			ucx -= spacingX * (childComponents.length - 1);
		}
		return ucx;
	}
}