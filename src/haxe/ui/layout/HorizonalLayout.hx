package haxe.ui.layout;

class HorizonalLayout extends Layout {
	public function new() {
		super();
	}
	
	public override function calcWidth():Float {
		var maxWidth:Float = padding.left + padding.right;
		for (child in c.listChildComponents()) {
			maxWidth += child.width + spacingX;
		}
		maxWidth -= spacingX;
		return maxWidth;
	}
	
	public override function repositionChildren():Void {
		var xpos:Float = 0;
		for (child in c.listChildComponents()) {
			child.horizontalAlign = "left";
			var childY:Float = child.y;
			
			var childY:Float = child.y;
			if (child.verticalAlign == "top") {
				childY = 0;
			} else if (child.verticalAlign == "bottom") {
				childY = c.height - (padding.top + padding.bottom + child.height);
			} else if (child.verticalAlign == "center") {
				childY = ((c.height - padding.top - padding.bottom) / 2) - (child.height / 2);
			}
			
			child.x = Std.int(xpos);
			child.y = Std.int(childY);
			
			xpos += child.width + spacingX;
		}
	}
}