package haxe.ui.containers;

import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TimerEvent;
import nme.geom.Point;
import nme.Lib;
import nme.utils.Timer;
import haxe.ui.controls.HScroll;
import haxe.ui.controls.VScroll;
import haxe.ui.core.Component;

class ScrollView extends Component {
	private var viewContent:Component;
	private var viewContentContainer:Component;
	
	private var scrollPos:Point;
	
	private var eventTarget:Sprite; // we want to use an event target as when controls, say, buttons are scroll we want them to lose mouse events while scrolling
	private var downPos:Point; // where the mouse down was detected (used for delta values)
	private var mouseDown:Bool = false;
	
	private var vscroll:VScroll;
	private var hscroll:HScroll;
	
	public var showHorizontalScroll:Bool = true;
	public var showVerticalScroll:Bool = true;
	
	private var autoHideScrolls:Bool = false;
	
	public var scrollSensitivity:Int = 0; // there are times when you dont want things to scroll instantly
	private var innerScrolls:Bool = false;
	
	public var vscrollPosition(getVScrollPosition, setVScrollPosition):Float;
	public var hscrollPosition(getHScrollPosition, setHScrollPosition):Float;
	public var vscrollMax(getVScrollMax, null):Float;
	public var hscrollMax(getHScrollMax, null):Float;
	
	// kinetic scrolling, adapted from: http://www.nbilyk.com/kinetic-scrolling-example
	private var kineticPreviousPoints:Array<Point>;
	private var kineticPreviousTimes:Array<Int>;
	private var kineticVelocity:Point;
	private static var KINETIC_HISTORY_LENGTH:Int = 5; // The amount of mouse move events to keep track of
	private var kineticScrolling:Bool = true;
	
	public function new() {
		super();
		
		viewContent = new Component();
		viewContentContainer = new Component();
		viewContentContainer.percentWidth = 100;
		scrollPos = new Point(0, 0);
		eventTarget = new Sprite();
		eventTarget.visible = false;
		autoSize = false;
		autoHideScrolls = false;
		innerScrolls = false;
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function initialize():Void {
		super.initialize();
		
		if (currentStyle != null && currentStyle.autoHideScrolls != null) {
			autoHideScrolls = currentStyle.autoHideScrolls;
		}
		if (currentStyle != null && currentStyle.innerScrolls != null) {
			innerScrolls = currentStyle.innerScrolls;
		}

		viewContentContainer.addChild(viewContent);
		super.addChild(viewContentContainer);
		super.addChild(eventTarget);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}
	
	public override function resize():Void {
		super.resize();

		repositionScrolls();
		updateScrollRect();
		resizeEventTarget();
		super.bringToFront(eventTarget);
	}

	public override function dispose():Void {
		if (vscroll != null) {
			super.removeChild(vscroll);
			vscroll.dispose();
		}
		if (hscroll != null) {
			super.removeChild(hscroll);
			hscroll.dispose();
		}
		if (viewContentContainer != null) {
			super.removeChild(viewContentContainer);
			viewContentContainer.dispose();
		}
		super.removeChild(eventTarget);
		super.dispose();
	}

	//************************************************************
	//                  DISPLAY LIST OVERRIDES
	//************************************************************
	public override function addChild(c:Dynamic):Dynamic {
		return viewContent.addChild(c);
	}

	public override function removeChild(c:Dynamic):DisplayObject {
		return viewContent.removeChild(c);
	}
	
	/*
	public override function listChildComponents():Array<Component> {
		return viewContent.listChildComponents();
	}
	*/

	//************************************************************
	//                  GETTERS / SETTERS
	//************************************************************
	public function getVScrollPosition():Float {
		if (vscroll == null) {
			return 0;
		}
		return vscroll.value;
	}
	
	public function setVScrollPosition(value:Float):Float {
		if (vscroll != null) {
			vscroll.value = value;
		}
		return value;
	}

	public function getHScrollPosition():Float {
		if (hscroll == null) {
			return 0;
		}
		return hscroll.value;
	}
	
	public function setHScrollPosition(value:Float):Float {
		if (hscroll != null) {
			hscroll.value = value;
		}
		return value;
	}
	
	public function getVScrollMax():Float {
		if (vscroll == null) {
			return -1;
		}
		return vscroll.max;
	}
	
	public function getHScrollMax():Float {
		if (hscroll == null) {
			return -1;
		}
		return hscroll.max;
	}
	
	//************************************************************
	//                  EVENT HANDLERS
	//************************************************************
	private function onMouseDown(event:MouseEvent):Void {
		var inScroll:Bool = false;
		if (vscroll != null) {
			inScroll = vscroll.mouseOver;
		}
		if (hscroll != null && inScroll == false) {
			inScroll = hscroll.mouseOver;
		}
		
		if (inScroll == false && (viewContent.height > innerHeight || viewContent.width > innerWidth)) {
			if (kineticScrolling) {
				stopKineticScroll();
				kineticPreviousPoints = [new Point(event.stageX, event.stageY)];
				kineticPreviousTimes = [Lib.getTimer()];
			}
			
			downPos = new Point(event.stageX, event.stageY);
			mouseDown = true;
			root.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			root.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
	}
	
	private function onMouseMove(event:MouseEvent):Void {
		if (kineticScrolling) {
			var currPoint:Point = new Point(event.stageX, event.stageY);
			var currTime:Int = Lib.getTimer();
			var previousPoint:Point = cast(kineticPreviousPoints[kineticPreviousPoints.length - 1], Point);
			var previousTime:Int = cast(kineticPreviousTimes[kineticPreviousTimes.length - 1], Int);
			var diff:Point = currPoint.subtract(previousPoint);		
			
			// Keep track of a set amount of positions and times so that on release, we can always look back a consistant amount.
			kineticPreviousPoints.push(currPoint);
			kineticPreviousTimes.push(currTime);
			if (kineticPreviousPoints.length >= KINETIC_HISTORY_LENGTH) {
				kineticPreviousPoints.shift();
				kineticPreviousTimes.shift();
			}
		}
		
		var inScroll:Bool = false;
		if (vscroll != null) {
			inScroll = vscroll.mouseOver;
		}
		if (hscroll != null && inScroll == false) {
			inScroll = hscroll.mouseOver;
		}
		//inScroll = false;
		if (mouseDown == true && inScroll == false) {
			var ypos:Float = event.stageY - downPos.y;
			var xpos:Float = event.stageX - downPos.x;
			if (Math.abs(xpos) >= scrollSensitivity  || Math.abs(ypos) >= scrollSensitivity) {
				eventTarget.visible = true;
				super.bringToFront(eventTarget);

				if (ypos != 0 && viewContent.height > innerHeight) {
					scrollPos.y -= ypos;
					
					if (vscroll != null) {
						vscroll.visible = true;
					}
				}

				if (xpos != 0 && viewContent.width > innerWidth) {
					scrollPos.x -= xpos;
					
					if (hscroll != null) {
						hscroll.visible = true;
					}
				}
				
				validateScrollPos();
				if (vscroll != null) {
					vscroll.value = Std.int(scrollPos.y);
				}
				if (hscroll != null) {
					hscroll.value = Std.int(scrollPos.x);
				}
				downPos = new Point(event.stageX, event.stageY);
				updateScrollRect();
			}
		}
	}
	
	private function validateScrollPos():Void {
		if (scrollPos.y < 0) {
			scrollPos.y = 0;
		}
		var maxY:Float = viewContent.height - innerHeight;
		if (hscroll != null) {
			maxY += hscroll.height + layout.spacingY;
		}
		if (scrollPos.y > maxY) {
			scrollPos.y = maxY;
		}
		
		if (scrollPos.x < 0) {
			scrollPos.x = 0;
		}
		var maxX:Float = viewContent.width - innerWidth;
		if (vscroll != null) {
			maxX += vscroll.width + layout.spacingX;
		}
		if (scrollPos.x > maxX) {
			scrollPos.x = maxX;
		}
	}
	
	private function onEnterFrame(event:Event):Void {
			kineticVelocity = new Point(kineticVelocity.x * .75, kineticVelocity.y * .75);
			if (Math.abs(kineticVelocity.x) < .1) {
				kineticVelocity.x = 0;
			}
			if (Math.abs(kineticVelocity.y) < .1) {
				kineticVelocity.y = 0;
			}

			if (hscroll != null) {
				hscroll.visible = true;
			}
 					
			if (vscroll != null) {
				vscroll.visible = true;
			}
			
			if (kineticVelocity.x == 0 && kineticVelocity.y == 0) {
				stopKineticScroll();
			}

			scrollPos.y -= kineticVelocity.y * 2.5;
			scrollPos.x -= kineticVelocity.x * 2.5;
			validateScrollPos();
		
			if (vscroll != null) {
				vscroll.value = Std.int(scrollPos.y);
			}
			if (hscroll != null) {
				hscroll.value = Std.int(scrollPos.x);
			}
			
			updateScrollRect();
	}
	
	private function onMouseUp(event:MouseEvent):Void {
		if (kineticScrolling) {
			var currPoint:Point = new Point(event.stageX, event.stageY);
			var currTime:Int = Lib.getTimer();
			var firstPoint:Point = cast(kineticPreviousPoints[0], Point);
			var firstTime:Int = cast(kineticPreviousTimes[0], Int);
			var diff:Point = currPoint.subtract(firstPoint);
			var time:Float = (currTime - firstTime) / (1000 / 24);
			kineticVelocity = new Point(diff.x / time, diff.y / time);		
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		eventTarget.visible = false;
		mouseDown = false;
		root.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		root.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		if (autoHideScrolls == true && kineticScrolling == false) {
			if (vscroll != null) {
				vscroll.visible = false;
			}
			if (hscroll != null) {
				hscroll.visible = false;
			}
		}
	}
	
	private function onVScrollChange(event:Event):Void {
		scrollPos.y = vscroll.value;
		updateScrollRect();
		dispatchEvent(new Event(Event.SCROLL));
	}
	
	private function onHScrollChange(event:Event):Void {
		scrollPos.x = hscroll.value;
		updateScrollRect();
		dispatchEvent(new Event(Event.SCROLL));
	}
	
	private function onMouseWheel(event:MouseEvent):Void {
		if (vscroll != null) {
			if (event.delta != 0) {
				if (event.delta < 0) {
					vscroll.incrementValue();
				} else if (event.delta > 0) {
					vscroll.deincrementValue();
				}
				
				if (autoHideScrolls == true) {
					vscroll.visible = true;
					hideScrollsWithDelay();
				}
			}
		}
	}
	
	private function onTimerComplete(event:TimerEvent):Void {
		hideScrollsTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		if (vscroll != null && autoHideScrolls == true) {
			vscroll.visible = false;
		}
		if (hscroll != null && autoHideScrolls == true) {
			hscroll.visible = false;
		}
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	private var hideScrollsTimer:Timer;
	public function hideScrollsWithDelay():Void {
		if (hideScrollsTimer == null) {
			hideScrollsTimer = new Timer(100, 1);
		}
		hideScrollsTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		hideScrollsTimer.reset();
		hideScrollsTimer.start();
	}
	
	private function repositionScrolls():Void {
		resizeViewContent();
		if (viewContent.height > innerHeight && showVerticalScroll == true) {
			if (vscroll == null) {
				vscroll = new VScroll();
				vscroll.addEventListener(Event.CHANGE, onVScrollChange);
				super.addChild(vscroll);
			}
			
			if (innerScrolls == false && viewContentContainer.layout.padding.right != vscroll.width + layout.spacingX) {
				viewContentContainer.layout.padding.right = vscroll.width + layout.spacingX;
				viewContentContainer.invalidate();
			}
			vscroll.height = innerHeight;
			vscroll.x = innerWidth - vscroll.width;
			vscroll.visible = !autoHideScrolls;
		} else {
			if (vscroll != null) {
				vscroll.visible = false;
			}
			
			if (viewContentContainer.layout.padding.right != 0) {
				viewContentContainer.layout.padding.right = 0;
				viewContentContainer.invalidate();
			}
		}

		if (viewContent.width > innerWidth && showHorizontalScroll == true) {
			if (hscroll == null) {
				hscroll = new HScroll();
				hscroll.addEventListener(Event.CHANGE, onHScrollChange);
				super.addChild(hscroll);
			}
			
			if (innerScrolls == false && viewContentContainer.layout.padding.bottom != hscroll.height + layout.spacingY) {
				viewContentContainer.layout.padding.bottom = hscroll.height + layout.spacingY;
				viewContentContainer.invalidate();
			}
			
			hscroll.width = innerWidth;
			hscroll.y = innerHeight - hscroll.height;
			hscroll.visible = !autoHideScrolls;
		} else {
			if (hscroll != null) {
				hscroll.visible = false;
			}
			
			if (viewContentContainer.layout.padding.bottom != 0) {
				viewContentContainer.layout.padding.bottom = 0;
				viewContentContainer.invalidate();
			}
		}
		
		if (vscroll != null && hscroll != null) {
			vscroll.height -= hscroll.height;
			hscroll.width -= vscroll.width;
		}
		
		// set scroll ranges after we have displayed/created scrolls so we know accurate max values
		if (vscroll != null) {
			var maxY:Float = viewContent.height - innerHeight;
			if (hscroll != null) {
				maxY += hscroll.height + layout.spacingY;
			}
			vscroll.max = maxY;
			vscroll.pageSize = (innerHeight / viewContent.height) * vscroll.max;
		}
		
		if (hscroll != null) {
			var maxX:Float = viewContent.width - innerWidth;
			if (vscroll != null) {
				maxX += vscroll.width + layout.spacingX;
			}
			hscroll.max = maxX;
			hscroll.pageSize = (innerWidth / viewContent.width) * hscroll.max;
		}
	}
	
	private function resizeEventTarget():Void {
		if (eventTarget != null) {
			var targetX:Float = layout.padding.left;
			var targetY:Float = layout.padding.top;
			var targetCX:Float = width - (layout.padding.left + layout.padding.right);
			var targetCY:Float = height - (layout.padding.top + layout.padding.bottom);
			if (vscroll != null) {
				targetCX -= vscroll.width;
			}
			if (hscroll != null) {
				targetCY -= hscroll.height;
			}
			
			eventTarget.alpha = 0;
			eventTarget.graphics.clear();
			eventTarget.graphics.beginFill(0xFF00FF);
			eventTarget.graphics.lineStyle(0);
			eventTarget.graphics.drawRect(targetX, targetY, targetCX, targetCY);
			eventTarget.graphics.endFill();
		}
	}
	
	private function resizeViewContent():Void {
		if (viewContent != null) {
			if (viewContent.percentWidth >= 0) {
				viewContent.width = Std.int((viewContentContainer.width * viewContent.percentWidth) / 100) - viewContentContainer.layout.padding.right;
			}
			if (viewContent.percentHeight >= 0) {
				viewContent.height = Std.int((viewContentContainer.height * viewContent.percentHeight) / 100) - viewContentContainer.layout.padding.bottom;
			}
		}
	}
	
	private function updateScrollRect():Void {
		resizeViewContent();
		if (viewContent != null) {
			var scrollWidth = width - (layout.padding.left + layout.padding.right);
			var scrollHeight = height - (layout.padding.top + layout.padding.bottom);
			if (vscroll != null && vscroll.visible == true && innerScrolls == false) {
				scrollWidth -= vscroll.width + layout.spacingX;
			}
			
			if (hscroll != null && hscroll.visible == true && innerScrolls == false) {
				scrollHeight -= hscroll.height + layout.spacingY;
			}
			viewContentContainer.setScrollRect(0, 0, scrollWidth, scrollHeight);
			var ypos:Int = 0;
			ypos = -Std.int(scrollPos.y);//-Std.int(vscroll.value);
			var xpos:Int = 0;
			xpos = -Std.int(scrollPos.x);//Std.int(hscroll.value);
			viewContent.y = ypos;
			viewContent.x = xpos;
		}
	}
	
	private function stopKineticScroll():Void {
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		kineticVelocity = new Point();
		if (autoHideScrolls == true) {
			if (vscroll != null) {
				vscroll.visible = false;
			}
			if (hscroll != null) {
				hscroll.visible = false;
			}
		}
	}
}