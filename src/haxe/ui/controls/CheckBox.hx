package haxe.ui.controls;

import nme.events.MouseEvent;
import haxe.ui.core.Component;
import haxe.ui.style.StyleManager;

class CheckBox extends Component {
	private var valueControl:ValueControl;
	private var textControl:Label;
	
	public var selected(getSelected, setSelected):Bool;
	public var value(getValue, setValue):String = "unselected";
	
	public function new() {
		super();
		registerState("over");
		registerState("down");
		addStyleName("CheckBox");
		
		valueControl = new ValueControl();
		valueControl.inheritStylesFrom = "CheckBox.value";
		valueControl.verticalAlign = "center";
		valueControl.value = "unselected";
	
		textControl = new Label();
		textControl.verticalAlign = "center";
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();

		valueControl.addValue("unselected");
		valueControl.addValue("selected");
		valueControl.addStyleName("CheckBox.value");
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
		if (valueControl.hitTest(event.stageX, event.stageY) == false) {
			selected = !selected;	
		}
	}
	
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function getSelected():Bool {
		return (valueControl.value == "selected");
	}
	
	public function setSelected(value:Bool):Bool {
		valueControl.value = (value == true) ? "selected" : "unselected";
		return value;
	}
	
	public function getValue():String {
		return valueControl.value;
	}
	
	public function setValue(value:String):String {
		valueControl.value = value;
		return value;
	}
}