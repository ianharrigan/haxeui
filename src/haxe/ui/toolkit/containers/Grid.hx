package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.layout.GridLayout;

/**
 Grid style layout container
 **/
class Grid extends Container implements IClonable<Grid> {
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
	
	//******************************************************************************************
	// Clone
	//******************************************************************************************
	public override function self():Grid return new Grid();
	public override function clone():Grid {
		var c:Grid = cast super.clone();
		c.columns = this.columns;
		return c;
	}
}