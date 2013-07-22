package haxe.ui.toolkit.controls.popups;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.data.IDataSource;

class ListPopupContent extends PopupContent {
	private var _list:ListView;

	private var _maxListSize:Int = 4;
	
	private var hideTimer:Timer;
	private var _fn:Dynamic->Void;
	
	public function new(dataSource:IDataSource, selectedIndex:Int = -1, fn:Dynamic->Void) {
		super();
		
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

		_list.addEventListener(Event.CHANGE, _onListChange);
		
		addChild(_list);
		var n:Int = _maxListSize;
		if (n > _list.listSize) {
			n = _list.listSize;
		}
		
		var listHeight:Float = n * _list.itemHeight + (_list.layout.padding.top + _list.layout.padding.bottom);
		_list.height = listHeight;
		height = listHeight;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onListChange(event:Event):Void {
		hideTimer = new Timer(400, 1);
		hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		hideTimer.start();
	}

	private function onTimerComplete(event:TimerEvent):Void {
		hideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		if (Std.is(parent, Popup)) {
			PopupManager.instance.hidePopup(cast(parent, Popup));
		}
		
		if (_fn != null) {
			var item:ListViewItem = _list.selectedItems[0];
			var index:Int = Lambda.indexOf(_list.selectedItems, item);
			var param:Dynamic = {
				text: item.text,
				index: index,
			};
			_fn(item);
		}
	}

}