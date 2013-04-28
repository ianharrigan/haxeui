package haxe.ui.containers;

import haxe.ui.core.Component;
import haxe.ui.layout.GridLayout;

class GridBox extends Component {
	public var columns:Int = 1;
	
	public function new() {
		super();
		layout = new GridLayout();
	}
	
	public override function initialize():Void {
		super.initialize();
		cast(layout, GridLayout).columns = columns;
	}
	
	private override function getUsableWidth(c:Component = null):Float {
		var ucx:Float = super.getUsableWidth();
		var gridLayout:GridLayout = cast(layout, GridLayout);
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		for (child in listChildComponents()) {
			if (child == c) {
				break;
			}
			columnIndex++;
			
			if (columnIndex >= gridLayout.columns) {
				columnIndex = 0;
				rowIndex++;
			}
		}

		var columnWidths:Array<Int> = gridLayout.calcColumnWidths();
		var n:Int = 0;
		for (cx in columnWidths) {
			if (n != columnIndex) {
				ucx -= cx + gridLayout.spacingX;
			}
			n++;
		}
		
		return ucx;
	}

	private override function getUsableHeight(c:Component = null):Float {
		var ucy:Float = super.getUsableHeight();
		var gridLayout:GridLayout = cast(layout, GridLayout);
		var rowIndex:Int = 0;
		var columnIndex:Int = 0;
		for (child in listChildComponents()) {
			if (child == c) {
				break;
			}
			columnIndex++;
			
			if (columnIndex >= gridLayout.columns) {
				columnIndex = 0;
				rowIndex++;
			}
		}
		
		var rowHeights:Array<Int> = gridLayout.calcRowHeights();
		var n:Int = 0;
		for (cy in rowHeights) {
			if (n != rowIndex) {
				ucy -= cy + gridLayout.spacingY;
			}
			n++;
		}
		
		return ucy;
	}
}