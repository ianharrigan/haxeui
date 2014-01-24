package haxe.ui.toolkit.core;

import flash.events.Event;
import flash.events.IEventDispatcher;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.util.StringUtil;

 class EventDispatcher implements IEventDispatcher {
	public function new() {
		
	}
	
	private function handleEvent(event:UIEvent):Void {
		var fnName:String = "on" + StringUtil.capitalizeFirstLetter(StringTools.replace(event.type, UIEvent.PREFIX, ""));
		var fn:UIEvent->Void = Reflect.field(this, fnName);
		if (fn != null) {
			var fnEvent:UIEvent = new UIEvent(UIEvent.PREFIX + event.type); 
			fnEvent.displayObject = this;
			fn(fnEvent);
		}
	}

	public var onClick(default, set):UIEvent->Void;
	private function set_onClick(value:UIEvent->Void):UIEvent->Void {
		onClick = value;
		addEventListener(UIEvent.CLICK, handleEvent);
		return value;
	}
	
	//******************************************************************************************
	// IEventDispatcher
	//******************************************************************************************
	public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	
	public function dispatchEvent(event:Event):Bool;

	public function hasEventListener(type:String):Bool;
	
	public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
	
	public function willTrigger(type:String):Bool;
}