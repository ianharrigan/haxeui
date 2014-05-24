package haxe.ui.toolkit.layout;

import haxe.ui.toolkit.core.base.HorizontalAlign;

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
			
			totalHeight += child.height;
			if (child.width > totalWidth) {
				totalWidth = child.width;
			}
		}
		
		if (numChildren > 1) {
			totalHeight += spacingY * (numChildren - 1);
		}

		if (container.autoSize) {
			if (totalWidth > 0  && totalWidth != innerWidth && container.percentWidth == -1) {
				container.width = totalWidth + (padding.left + padding.right);
			}
			if (totalHeight > 0 && totalHeight != innerHeight && container.percentHeight == -1) {
				container.height = totalHeight + (padding.top + padding.bottom);
			}
		} else {
			if (totalWidth > 0 && container.height == 0) {
				container.width = totalWidth + (padding.left + padding.right);
				container.height = totalHeight + (padding.top + padding.bottom);
			} else if (totalHeight > 0 && container.width == 0) {
				container.width = totalWidth + (padding.left + padding.right);
				container.height = totalHeight + (padding.top + padding.bottom);
			}
		}
	}
	
	private override function repositionChildren():Void {
		super.repositionChildren();
		var ypos:Float = padding.top;
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			var xpos:Float = padding.left;
			var halign:String = child.horizontalAlign;
			
			switch (halign) {
				case HorizontalAlign.CENTER:
					xpos = (container.width / 2) - (child.width / 2);
				case HorizontalAlign.RIGHT:
					xpos = container.width - child.width - padding.left;
				default:	
			}
			
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
		
		var visibleChildren = 0;
		for (c in container.children) {
			if (c.visible) {
				visibleChildren++;
			}
		}
		
		if (visibleChildren > 1) {
			ucy -= spacingY * (visibleChildren - 1);
		}
		
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
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
