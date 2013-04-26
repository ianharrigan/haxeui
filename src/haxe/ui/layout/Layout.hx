package haxe.ui.layout;
import haxe.ui.core.Component;
import nme.geom.Point;
import nme.geom.Rectangle;

class Layout {
	public var padding:Rectangle;
	public var spacingX:Int = 0;
	public var spacingY:Int = 0;

	private var c:Component;
	public var component(getComponent, setComponent):Component;
	
	public function new() {
		padding = new Rectangle();
	}
	
	public function getComponent():Component {
		return c;
	}
	
	public function setComponent(value:Component):Component {
		c = value;
		if (c.currentStyle != null) {
			if (c.currentStyle.paddingLeft != null) {
				padding.left = c.currentStyle.paddingLeft;
			}
			if (c.currentStyle.paddingTop != null) {
				padding.top = c.currentStyle.paddingTop;
			}
			if (c.currentStyle.paddingRight != null) {
				padding.right = c.currentStyle.paddingRight;
			}
			if (c.currentStyle.paddingBottom != null) {
				padding.bottom = c.currentStyle.paddingBottom;
			}
			if (c.currentStyle.spacingX != null) {
				spacingX = c.currentStyle.spacingX;
			}
			if (c.currentStyle.spacingY != null) {
				spacingY = c.currentStyle.spacingY;
			}
		}

		return value;
	}
	
	public function calcWidth():Float {
		var maxWidth:Float = c.width;
		for (child in c.listChildComponents()) {
			if (child.width + (padding.left + padding.right) > maxWidth) {
				maxWidth = child.width + (padding.left + padding.right);
			}
		}
		return maxWidth;
	}
	
	public function calcHeight():Float {
		var maxHeight:Float = c.height;
		for (child in c.listChildComponents()) {
			if (child.height + (padding.top + padding.bottom) > maxHeight) {
				maxHeight = child.height + (padding.top + padding.bottom);
			}
		}
		return maxHeight;
	}
	
	public function repositionChildren():Void {
		for (child in c.listChildComponents()) {
			var childX:Float = child.x;
			if (child.horizontalAlign == "left") {
				childX = 0;
			} else if (child.horizontalAlign == "right") {
				childX = c.width - (padding.left + padding.right + child.width);
			} else if (child.horizontalAlign == "center") {
				childX = ((c.width - padding.left - padding.right) / 2) - (child.width / 2);
			}
			child.x = Std.int(childX);
			
			var childY:Float = child.y;
			if (child.verticalAlign == "top") {
				childY = 0;
			} else if (child.verticalAlign == "bottom") {
				childY = c.height - (padding.top + padding.bottom + child.height);
			} else if (child.verticalAlign == "center") {
				childY = ((c.height - padding.top - padding.bottom) / 2) - (child.height / 2);
			}
			child.y = Std.int(childY);
		}
	}
}