package haxe.ui.toolkit.layout;

import haxe.ui.toolkit.core.base.VerticalAlign;

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
		var numChildren:Int = 0; // counts visible children.
		
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			numChildren++;
			
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
		
		if (numChildren > 1) {
			totalWidth += spacingX * (numChildren - 1);
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
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			var ypos:Float = padding.top;
			var valign:String = child.verticalAlign;

			switch (valign) {
				case VerticalAlign.CENTER:
					ypos = (container.height / 2) - (child.height / 2);
				case VerticalAlign.BOTTOM:
					ypos = container.height - child.height;
				default:
			}
			
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
		
		var visibleChildren = 0;
		for (c in container.children) {
			if (c.visible) {
				visibleChildren++;
			}
		}
		
		if (visibleChildren > 1) {
			ucx -= spacingX * (visibleChildren - 1);
		}
		
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
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