package haxe.ui.toolkit.layout;

import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;

class HorizontalContinuousLayout extends Layout {
	public function new() {
		super();
	}
	
	private override function repositionChildren():Void {
		super.repositionChildren();
		
		var xpos:Float = padding.left;
		var ypos:Float = padding.top;
		var usedCX:Float = padding.left + padding.right;
		var usedCY:Float = padding.top + padding.bottom;
		var rowCY:Float = 0;
		var rowHeights:Array<Float> = new Array<Float>();
		var rowChildren:Array<IDisplayObject> = new Array<IDisplayObject>();
		rowHeights.push(0);
		var row:Int = 0;
		var maxCX:Float = container.width;
		if (container.autoSize == true && container.parent != null) {
			maxCX = container.parent.layout.usableWidth;
		}
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			rowChildren.push(child);
			
			if (child.percentWidth > -1) {
				child.width = ((maxCX - spacingX) * child.percentWidth) / 100; 
			}
			
			usedCX += child.width + spacingX;
			if (usedCX - spacingX > maxCX) {
				xpos = padding.left;
				rowHeights.push(0);
				ypos += rowHeights[row] + spacingY;
				row++;
				usedCX = padding.left + padding.right + child.width + spacingX;
				
				rowChildren = new Array<IDisplayObject>();
				rowChildren.push(child);
			}
			
			var reposition:Bool = false;
			if (child.height > rowHeights[row]) {
				rowHeights[row] = child.height;
				reposition = true;
			}
			
			usedCY = padding.top + padding.bottom;
			for (cy in rowHeights) {
				usedCY += cy + spacingY;
			}
			usedCY -= spacingY;

			if (reposition) {
				for (temp in rowChildren) {
					var valign:String = temp.verticalAlign;
					var tempYpos:Float = temp.y;
					switch (valign) {
						case VerticalAlign.CENTER:
							tempYpos = usedCY - temp.height - padding.top - ((rowHeights[row] / 2) - (temp.height / 2));
						case VerticalAlign.BOTTOM:
							tempYpos = usedCY - temp.height - padding.top;
						default:
					}
					temp.y = tempYpos;
				}
			}
			
			if (usedCX - spacingX > container.width && container.autoSize) {
				container.width = usedCX - spacingX;
			}

			if (usedCY > container.height && container.autoSize) {
				container.height = usedCY;
			}
			
			var valign:String = child.verticalAlign;
			var tempYPos:Float = ypos;
			switch (valign) {
				case VerticalAlign.CENTER:
					tempYPos = usedCY - child.height - padding.top - ((rowHeights[row] / 2) - (child.height / 2));
				case VerticalAlign.BOTTOM:
					tempYPos = usedCY - child.height - padding.top;
				default:
			}
			
			child.x = xpos;
			child.y = tempYPos;
			
			xpos += child.width + spacingX;
		}
	}
}