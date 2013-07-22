package haxe.ui.toolkit.layout;

class HorizontalLayout extends Layout {
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
			
			totalWidth += child.width;
			if (child.height > totalHeight) {
				totalHeight = child.height;
			}
		}
		
		if (container.numChildren > 1) {
			totalWidth += spacingX * (container.numChildren - 1);
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
			
			xpos += child.width + spacingX;
		}
	}
	
	//******************************************************************************************
	// Helper overrides
	//******************************************************************************************
	private override function get_usableWidth():Float {
		var ucx:Float = super.get_usableWidth();
		
		if (container.numChildren > 1) {
			ucx -= spacingX * (container.numChildren - 1);
		}
		
		for (child in container.children) {
			if (child.width > 0 && child.percentWidth < 0) { // means its a fixed width, ie, not a % sized control
				ucx -= child.width;
			}
		}
		
		if (ucx < 0) {
			ucx = 0;
		}
		
		return ucx;
	}
	
}