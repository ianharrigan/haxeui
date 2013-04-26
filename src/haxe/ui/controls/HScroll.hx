package haxe.ui.controls;

import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TimerEvent;
import nme.geom.Point;
import nme.Lib;
import nme.utils.Timer;
import haxe.ui.core.Component;
import haxe.ui.style.StyleManager;

class HScroll extends Component {
	private var buttonLeft:Button;
	private var buttonRight:Button;
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
			buttonLeft = new Button();
			buttonLeft.width = buttonLeft.height = innerHeight;
			buttonLeft.id = "buttonLeft";
			buttonLeft.autoSize = false;
			buttonLeft.horizontalAlign = "left";
			buttonLeft.addEventListener(MouseEvent.MOUSE_DOWN, onLeft);
			addChild(buttonLeft);

			buttonRight = new Button();
			buttonRight.width = buttonRight.height = innerHeight;
			buttonRight.id = "buttonRight";
			buttonRight.autoSize = false;
			buttonRight.horizontalAlign = "right";
			buttonRight.addEventListener(MouseEvent.MOUSE_DOWN, onRight);
			addChild(buttonRight);
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

		if (buttonLeft != null) {
			buttonLeft.width = buttonLeft.height = innerHeight;
		}
		if (buttonRight != null) {
			buttonRight.width = buttonRight.height = innerHeight;
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
		mouseDownOffset = ptStage.x - thumb.x;
	}
	
	private function onScreenMouseMove(event:MouseEvent):Void {
		var xpos:Float = event.stageX - mouseDownOffset;
		var minX:Float = 0;
		if (buttonLeft != null) {
			minX = buttonLeft.height + layout.spacingX;
		}
		var maxX:Float = getUsableWidth() - thumb.width;
		if (buttonLeft != null) {
			maxX += buttonLeft.height + layout.spacingX;
		}
		if (xpos < minX) {
			xpos = minX;
		} else if (xpos > maxX) {
			xpos = maxX;
		}

		var ucx:Float = getUsableWidth();
		ucx -= thumb.width;
		var m:Int = Std.int(max - min);
		var v:Float = xpos - minX;
		var newValue:Float = min + ((v / ucx) * m);
		value = Std.int(newValue);
	}
	
	private function onScreenMouseUp(event:MouseEvent) {
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
		if (buttonLeft != null && buttonLeft.hitTest(event.stageX, event.stageY) == true) {
			performPaging = false;
		}
		if (buttonRight != null && buttonRight.hitTest(event.stageX, event.stageY) == true) {
			performPaging = false;
		}
		if (performPaging == true) {
			if (event.localX > thumb.x) { // page down
				value += pageSize;
			} else { // page up
				value -= pageSize;
			}
		}
	}
	
	private function onLeft(event:MouseEvent):Void {
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

	private function onRight(event:MouseEvent):Void {
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
	private function incrementValue():Void {
		value += incrementSize;
	}
	
	private function deincrementValue():Void {
		value -= incrementSize;
	}
	
	private function resizeThumb():Void {
		if (!ready) {
			return;
		}
		
		var m:Int = Std.int(max - min);
		var thumbWidth:Float = (pageSize / m) * getUsableWidth();
		if (thumbWidth < thumbMinSize) {
			thumbWidth = thumbMinSize;
		}
		if (thumbWidth > width) {
			thumbWidth = width;
		}
		
		thumb.width = Std.int(thumbWidth);
		thumb.height = innerHeight;
	}
	
	private function repositionThumb():Void {
		if (thumb != null) {
			var ucx:Float = getUsableWidth();
			ucx -= thumb.width;
			var m:Int = Std.int(max - min);
			var thumbPos:Float = ((value - min) / m) * ucx;
			if (buttonLeft != null) {
				thumbPos += buttonLeft.width + layout.spacingX;
			}
			thumb.x = Std.int(thumbPos);
		}
	}
	
	private override function getUsableWidth(c:Component = null):Float {
		var ucx:Float = innerWidth;
		if (buttonLeft != null) {
			ucx -= buttonLeft.width + layout.spacingX;
		}
		if (buttonRight != null) {
			ucx -= buttonLeft.width + layout.spacingX;
		}

		return ucx;
	}
}