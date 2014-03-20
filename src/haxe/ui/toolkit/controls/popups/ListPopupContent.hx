package haxe.ui.toolkit.controls.popups;

import flash.events.TimerEvent;
import flash.utils.Timer;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.core.interfaces.IItemRenderer;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.data.IDataSource;
import haxe.ui.toolkit.events.UIEvent;

/**
 List content for list popups
 **/
class ListPopupContent extends PopupContent {
	private var _list:ListView;

	private var _maxListSize:Int = 4;
	
	private var hideTimer:Timer;
	private var _fn:Dynamic->Void;
	private var _selectedIndex:Int = -1;
	
	public function new(dataSource:IDataSource = null, selectedIndex:Int = -1, fn:Dynamic->Void = null) {
		super();
		
		_selectedIndex = selectedIndex;
		_fn = fn;
				
		_list = new ListView();
		_list.percentWidth = 100;
		_list.dataSource = dataSource;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		_list.addEventListener(UIEvent.CHANGE, _onListChange);
		
		addChild(_list);
		var n:Int = _maxListSize;
		if (n > _list.listSize) {
			n = _list.listSize;
		}
		
		var listHeight:Float = n * _list.itemHeight + (_list.layout.padding.top + _list.layout.padding.bottom);
		_list.height = listHeight;
		height = listHeight;
		_list.setSelectedIndexNoEvent(_selectedIndex);
	}
	
	//******************************************************************************************
	// Getters / Setters
	//******************************************************************************************
	public var selectedIndex(get, set):Int;
	public var listSize(get, null):Int;
	
	private function get_selectedIndex():Int {
		var index:Int = _selectedIndex;
		if (_list.ready) {
			index = _list.selectedIndex;
		}
		return index;
	}
	
	private function set_selectedIndex(value:Int):Int {
		_selectedIndex = value;
		if (_list.ready) {
			_list.selectedIndex = value;
		}
		return value;
	}
	
	private function get_listSize():Int {
		if (_list.ready == false) {
			return -1;
		}
		return _list.listSize;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	#if mobile
	private var DELAY:Int = 400;
	#else
	private var DELAY:Int = 0;
	#end
	private function _onListChange(event:UIEvent):Void {
		hideTimer = new Timer(DELAY, 1);
		hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
		hideTimer.start();
	}

	private function _onTimerComplete(event:TimerEvent):Void {
		hideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
		if (Std.is(parent, Popup)) {
			PopupManager.instance.hidePopup(cast(parent, Popup));
		}

		if (_fn != null) {
			var item:IItemRenderer = _list.selectedItems[0];
			var index:Int = _list.getItemIndex(item);
			item.data.index = index;
			_fn(item);
		}
	}

	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public function setSelectedIndexNoEvent(index:Int):Void {
		_selectedIndex = index;
		if (_list.ready) {
			_list.setSelectedIndexNoEvent(index);
		}
	}
}