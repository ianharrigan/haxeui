package haxe.ui.toolkit.core.renderers;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Slider;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;
import haxe.ui.toolkit.core.interfaces.IItemRenderer;
import haxe.ui.toolkit.events.UIEvent;

class ItemRenderer extends StateComponent implements IItemRenderer implements IClonable<ItemRenderer> {
	public static inline var STATE_NORMAL = "normal";
	public static inline var STATE_OVER = "over";
	public static inline var STATE_SELECTED = "selected";
	public static inline var STATE_DISABLED = "disabled";
	
	public var hash(default, default):String;
	public var eventDispatcher(default, default):IEventDispatcher;
	
	public function new() {
		super();
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		state = STATE_NORMAL;
	}
	
	public override function initialize():Void {
		super.initialize();
		
		addStatesRecursively(this);
	}
	
	private function addStatesRecursively(c:IDisplayObjectContainer):Void {
		if (Std.is(c, StateComponent) && c != this) {
			cast(c, StateComponent).addStates(this.states);
		}
		
		for (child in c.children) {
			if (isInteractive(c)) {			
				continue;
			}
			
			if (Std.is(c, IDisplayObjectContainer)) {
				addStatesRecursively(cast(child, IDisplayObjectContainer));
			}
		}
	}
	
	private var _data:Dynamic;
	public var data(get, set):Dynamic;
	private function get_data():Dynamic {
		return _data;
	}
	private function set_data(value:Dynamic):Dynamic {
		_data = value;
		updateComponents();
		attachEvents(this);
		return value;
	}
	
	public function update():Void {
		updateComponents();
	}
	
	public function allowSelection(stageX:Float, stageY:Float):Bool {
		var allow:Bool = true;
		var c:IDisplayObject = findComponentUnderPoint(stageX, stageY);
		while (c != null) {
			if (isInteractive(c)) {
				allow = false;
				break;
			}
			
			if (Std.is(c, DisplayObjectContainer) == false) {
				break;
			}
			c = cast(c, DisplayObjectContainer).findComponentUnderPoint(stageX, stageY);
		}
		return allow;
	}
	
	private function attachEvents(c:IDisplayObjectContainer):Void {
		for (child in c.children) {
			if (isInteractive(child)) {
				attachEvent(child);
			} else {
				if (Std.is(child, IDisplayObjectContainer)) {
					attachEvents(cast(child, IDisplayObjectContainer));
				}
			}
		}
	}
	
	private function attachEvent(c:IDisplayObject):Void {
		if (Std.is(c, Slider)) {
			c.removeEventListener(UIEvent.CHANGE, _onComponentEvent);
			c.addEventListener(UIEvent.CHANGE, _onComponentEvent);
		} else if (Std.is(c, Button)) {
			c.removeEventListener(UIEvent.CLICK, _onComponentEvent);
			c.addEventListener(UIEvent.CLICK, _onComponentEvent);
		}
	}
	
	private function _onComponentEvent(event:UIEvent):Void {
		if (event.component != null && event.component.id != null && event.component.id.length > 0) {
			Reflect.setField(_data, event.component.id, event.component.value);
		}
		
		dispatchProxyEvent(UIEvent.COMPONENT_EVENT, event);
	}
	
	public function dispatchProxyEvent(type:String, refEvent:UIEvent):Void {
		if (eventDispatcher != null) {
			var c = null;
			if (refEvent != null && refEvent.component != null) {
				c = refEvent.component;
			}
			var uiEvent:UIEvent = new UIEvent(type, c);
			uiEvent.data = _data;
			uiEvent.data.update = this.update;
			eventDispatcher.dispatchEvent(uiEvent);
		}
	}
	
 	private function updateComponents():Void {
		var fields:Array<String> = Reflect.fields(_data);
		for (f in fields) {
			var componentId:String = f;
			var value:Dynamic = Reflect.field(_data, f);
			var c = findChild(componentId, null, true);
			if (c != null) {
				updateComponentValue(c, value);
			}
		}
	}
	
	private function updateComponentValue(c:IDisplayObject, value:Dynamic):Void {
		if (Std.is(c, Component)) {
			cast(c, Component).value = value;
		}
	}
	
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	private override function get_states():Array<String> {
		return [STATE_NORMAL, STATE_OVER, STATE_SELECTED, STATE_DISABLED];
	}
	
	private override function set_state(value:String):String {
		setStateRecursively(value, this);
		return super.set_state(value);
	}
	
	private function setStateRecursively(value:String, c:IDisplayObjectContainer):Void {
		if (Std.is(c, StateComponent) && c != this) {
			cast(c, StateComponent).state = value;
		}
		
		for (child in c.children) {
			if (isInteractive(c)) {
				continue;
			}
			
			if (Std.is(c, IDisplayObjectContainer)) {
				setStateRecursively(value, cast(child, IDisplayObjectContainer));
			}
		}
	}
	
	private function isInteractive(c:IDisplayObject):Bool {
		if (Std.is(c, Button) || Std.is(c, Slider)) {
			return true;
		}
		return false;
	}
	
	//******************************************************************************************
	// Clone
	//******************************************************************************************
	public override function clone():ItemRenderer {
		for (child in this.children) {
			c.addChild(child.clone());
		}
	}
}


