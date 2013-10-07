package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.GridLayout;

/**
 Grid style layout container
 **/
class Grid extends Component {
	public function new() {
		super();
		
		autoSize = true;
		layout = new GridLayout();
	}
	
	//******************************************************************************************
	// Getters/settings
	//******************************************************************************************
	/**
	 Number of columns for the grid
	 **/
	public var columns(get, set):Int;
	
	private function get_columns():Int {
		return cast(_layout, GridLayout).columns;
	}
	
	private function set_columns(value:Int):Int {
		cast(_layout, GridLayout).columns = value;
		return value;
	}
}