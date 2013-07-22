package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.GridLayout;

class Grid extends Component {
	public function new() {
		super();
		
		autoSize = true;
		layout = new GridLayout();
	}
	
	//******************************************************************************************
	// Getters/settings
	//******************************************************************************************
	public var columns(get, set):Int;
	
	private function get_columns():Int {
		return cast(_layout, GridLayout).columns;
	}
	
	private function set_columns(value:Int):Int {
		cast(_layout, GridLayout).columns = value;
		return value;
	}
}