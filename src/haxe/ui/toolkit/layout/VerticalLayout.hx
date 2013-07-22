package haxe.ui.toolkit.layout;

class VerticalLayout extends Layout {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// ILayout
	//******************************************************************************************
	private override function resizeChildren():Void {
		super.resizeChildren();
		var ucx:Float = usableWidth;
		var ucy:Float = usableHeight;
		var totalWidth:Float = 0;
		var totalHeight:Float = 0;
		for (child in container.children) {
			if (child.percentWidth > -1) {
				child.width = (ucx * child.percentWidth) / 100; 
			}
			
			if (child.percentHeight > -1) {
				child.height = (ucy * child.percentHeight) / 100; 
			}
			
			totalHeight += child.height;
			if (child.width > totalWidth) {
				totalWidth = child.width;
			}
		}
		
		if (container.numChildren > 1) {
			totalHeight += spacingY * (container.numChildren - 1);
		}

		if (container.autoSize) {
			if (totalWidth > 0  && totalWidth != innerWidth && container.percentWidth == -1) {
				container.width = totalWidth + (padding.left + padding.right);
			}
			if (totalHeight > 0 && totalHeight != innerHeight && container.percentHeight == -1) {
				container.height = totalHeight + (padding.top + padding.bottom);
			}
		}
	}
	
	private override function repositionChildren():Void {
		super.repositionChildren();
		var xpos:Float = padding.left;
		var ypos:Float = padding.top;
		for (child in container.children) {
			child.x = xpos;
			child.y = ypos;
			
			ypos += child.height + spacingY;
		}
	}

	//******************************************************************************************
	// Helper overrides
	//******************************************************************************************
	private override function get_usableHeight():Float {
		var ucy:Float = super.get_usableHeight();
		
		if (container.numChildren > 1) {
			ucy -= spacingY * (container.numChildren - 1);
		}
		
		for (child in container.children) {
			if (child.height > 0 && child.percentHeight < 0) { // means its a fixed height, ie, not a % sized control
				ucy -= child.height;
			}
		}
		
		if (ucy < 0) {
			ucy = 0;
		}
		
		return ucy;
	}
}
