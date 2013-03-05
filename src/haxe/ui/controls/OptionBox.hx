package haxe.ui.controls;

import nme.events.MouseEvent;
import haxe.ui.core.Component;

class OptionBox extends Component {
	private var valueControl:ValueControl;
	private var textControl:Label;
	
	public var selected(getSelected, setSelected):Bool;
	
	private static var groups:Hash<Array<OptionBox>>;
	public var group(default, setGroup):String;
	
	public function new() {
		super();
		registerState("over");
		registerState("down");
		addStyleName("OptionBox");
		
		valueControl = new ValueControl();
		valueControl.inheritStylesFrom = "OptionBox.value";
		valueControl.verticalAlign = "center";
		valueControl.value = "unselected";
		valueControl.interactive = false;
		
		textControl = new Label();
		textControl.verticalAlign = "center";
		
		if (groups == null) {
			groups = new Hash<Array<OptionBox>>();
		}
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();

		valueControl.addValue("unselected");
		valueControl.addValue("selected");
		valueControl.addStyleName("OptionBox.value");
		if (id != null) {
			valueControl.id = id + ".value";
		}
		
		sprite.useHandCursor = true;
		sprite.buttonMode = true;
		
		textControl.text = text;
		
		addChild(valueControl);
		addChild(textControl);
		
		width = valueControl.width + textControl.width + padding.left + padding.right;
		var cy:Float = Math.max(valueControl.height, textControl.height);
		height = cy + padding.top + padding.bottom;
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.CLICK, onMouseClick);
	}
	
	public override function resize():Void {
		super.resize();
		
		textControl.x = valueControl.width;// spacingX;
	}

	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onMouseOver(event:MouseEvent):Void {
		valueControl.state = "over";
		showStateStyle(valueControl.state);
		textControl.currentStyle = currentStyle;
		textControl.applyStyle();
	}
	
	private function onMouseOut(event:MouseEvent):Void {
		valueControl.state = "normal";
		showStateStyle(valueControl.state);
		textControl.currentStyle = currentStyle;
		textControl.applyStyle();
	}

	private function onMouseClick(event:MouseEvent):Void {
		selected = !selected;	
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function getSelected():Bool {
		return (valueControl.value == "selected");
	}
	
	public function setSelected(value:Bool):Bool {
		valueControl.value = (value == true) ? "selected" : "unselected";
		if (group != null && value == true) { // set all the others in group
			var arr:Array<OptionBox> = groups.get(group);
			if (arr != null) {
				for (option in arr) {
					if (option != this) {
						option.selected = false;
					}
				}
			}
		}
		return value;
	}
	
	public function getValue():String {
		return valueControl.value;
	}
	
	public function setValue(value:String):String {
		valueControl.value = value;
		return value;
	}
	
	public function setGroup(value:String):String { 
		if (value != null) { // TODO: remove from groups
			var arr:Array<OptionBox> = groups.get(value);
			if (arr != null) {
				arr.remove(this);
			}
		}
		
		group = value;
		var arr:Array<OptionBox> = groups.get(value);
		if (arr == null) {
			arr = new Array<OptionBox>();
		}
		
		if (optionInGroup(value, this) == false) {
			arr.push(this);
		}
		groups.set(value, arr);
		
		return value;
	}
	
	private static function optionInGroup(value:String, option:OptionBox):Bool {
		var exists:Bool = false;
		var arr:Array<OptionBox> = groups.get(value);
		if (arr != null) {
			for (test in arr) {
				if (test == option) {
					exists = true;
					break;
				}
			}
		}
		return exists;
	}
}