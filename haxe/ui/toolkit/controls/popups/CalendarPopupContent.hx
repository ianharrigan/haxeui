package haxe.ui.toolkit.controls.popups;

import haxe.ui.toolkit.containers.CalendarView;

class CalendarPopupContent extends PopupContent {
	private var _cal:CalendarView;
	
	public function new() {
		super();
		
		_cal = new CalendarView();
		_cal.percentWidth = 100;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		addChild(_cal);
		height = _cal.height;
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	public var selectedDate(get, set):Date;
	
	private function get_selectedDate():Date {
		return _cal.selectedDate;
	}
	
	private function set_selectedDate(value:Date):Date {
		_cal.selectedDate = value;
		return value;
	}
}