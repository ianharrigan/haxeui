package haxe.ui.controls;

import nme.events.MouseEvent;
import haxe.ui.core.Component;
import haxe.ui.style.StyleManager;

class ValueControl extends Component {
	
	private var valueStyles:Hash<Hash<Dynamic>>;
	private var values:Array<String>;

	public var value(default, setValue):String = "0";
	public var state(default, setState):String = "normal";

	public var interactive:Bool = true;
	
	public function new() {
		super();
		registerState("over");
		registerState("down");
		addStyleName("ValueControl");
		
		values = new Array<String>();
		valueStyles = new Hash<Hash<Dynamic>>();
		
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();

		var styleArr:Array<String> = styleString.split(" ");
		var addStyle:Bool = false;
		for (s in styleArr) {
			if (s == "ValueControl") {
				addStyle = true;
			}
			
			if (addStyle == false) {
				continue;
			}
			
			for (valueId in values) {
				var valueStyleString:String = s + "." + valueId;
				if (id != null) {
					valueStyleString += " #" + id + "." + valueId;
				}
				var valueStyle:Dynamic = StyleManager.styleFromString(valueStyleString, inheritStylesFrom);
				valueStyle = StyleManager.mergeStyle(currentStyle, valueStyle);
				
				var states:Hash<Dynamic> = valueStyles.get(valueId);
				if (states == null) {
					states = new Hash<Dynamic>();
				}
				states.set("normal", StyleManager.mergeStyle(valueStyle, states.get("normal")));
				valueStyles.set(valueId, states);
				
				for (stateName in registeredStateNames) {
					var valueStyleString:String = s + "." + valueId + ":" + stateName;
					if (id != null) {
						valueStyleString += " #" + id + "." + valueId + ":" + stateName;
					}
					var valueStateStyle:Dynamic = StyleManager.styleFromString(valueStyleString, inheritStylesFrom);
					valueStateStyle = StyleManager.mergeStyle(valueStyle, valueStateStyle);
					states.set(stateName, StyleManager.mergeStyle(valueStateStyle, states.get(stateName)));
				}
			}
		}

		showValueStyle(value, state);
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.CLICK, onClick);
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onMouseOver(event:MouseEvent):Void {
		state = "over";
	}
	
	private function onMouseOut(event:MouseEvent):Void {
		state = "normal";
	}

	private function onMouseDown(event:MouseEvent):Void {
		state = "down";
	}

	private function onMouseUp(event:MouseEvent):Void {
		state = "over";
	}
	
	private function onClick(event:MouseEvent):Void {
		if (interactive == true) {
			cycleValue();
		}
	}

	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setValue(newValue:String):String {
		if (value != newValue) {
			value = newValue;
			if (ready) {
				showValueStyle(newValue, state);
			}
		}
		return value;
	}
	
	public function setState(newState:String):String {
		if (state != newState) {
			state = newState;
			showValueStyle(this.value, newState);
		}
		return newState;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	public function addValue(valueId:String):Void {
		values.push(valueId);
	}
	
	private function cycleValue():Void {
		var n:Int = 0;
		for (tempValue in values) {
			if (value == tempValue) {
				break;
			}
			n++;
		}
		n = n + 1;
		if (n > values.length - 1) {
			n = 0;
		}
		value = values[n];
	}
	
	private function showValueStyle(value:String, state:String = "normal"):Void {
		var states:Hash<Dynamic> = valueStyles.get(value);
		if (states != null) {
			var valueStyle:Dynamic = states.get(state);
			if (valueStyle != null) {
				currentStyle = valueStyle;
			} else { // if you dont have the state show the normal state 
				currentStyle = states.get("normal");
			}
			applyStyle();
		}
	}
	
	private function valueExists(value:String):Bool {
		for (x in values) {
			if (value == x) {
				return true;
			}
		}
		return false;
	}
}
