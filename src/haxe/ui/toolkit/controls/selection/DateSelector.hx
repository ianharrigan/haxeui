package haxe.ui.toolkit.controls.selection;

import haxe.ui.toolkit.core.Screen;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.DropShadowFilter;
import haxe.ui.toolkit.containers.CalendarView;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Toolkit;
import motion.Actuate;
import motion.easing.Linear;

class DateSelector extends Button {
	private var _cal:CalendarView;
	
	private var _method:String;
	
	public function new() {
		super();
		text = "Select Date";
		toggle = true;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		
		if (_baseStyle != null) {
			if (_baseStyle.selectionMethod != null) {
				_method = _baseStyle.selectionMethod;
			}
		}
	}
	
	private override function initialize():Void {
		super.initialize();
		autoSize = false;
	}
	
	private override function _onMouseClick(event:MouseEvent):Void {
		super._onMouseClick(event);
		if (_cal == null || _cal.visible == false) {
			showCalendar();
		} else {
			hideCalendar();
		}
	}
	
	public override function applyStyle():Void {
		super.applyStyle();
		
		if (_baseStyle != null) {
			if (_baseStyle.selectionMethod != null && _method == null) {
				_method = _baseStyle.selectionMethod;
			}
		}
	}
	
	//******************************************************************************************
	// Instance methods
	//******************************************************************************************
	public function showCalendar():Void {
		if (_method == "popup") {
			PopupManager.instance.showCalendar("Select Date", function(button:Dynamic, date:std.Date) {
				this.selected = false;
				if (button == PopupButton.CONFIRM) {
					var dateString:String = DateTools.format(date, dateFormat);
					this.text = dateString;
				}
			});
		} else {
			if (_cal == null) {
				_cal = new CalendarView();
				_cal.addEventListener(Event.CHANGE, onDateChange);
				_cal.addEventListener(Event.ADDED_TO_STAGE, function(e) {
					showCalendar();
				});
				root.addChild(_cal);
				return;
			}
			
			root.addEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
			root.addEventListener(MouseEvent.MOUSE_WHEEL, _onRootMouseDown);

			_cal.x = this.stageX - root.stageX;
			_cal.y = this.stageY + this.height - root.stageY;
			_cal.sprite.filters = [ new DropShadowFilter (4, 45, 0x808080, 1, 4, 4, 1, 3) ];
			if (_cal.stageY + _cal.height > Screen.instance.height) {
				_cal.y = this.stageY - _cal.height;
				this.styleName = "dropUp";
			} else {
				this.styleName = null;
			}
			
			var transition:String = Toolkit.getTransitionForClass(DateSelector);
			if (transition == "slide") {
				_cal.clipHeight = 0;
				_cal.sprite.alpha = 1;
				_cal.visible = true;
				Actuate.tween(_cal, .1, { clipHeight: _cal.height }, true).ease(Linear.easeNone).onComplete(function() {
					_cal.clearClip();
				});
			} else if (transition == "fade") {
				_cal.sprite.alpha = 0;
				_cal.visible = true;
				Actuate.tween(_cal.sprite, .2, { alpha: 1 }, true).ease(Linear.easeNone).onComplete(function() {
				});
			} else {
				_cal.sprite.alpha = 1;
				_cal.visible = true;
			}
			
			this.selected = true;
		}
	}
	
	public function hideCalendar():Void {
		if (_cal != null) {
			var transition:String = Toolkit.getTransitionForClass(DateSelector);
			if (transition == "slide") {
				_cal.sprite.alpha = 1;
				Actuate.tween(_cal, .1, { clipHeight: 0 }, true).ease(Linear.easeNone).onComplete(function() {
					_cal.visible = false;
					_cal.clearClip();
				});
			} else if (transition == "fade") {
				Actuate.tween(_cal.sprite, .2, { alpha: 0 }, true).ease(Linear.easeNone).onComplete(function() {
					_cal.visible = false;
				});
			} else {
				_cal.sprite.alpha = 1;
				_cal.visible = false;
			}
			
			this.selected = false;
		}
	}

	//******************************************************************************************
	// Propreties
	//******************************************************************************************
	/**
	 Specifies the method to display the calendar, valid values are:
		 
	 * `default` - The calendar will be displayed under the button, similar to a standard drop down box

	 * `popup` - The calendar will be a modal popup of the choices, this is more suited to mobile applications
	 **/
	public var method(get, set):String;
	
	private function get_method():String {
		return _method;
	}
	
	private function set_method(value:String):String {
		_method = value;
		return value;
	}
	
	/**
	 * Returns the selected date
	 **/
	public var date(get, never):std.Date;

	private function get_date():std.Date {
		if (_cal != null) {
			return _cal.selectedDate;
		}
		return std.Date.now();
	}

	/**
	 * Sets the displayed date format (default: %d/%m/%Y)
	 **/
	public var dateFormat(default, set):String = "%d/%m/%Y";

	private function set_dateFormat(value:String):String {
		dateFormat = value;
		if (_cal != null) {
			this.text = DateTools.format(_cal.selectedDate, dateFormat);
		}
		return value;
	}

	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onRootMouseDown(event:MouseEvent):Void {
		var mouseInList:Bool = false;
		if (_cal != null) {
			mouseInList = _cal.hitTest(event.stageX, event.stageY);
		}

		var mouseIn:Bool = hitTest(event.stageX, event.stageY);
		if (mouseInList == false && _cal != null && mouseIn == false) {
			root.removeEventListener(MouseEvent.MOUSE_DOWN, _onRootMouseDown);
			root.removeEventListener(MouseEvent.MOUSE_WHEEL, _onRootMouseDown);
			hideCalendar();
		}
	}
	
	private function onDateChange(event:Event):Void {
		var dateString:String = DateTools.format(_cal.selectedDate, dateFormat);
		this.text = dateString;
		hideCalendar();
	}
}