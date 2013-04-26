package haxe.ui.layout;

class VerticalLayout extends Layout {
	public function new() {
		super();
	}
	
	public override function calcHeight():Float {
		var maxHeight:Float = padding.top + padding.bottom;
		for (child in c.listChildComponents()) {
			maxHeight += child.height + spacingY;
		}
		maxHeight -= spacingY;
		return maxHeight;
	}

	public override function repositionChildren():Void {
		var ypos:Float = 0;
		for (child in c.listChildComponents()) {
			child.verticalAlign = "top";

			var childX:Float = child.x;
			if (child.horizontalAlign == "left") {
				childX = 0;
			} else if (child.horizontalAlign == "right") {
				childX = c.width - (padding.left + padding.right + child.width);
			} else if (child.horizontalAlign == "center") {
				childX = ((c.width - padding.left - padding.right) / 2) - (child.width / 2);
			}
			
			child.x = Std.int(childX);
			child.y = Std.int(ypos);
			
			ypos += child.height + spacingY;
		}
	}
}