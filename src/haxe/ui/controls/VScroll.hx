package haxe.ui.controls;

import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TimerEvent;
import nme.geom.Point;
import nme.Lib;
import nme.utils.Timer;
import haxe.ui.core.Component;
import haxe.ui.style.StyleManager;

class VScroll extends Component {
	private var buttonUp:Button;
	private var buttonDown:Button;
	private var thumb:Button;
	
	public var min:Float = 0;
	public var max:Float = 100;
	public var value(default, setValue):Float = 0;
	public var pageSize(default, setPageSize):Float = 0;
	private var thumbMinSize:Float = 20;
	
	private var mouseDownOffset:Float = -1; // the offset from the thumb ypos where the mouse event was detected
	
	public var mouseOver:Bool = false;

	public var incrementSize:Int = 20; // value used when inc/deinc value using buttons
	private var incrementTimer:Timer;
	private var scrollDirection:Int;
	
	public function new() {
		super();
		autoSize = false;
	}

	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		
		if (currentStyle.hasButtons != null && currentStyle.hasButtons == true) {
			buttonUp = new Button();
			buttonUp.width = buttonUp.height = innerWidth;
			buttonUp.id = "buttonUp";
			buttonUp.autoSize = false;
			buttonUp.verticalAlign = "top";
			buttonUp.addEventListener(MouseEvent.MOUSE_DOWN, onUp);
			addChild(buttonUp);
			
			buttonDown = new Button();
			buttonDown.width = buttonDown.height = innerWidth;
			buttonDown.id = "buttonDown";
			buttonDown.autoSize = false;
			buttonDown.verticalAlign = "bottom";
			buttonDown.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addChild(buttonDown);
		}

		thumb = new Button();
		thumb.width = thumb.height = innerWidth;
		thumb.id = "thumb";
		thumb.autoSize = false;
		thumb.toggle = true;
		thumb.allowSelection = false;
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
		addChild(thumb);
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}

	public override function resize():Void {
		super.resize();
		
		if (buttonUp != null) {
			buttonUp.width = buttonUp.height = innerWidth;
		}
		if (buttonDown != null) {
			buttonDown.width = buttonDown.height = innerWidth;
		}
		
		resizeThumb();
		repositionThumb();
	}

	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onThumbMouseDown(event:MouseEvent):Void {
		root.addEventListener(MouseEvent.MOUSE_MOVE, onScreenMouseMove);
		root.addEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);

		var ptStage:Point = new Point(event.stageX, event.stageY);
		mouseDownOffset = ptStage.y - thumb.y;
	}
	
	private function onScreenMouseMove(event:MouseEvent):Void {
		var ypos:Float = event.stageY - mouseDownOffset;
		var minY:Float = 0;
		if (buttonUp != null) {
			minY = buttonUp.height + layout.spacingY;
		}
		var maxY:Float = getUsableHeight() - thumb.height;
		if (buttonUp != null) {
			maxY += buttonUp.height + layout.spacingY;
		}
		if (ypos < minY) {
			ypos = minY;
		} else if (ypos > maxY) {
			ypos = maxY;
		}

		var ucy:Float = getUsableHeight();
		ucy -= thumb.height;
		var m:Int = Std.int(max - min);
		var v:Float = ypos - minY;
		var newValue:Float = min + ((v / ucy) * m);
		value = Std.int(newValue);
	}
	
	private function onScreenMouseUp(event:MouseEvent):Void {
		mouseDownOffset = -1;
		if (incrementTimer != null) {
			incrementTimer.stop();
		}
		root.removeEventListener(MouseEvent.MOUSE_MOVE, onScreenMouseMove);
		root.removeEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);
	}
	
	private function onMouseOver(event:MouseEvent):Void {
		mouseOver = true;
	}
	
	private function onMouseOut(event:MouseEvent):Void {
		mouseOver = false;
	}
	
	private function onMouseDown(event:MouseEvent):Void {
		var performPaging:Bool = !thumb.hitTest(event.stageX, event.stageY);
		if (buttonUp != null && buttonUp.hitTest(event.stageX, event.stageY) == true) {
			performPaging = false;
		}
		if (buttonDown != null && buttonDown.hitTest(event.stageX, event.stageY) == true) {
			performPaging = false;
		}
		if (performPaging == true) {
			if (event.localY > thumb.y) { // page down
				value += pageSize;
			} else { // page up
				value -= pageSize;
			}
		}
	}
	
	private function onUp(event:MouseEvent):Void {
		deincrementValue();
		scrollDirection = 0;
		root.addEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);
		if (incrementTimer == null) {
			incrementTimer = new Timer(50, 1);
			incrementTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		incrementTimer.reset();
		incrementTimer.start();
	}
	
	private function onDown(event:MouseEvent):Void {
		incrementValue();
		scrollDirection = 1;
		root.addEventListener(MouseEvent.MOUSE_UP, onScreenMouseUp);
		if (incrementTimer == null) {
			incrementTimer = new Timer(50, 1);
			incrementTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		incrementTimer.reset();
		incrementTimer.start();
	}
	
	private function onTimerComplete(event:TimerEvent):Void {
		if (incrementTimer != null) {
			if (scrollDirection == 1) {
				incrementValue();
			} else if (scrollDirection == 0) {
				deincrementValue();
			}
			incrementTimer.reset();
			incrementTimer.start();
		}
	}

	//************************************************************
	//                  GETTERS/SETTERS
	//************************************************************
	public function setValue(newValue:Float):Float {
		if (newValue < min) {
			newValue = min;
		}
		if (newValue > max) {
			newValue = max;
		}
		value = newValue;
		repositionThumb();
		var changeEvent:Event = new Event(Event.CHANGE);
		dispatchEvent(changeEvent);
		return newValue;
	}
	
	public function setPageSize(value:Float):Float {
		pageSize = value;
		resizeThumb();
		repositionThumb();
		return value;
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	public function incrementValue():Void {
		value += incrementSize;
	}
	
	public function deincrementValue():Void {
		value -= incrementSize;
	}
	
	private function resizeThumb():Void {
		if (!ready) {
			return;
		}
		
		var m:Int = Std.int(max - min);
		var thumbHeight:Float = (pageSize / m) * getUsableHeight();
		if (thumbHeight < thumbMinSize) {
			thumbHeight = thumbMinSize;
		}
		if (thumbHeight > height) {
			thumbHeight = height;
		}

		thumb.width = innerWidth;
		thumb.height = Std.int(thumbHeight);
	}
	
	private function repositionThumb():Void {
		if (thumb != null) {
			var ucy:Float = getUsableHeight();
			ucy -= thumb.height;
			var m:Int = Std.int(max - min);
			var thumbPos:Float = ((value - min) / m) * ucy;
			if (buttonUp != null) {
				thumbPos += buttonUp.height + layout.spacingY;
			}
			thumb.y = Std.int(thumbPos);
		}
	}
	
	private override function getUsableHeight(c:Component = null):Float {
		var ucy:Float = innerHeight;
		if (buttonUp != null) {
			ucy -= buttonUp.height + layout.spacingY;
		}
		if (buttonDown != null) {
			ucy -= buttonDown.height + layout.spacingY;
		}
		return ucy;
	}
}