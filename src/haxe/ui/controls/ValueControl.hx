package haxe.ui.controls;

import nme.events.MouseEvent;
import haxe.ui.core.Component;
import haxe.ui.style.StyleManager;

class ValueControl extends Component {
	
	private var valueStyles:Hash<Dynamic>;
	private var values:Array<String>;

	public var value(default, setValue):String = "0";
	public var state(default, setState):String = "normal";

	public var interactive:Bool = true;
	
	public function new() {
		super();
		registerState("over");
		registerState("down");
		
		values = new Array<String>();
		valueStyles = new Hash<Dynamic>();
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();

		for (valueId in values) {
			for (valueState in getRegisteredStateNames()) {
				var temp =  valueId + ":" + valueState;
				var valueStyle:Dynamic = StyleManager.buildStyle(this, temp);
				if (valueStyle != null) {
					valueStyles.set(valueId + ":" + valueState, valueStyle);
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
		var valueStyle:Dynamic = valueStyles.get(value + ":" + state);
		if (valueStyle != null) {
			currentStyle = valueStyle;
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
