package haxe.ui.popup;

import haxe.ui.controls.Label;
import nme.events.TimerEvent;
import nme.utils.Timer;

class BusyPopup extends Popup {
	private var textControl:Label;
	public var delay:Float = -1;
	
	private var delayTimer:Timer;
	
	public function new() {
		super();
		inheritStylesFrom = "Popup";
		addStyleName("BusyPopup");
		content.addStyleName("BusyPopup.content");
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();

		textControl = new Label();
		textControl.text = text;
		textControl.horizontalAlign = "left";
		content.addChild(textControl);
		
		height = content.padding.top + content.padding.bottom + textControl.height;
		Popup.centerPopup(this);
		
		if (delay > 0) {
			delayTimer = new Timer(delay, 1);
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			delayTimer.start();
		}
	}
	
	private function onDelayComplete(event:TimerEvent):Void {
		delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
		Popup.hidePopup(this);
	}
	
}