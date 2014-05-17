package haxe.ui.toolkit.controls;

/**
 Inspired from: https://github.com/minimalcomps/minimalcomps/blob/master/src/com/bit101/components/Calendar.as
 **/

import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.layout.Layout;

class Calendar extends Component {
	private var _dayItems:Array<CalendarDay>; 
	private var _date:Date;
	private var _year:Int;
	private var _month:Int;
	private var _day:Int;
	private var _selectedDate:Date;
	
	public function new() {
		super();
		_layout = new CalendarLayout();
		_autoSize = false;
		_dayItems = new Array<CalendarDay>();
		_selectedDate = Date.now();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		
		for (i in 0...6) {
			for (j in 0...7) {
				var dayItem:CalendarDay = new CalendarDay();
				dayItem.addEventListener(MouseEvent.CLICK, buildMouseClickFunction(_dayItems.length));
				_dayItems.push(dayItem);
				addChild(dayItem);
			}
		}
		date = Date.now();
	}

	//******************************************************************************************
	// Methods
	//******************************************************************************************
	public function previousMonth():Void {
		_month--;
		if (_month < 0) {
			_month = 11;
			_year--;
		}
		_day = cast(Math.min(_day, getEndDay(_month, _year)), Int);
		date = new Date(_year, _month, _day, 0, 0, 0);
	}
	
	public function nextMonth():Void {
		_month++;
		if (_month > 11) {
			_month = 0;
			_year++;
		}
		_day = cast(Math.min(_day, getEndDay(_month, _year)), Int);
		date = new Date(_year, _month, _day, 0, 0, 0);
	}
	
	//******************************************************************************************
	// Properties
	//******************************************************************************************
	public var date(get, set):Date;
	public var selectedDate(get, set):Date;
	
	private function get_date():Date {
		return _date;
	}
	
	private function set_date(value:Date):Date {
		_date = value;
		_year = _date.getFullYear();
		_month = _date.getMonth();
		_day = _date.getDate();
		
		var startDay:Int = new Date(_year, _month, 1, 0, 0, 0).getDay();
		var endDay:Int = getEndDay(_month, _year);
		
		for (item in _dayItems) {
			item.visible = false;
			item.id = null;
		}
		
		for (i in 0...endDay) {
			var item:CalendarDay = _dayItems[i + startDay];
			item.visible = true;
			item.text = "" + (i + 1);
			if (i + 1 == _selectedDate.getDate() && _month == _selectedDate.getMonth() && _year == _selectedDate.getFullYear()) {
				item.id = "selectedDay";
			}
		}

		return value;
	}
	
	private function get_selectedDate():Date {
		return _selectedDate;
	}
	
	private function set_selectedDate(value:Date):Date {
		_selectedDate = value;
		date = _date;
		return value;
	}
	
	//******************************************************************************************
	// Helpers
	//*****************************************************************************************
	private function getEndDay(month:Int, year:Int):Int {
		var endDay:Int = -1;
		switch (month) {
			case 1: // feb
				if ((year % 400 == 0) ||  ((year % 100 != 0) && (year % 4 == 0))) {
					endDay = 29;
				} else {
					endDay = 28;
				}
			case 3, 5, 8, 10: // april, june, sept, nov.
				endDay = 30;
			default:
				endDay = 31;
		}
		return endDay;
	}
	
	private function buildMouseClickFunction(index:Int) {
		return function(event:MouseEvent) { mouseClickButton(index); };
	}
	
	private function mouseClickButton(index:Int):Void {
		var item:CalendarDay = _dayItems[index];
		var day:Int = Std.parseInt(item.text);
		selectedDate = new Date(_year, _month, day, 0, 0, 0);
		dispatchEvent(new Event(Event.CHANGE));
	}
}

@exclude
class CalendarDay extends Button {
	public function new() {
		super();
		autoSize = false;
	}
}

@exclude
class CalendarLayout extends Layout {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// ILayout
	//******************************************************************************************
	private override function resizeChildren():Void {
		super.resizeChildren();
		var children:Array<IDisplayObject> = container.children;
		var ucx:Float = usableWidth - (6 * spacingX) + (padding.left + padding.right);
		var ucy:Float = usableHeight - (5 * spacingY) + (padding.top + padding.bottom);
		var bcx:Float = ucx / 7;
		var bcy:Float = ucy / 6;
		
		var xpos:Float = 0;
		var ypos:Float = 0;
		var n:Int = 0;
		for (i in 0...6) {
			for (j in 0...7) {
				var child:IDisplayObject = children[n];
				if (child != null) {
					child.x = xpos;
					child.y = ypos;
					child.width = bcx;
					child.height = bcy;
					n++;
					
					xpos += bcx + spacingX;
				}
			}
			xpos = 0;
			ypos += bcy + spacingY;
		}
	}
}