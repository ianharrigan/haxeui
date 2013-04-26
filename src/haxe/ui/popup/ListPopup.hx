package haxe.ui.popup;

import haxe.ui.data.DataSource;
import nme.events.Event;
import nme.events.TimerEvent;
import nme.Lib;
import nme.utils.Timer;
import haxe.ui.containers.ListView;

class ListPopup extends Popup {
	public var dataSource:DataSource;
	
	private var list:ListView;
	public var maxSize:Int = 5;
	public var fnCallback:Dynamic->Void;

	private var hideTimer:Timer;
	
	public var selectedIndex:Int = -1;
	
	public function new() {
		super();
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		
		list = new ListView();
		list.dataSource = dataSource;
		list.id = "popupListView";
		list.percentWidth = 100;
		list.percentHeight = 100;
		content.addChild(list);
		
		list.selectedIndex = selectedIndex;
		var n:Int = maxSize;
		if (n > list.listSize) {
			n = list.listSize;
		}
		var listHeight:Float = (n * list.itemHeight) + list.layout.padding.top + list.layout.padding.bottom;
		height = content.layout.padding.top + content.layout.padding.bottom + listHeight;
		
		list.addEventListener(Event.CHANGE, onListChange);
		
		Popup.centerPopup(this);
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onListChange(event:Event):Void {
		hideTimer = new Timer(400, 1);
		hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		hideTimer.start();
	}
	
	private function onTimerComplete(event:TimerEvent):Void {
		hideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		Popup.hidePopup(this);
		if (fnCallback != null) {
			var item:Dynamic = list.getListItem(list.selectedIndex).itemData;
			item.index = list.selectedIndex;
			fnCallback(item);
		}
	}
}