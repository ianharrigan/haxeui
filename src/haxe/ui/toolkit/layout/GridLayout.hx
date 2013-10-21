package haxe.ui.toolkit.layout;
import haxe.ui.toolkit.core.base.HorizontalAlign;
import haxe.ui.toolkit.core.base.VerticalAlign;

class GridLayout extends Layout {
	private var _columns:Int = 1;
	
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Getters/settings
	//******************************************************************************************
	public var columns(get, set):Int;
	
	private function get_columns():Int {
		return _columns;
	}
	
	private function set_columns(value:Int):Int {
		_columns = value;
		return value;
	}
	
	//******************************************************************************************
	// ILayout
	//******************************************************************************************
	private override function resizeChildren():Void {
		super.resizeChildren();
		
		var columnWidths:Array<Float> = calcColumnWidths();
		var rowHeights:Array<Float> = calcRowHeights();
		var totalWidth:Float = 0;
		var totalHeight:Float = 0;
		
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		//var autoSize:Bool = _container.autoSize;
		for (child in container.children) {
			
			if (child.percentWidth > -1) {
				var ucx:Float = usableWidth;
				//ucx -= columnWidths[columnIndex] + spacingX;
				child.width = (ucx * child.percentWidth) / 100; 
			}
			
			if (child.percentHeight > -1) {
				var ucy:Float = usableHeight;
				//ucy -= rowHeights[rowIndex] + spacingY;
				child.height = (ucy * child.percentHeight) / 100; 
			}
			
			columnIndex++;
			if (columnIndex >= _columns) {
				columnIndex = 0;
				rowIndex++;
			}
		}
		
		for (cx in columnWidths) {
			totalWidth += cx;
		}
		if (columnWidths.length > 1) {
			totalWidth += spacingX * (columnWidths.length - 1);
		}

		for (cy in rowHeights) {
			totalHeight += cy;
		}
		if (rowHeights.length > 1) {
			totalHeight += spacingY * (rowHeights.length - 1);
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
		
		var columnWidths:Array<Float> = calcColumnWidths();
		var rowHeights:Array<Float> = calcRowHeights();
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		var xpos:Float = padding.left;
		var ypos:Float = padding.top;
		var halign = container.horizontalAlign;
		var valign = container.verticalAlign;
		
		for (child in container.children) {
			
			switch (halign) {
				case HorizontalAlign.CENTER:
					child.x = xpos + (columnWidths[columnIndex] - child.width) * 0.5;
				case HorizontalAlign.RIGHT:
					child.x += xpos + (columnWidths[columnIndex] - child.width);
				default: 
					child.x = xpos;
			}
			switch (valign) {
				case VerticalAlign.CENTER:
					child.y = ypos + (rowHeights[rowIndex] - child.height) * 0.5;
				case VerticalAlign.BOTTOM:
					child.y = ypos + (rowHeights[rowIndex] - child.height);
				default:
					child.y = ypos;
			}

			xpos += columnWidths[columnIndex] + spacingX;
			
			columnIndex++;
			if (columnIndex >= _columns) {
				xpos = padding.left;
				ypos += rowHeights[rowIndex] + spacingY;
				columnIndex = 0;
				rowIndex++;
			}
		}
	}
	
	//******************************************************************************************
	// Helper overrides
	//******************************************************************************************
	private override function get_usableWidth():Float {
		var ucx:Float = super.get_usableWidth();
		
		return ucx;
	}
	
	private override function get_usableHeight():Float {
		var ucy:Float = super.get_usableHeight();
		
		return ucy;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function calcColumnWidths():Array<Float> {
		var columnWidths:Array<Float> = new Array<Float>();
		for (n in 0..._columns) {
			columnWidths.push(0);
		}
		
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		var autoSize:Bool = _container.autoSize;
		var ucx = usableWidth;
		for (child in container.children) {
			if (autoSize && child.percentWidth > -1) {
				continue;
			}
			if (child.percentWidth > 0 && !autoSize)
				columnWidths[columnIndex] = (ucx * child.percentWidth) / 100;
			else if (child.width > columnWidths[columnIndex]) {
				columnWidths[columnIndex] = child.width;
			}

			columnIndex++;
			
			if (columnIndex >= _columns) {
				columnIndex = 0;
				rowIndex++;
			}
		}
		
		return columnWidths;
	}
	
	public function calcRowHeights():Array<Float> {
		var rowCount:Int = Std.int((container.children.length / _columns));
		if (container.children.length % _columns != 0) {
			rowCount++;
		}
		var rowHeights:Array<Float> = new Array<Float>();
		for (n in 0...rowCount) {
			rowHeights.push(0);
		}
		
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		var autoSize:Bool = _container.autoSize;
		var ucy = usableHeight;
		for (child in container.children) {
			if (autoSize && child.percentHeight > -1) {
				continue;
			}
			if (child.percentHeight > 0 && !autoSize)
				rowHeights[rowIndex] = (ucy * child.percentHeight) / 100;
			else if (child.height > rowHeights[rowIndex]) {
				rowHeights[rowIndex] = child.height;
			}
			
			columnIndex++;
			
			if (columnIndex >= _columns) {
				columnIndex = 0;
				rowIndex++;
			}
		}
		
		return rowHeights;
	}
	
}