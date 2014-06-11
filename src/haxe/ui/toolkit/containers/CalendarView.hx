package haxe.ui.toolkit.containers;

import openfl.events.Event;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Calendar;
import haxe.ui.toolkit.controls.Spacer;
import haxe.ui.toolkit.controls.Text;

class CalendarView extends VBox {
	private static var MONTH_NAMES:Array<String> = ["January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	
	private var _calendar:Calendar;
	
	private var _prevMonthButton:Button;
	private var _nextMonthButton:Button;
	private var _currentMonthYear:Text;
	
	public function new() {
		super();
		_calendar = new Calendar();
		_autoSize = false;
		_calendar.percentWidth = 100;
		_calendar.percentHeight = 100;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		var hbox:HBox = new HBox();
		hbox.percentWidth = 100;
		_prevMonthButton = new Button();
		_prevMonthButton.text = "<";
		_prevMonthButton.addEventListener(MouseEvent.CLICK, _onPrevClicked);
		hbox.addChild(_prevMonthButton);
		

		var spacer:Spacer = new Spacer();
		spacer.percentWidth = 50;
		//hbox.addChild(spacer);
		
		_currentMonthYear = new Text();
		_currentMonthYear.text = "December 2013";
		_currentMonthYear.id = "currentMonthYear";
		_currentMonthYear.percentWidth = 100;
		_currentMonthYear.autoSize = false;
		hbox.addChild(_currentMonthYear);
		
		var spacer:Spacer = new Spacer();
		spacer.percentWidth = 50;
		//hbox.addChild(spacer);
		
		/*
		var spacer:Spacer = new Spacer();
		spacer.percentWidth = 100;
		hbox.addChild(spacer);
		*/
		
		_nextMonthButton = new Button();
		_nextMonthButton.text = ">";
		_nextMonthButton.addEventListener(MouseEvent.CLICK, _onNextClicked);
		hbox.addChild(_nextMonthButton);
		
		addChild(hbox);
		
		_calendar.addEventListener(Event.CHANGE, _onDateChanged);
		addChild(_calendar);
		displayMonthYear();
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	public var date(get, set):Date;
	public var selectedDate(get, set):Date;
	
	private function get_date():Date {
		return _calendar.date;
	}
	
	private function set_date(value:Date):Date {
		_calendar.date = value;
		return value;
	}
	
	private function get_selectedDate():Date {
		return _calendar.selectedDate;
	}
	
	private function set_selectedDate(value:Date):Date {
		_calendar.selectedDate = value;
		return value;
	}
	
	//******************************************************************************************
	// Event handlers
	//*****************************************************************************************
	private function _onPrevClicked(event:MouseEvent):Void {
		_calendar.previousMonth();
		displayMonthYear();
	}
	
	private function _onNextClicked(event:MouseEvent):Void {
		_calendar.nextMonth();
		displayMonthYear();
	}

	private function _onDateChanged(event:Event):Void {
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	//******************************************************************************************
	// Helpers
	//*****************************************************************************************
	private function displayMonthYear():Void {
		var monthName:String = MONTH_NAMES[_calendar.date.getMonth()];
		_currentMonthYear.text = monthName + " " + _calendar.date.getFullYear();
	}
}