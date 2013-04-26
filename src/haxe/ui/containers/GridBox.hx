package haxe.ui.containers;

import haxe.ui.core.Component;
import haxe.ui.layout.GridLayout;

class GridBox extends Component {
	public function new() {
		super();
		layout = new GridLayout();
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

		for (child in listChildComponents()) {
			
		}
		
		ucx = ucx - (80 + 5 + 5 + 100);
		/*
		if (ucx < gridLayout.calcColumnWidths()[columnIndex]) {
			ucx = gridLayout.calcColumnWidths()[columnIndex];
		}
		*/
		
		return ucx;//gridLayout.calcColumnWidths()[columnIndex];
	}

	private override function getUsableHeight(c:Component = null):Float {
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
		
		return gridLayout.calcRowHeights()[rowIndex];
	}
}