package haxe.ui.controls;

import haxe.ui.core.Component;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;

class HSlider extends Component {
	private var valueComponent:ProgressBar;
	private var sliderButton:Button;
	
	private var min:Float = 0;
	private var max:Float = 100;
	public var value(default, setValue):Float = 50;

	private var mouseDownOffset:Float = -1; // the offset from the thumb ypos where the mouse event was detected
	
	public function new() {
		super();
		
		valueComponent = new ProgressBar();
		valueComponent.id = "hsliderValue";
		valueComponent.percentWidth = 100;
		valueComponent.verticalAlign = "center";
		
		sliderButton = new Button();
		sliderButton.id = "hsliderButton";
		sliderButton.verticalAlign = "center";
		sliderButton.autoSize = false;
		sliderButton.toggle = true;
		sliderButton.allowSelection = false;
		sliderButton.addEventListener(MouseEvent.MOUSE_DOWN, onSliderButtonDown);
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
	
		addChild(valueComponent);
		//sliderButton.sprite.alpha = .5;
		addChild(sliderButton);
	}
	
	public override function resize():Void {
		super.resize();
		
		repositionButton();
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onSliderButtonDown(event:MouseEvent):Void {
		root.addEventListener(MouseEvent.MOUSE_MOVE, onScreenMouseMove);
		root.addEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);

		var ptStage:Point = new Point(event.stageX, event.stageY);
		mouseDownOffset = ptStage.x - sliderButton.x - sliderButton.width / 2;
	}
	
	private function onScreenMouseMove(event:MouseEvent):Void {
		var xpos:Float = event.stageX - mouseDownOffset;
		var minX:Float = 0;
		var maxX:Float = innerWidth + sliderButton.width;
		if (xpos < minX) {
			xpos = minX;
		} else if (xpos > maxX) {
			xpos = maxX;
		}

		var m:Int = Std.int(max - min);
		var v:Float = xpos - minX;
		var newValue:Float = min + ((v / innerWidth) * m);
		value = Std.int(newValue);
	}
	
	private function onScreenMouseUp(event:MouseEvent) {
		mouseDownOffset = -1;
		root.removeEventListener(MouseEvent.MOUSE_MOVE, onScreenMouseMove);
		root.removeEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);
	}
	
	private function onMouseDown(event:MouseEvent):Void {
		if (!sliderButton.hitTest(event.stageX, event.stageY)) {
			onScreenMouseMove(event);
		}
	}
	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setValue(value:Float):Float {
		if (value < min) {
			value = min;
		}
		if (value > max) {
			value = max;
		}
		this.value = value;
		valueComponent.value = value;
		repositionButton();
		var changeEvent:Event = new Event(Event.CHANGE);
		dispatchEvent(changeEvent);
		return value;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private function repositionButton():Void {
		if (ready == false) {
			return;
		}
		
		var m:Float = (max - min);
		var pos:Float = ((value - min) / m) * innerWidth;
		pos -= sliderButton.width / 2;
		sliderButton.x = pos;
	}
}