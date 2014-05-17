package haxe.ui.toolkit.layout;

import haxe.ui.toolkit.core.base.HorizontalAlign;
import haxe.ui.toolkit.core.base.VerticalAlign;

class BoxLayout extends Layout {
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
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			if (child.percentWidth > -1) {
				child.width = (ucx * child.percentWidth) / 100; 
			}
			
			if (child.percentHeight > -1) {
				child.height = (ucy * child.percentHeight) / 100; 
			}
			
			//totalHeight += child.height;
			if (child.width > totalWidth) {
				totalWidth = child.width;
			}
			if (child.height > totalHeight) {
				totalHeight = child.height;
			}
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
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			var xpos:Float = padding.left;
			var ypos:Float = padding.top;
			var halign:String = child.horizontalAlign;
			var valign:String = child.verticalAlign;

			switch (halign) {
				case HorizontalAlign.CENTER:
					xpos = (container.width / 2) - (child.width / 2);
				case HorizontalAlign.RIGHT:
					xpos = container.width - child.width - padding.right;
				default:	
			}

			switch (valign) {
				case VerticalAlign.CENTER:
					ypos = (container.height / 2) - (child.height / 2);
				case VerticalAlign.BOTTOM:
					ypos = container.height - child.height - padding.bottom;
				default:
			}
			
			child.x = xpos;
			child.y = ypos;
			
			//ypos += child.height + spacingY;
		}
	}
	
	//******************************************************************************************
	// Helper overrides
	//******************************************************************************************
	private override function get_usableWidth():Float {
		var ucx:Float = super.get_usableWidth();
		
		/*
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
		*/
		
		return ucx;
	}
	
	private override function get_usableHeight():Float {
		var ucy:Float = super.get_usableHeight();
		
		/*
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
		*/
		
		return ucy;
	}
}