package haxe.ui.toolkit.layout;

import haxe.ui.toolkit.core.base.HorizontalAlign;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;

class VerticalContinuousLayout extends Layout {
	public function new() {
		super();
	}
	
	private override function repositionChildren():Void {
		super.repositionChildren();
		
		var xpos:Float = padding.left;
		var ypos:Float = padding.top;
		var usedCX:Float = padding.left + padding.right;
		var usedCY:Float = padding.top + padding.bottom;
		var colCX:Float = 0;
		var colWidths:Array<Float> = new Array<Float>();
		var colChildren:Array<IDisplayObject> = new Array<IDisplayObject>();
		colWidths.push(0);
		var col:Int = 0;
		var maxCY:Float = container.height;
		if (container.autoSize == true && container.parent != null) {
			maxCY = container.parent.layout.usableHeight;
		}
		
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			colChildren.push(child);
			usedCY += child.height + spacingY;
			if (usedCY - spacingY > maxCY) {
				ypos = padding.top;
				colWidths.push(0);
				xpos += colWidths[col] + spacingX;
				col++;
				usedCY = padding.top + padding.bottom + child.height + spacingY;
				
				colChildren = new Array<IDisplayObject>();
				colChildren.push(child);
			}
			
			var reposition:Bool = false;
			if (child.width > colWidths[col]) {
				colWidths[col] = child.width;
				reposition = true;
			}
			
			usedCX = padding.left + padding.right;
			for (cx in colWidths) {
				usedCX += cx + spacingX;
			}
			usedCX -= spacingX;
			
			if (reposition) {
				for (temp in colChildren) {
					var halign:String = child.horizontalAlign;
					var tempXpos:Float = temp.x;
					switch (halign) {
						case HorizontalAlign.CENTER:
							tempXpos = usedCX - temp.width - padding.left - ((colWidths[col] / 2) - (temp.width / 2));
						case HorizontalAlign.RIGHT:
							tempXpos = usedCX - temp.width - padding.left;
						default:
					}
					temp.x = tempXpos;
				}
			}
			
			if (usedCY - spacingY > container.height && container.autoSize) {
				container.height = usedCY - spacingY;
			}

			if (usedCX > container.width && container.autoSize) {
				container.width = usedCX;
			}
			
			var halign:String = child.horizontalAlign;
			switch (halign) {
				case HorizontalAlign.CENTER:
					xpos = usedCX - child.width - padding.left - ((colWidths[col] / 2) - (child.width / 2));
				case HorizontalAlign.RIGHT:
					xpos = usedCX - child.width - padding.left;
				default:
			}
			
			child.x = xpos;
			child.y = ypos;
			
			ypos += child.height + spacingY;
		}
		/*
		var xpos:Float = padding.left;
		var ypos:Float = padding.top;
		var usedCX:Float = -1;
		var usedCY:Float = 0;
		var maxCY:Float = usableHeight;
		if (container.autoSize == true && container.parent != null) {
			maxCY = container.parent.layout.usableHeight;
		}

		var colCX:Float = 0;
		for (child in container.children) {
			var halign:String = child.horizontalAlign;
			switch (halign) {
				case HorizontalAlign.CENTER:
					xpos = (container.width / 2) - (child.width / 2);
				case HorizontalAlign.RIGHT:
					xpos = container.width - child.width;
				default:	
			}
			
			usedCY += child.height + spacingY;
			if (child.width + spacingX > colCX) {
				colCX = child.width + spacingX;
				//usedCX += colCX;
			}
			if (usedCX == -1) {
				usedCX = colCX;
			}
			if (usedCY > maxCY) {
				usedCY = child.height + spacingY;
				usedCX += colCX;
				xpos += child.width + spacingX;
				ypos = padding.top;
				colCX = 0;
			}
			if (usedCY - spacingY > innerHeight && container.autoSize) {
				container.height = usedCY + padding.top + padding.bottom - spacingY;
			}
			if (usedCX - spacingX > innerWidth && container.autoSize) {
				container.width = usedCX + padding.left + padding.right - spacingX;
			}
			
			child.x = xpos;
			child.y = ypos;
			
			ypos += child.height + spacingY;
		}
		*/
	}
}