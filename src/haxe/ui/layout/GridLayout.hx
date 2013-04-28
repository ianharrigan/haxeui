package haxe.ui.layout;

import haxe.ui.core.Component;

class GridLayout extends Layout {
	public var columns:Int = 1;
	
	public function new() {
		super();
	}

	public function calcColumnWidths():Array<Int> {
		var columnWidths:Array<Int> = new Array<Int>();
		for (n in 0...columns) {
			columnWidths.push(0);
		}
		
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		for (child in c.listChildComponents()) {
			if (child.width > columnWidths[columnIndex]) {
				columnWidths[columnIndex] = Std.int(child.width);
			}

			columnIndex++;
			
			if (columnIndex >= columns) {
				columnIndex = 0;
				rowIndex++;
			}
		}
		
		return columnWidths;
	}
	
	public function calcRowHeights():Array<Int> {
		var rowCount:Int = Std.int((c.listChildComponents().length / columns));
		if (c.listChildComponents().length % columns != 0) {
			rowCount++;
		}
		var rowHeights:Array<Int> = new Array<Int>();
		for (n in 0...rowCount) {
			rowHeights.push(0);
		}
		
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		
		for (child in c.listChildComponents()) {
			if (child.height > rowHeights[rowIndex]) {
				rowHeights[rowIndex] = Std.int(child.height);
			}
			
			columnIndex++;
			
			if (columnIndex >= columns) {
				columnIndex = 0;
				rowIndex++;
			}
		}
		
		return rowHeights;
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		var columnWidths:Array<Int> = calcColumnWidths();
		var rowHeights:Array<Int> = calcRowHeights();
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		var xpos:Int = 0;
		var ypos:Int = 0;
		for (child in c.listChildComponents()) {
			child.x = xpos;
			child.y = ypos;

			xpos += columnWidths[columnIndex] + spacingX;
			
			columnIndex++;
			if (columnIndex >= columns) {
				xpos = 0;
				ypos += rowHeights[rowIndex] + spacingY;
				columnIndex = 0;
				rowIndex++;
			}
		}
	}

	public override function calcWidth():Float {
		var maxWidth:Float = padding.left + padding.right;
		var columnWidths:Array<Int> = calcColumnWidths();
		for (cx in columnWidths) {
			maxWidth += cx + spacingX;
		}
		maxWidth -= spacingX;
		return maxWidth;
	}
	
	public override function calcHeight():Float {
		var maxHeight:Float = padding.top + padding.bottom;
		var rowHeights:Array<Int> = calcRowHeights();
		for (cy in rowHeights) {
			maxHeight += cy + spacingY;
		}
		maxHeight -= spacingY;
		return maxHeight;
	}
}