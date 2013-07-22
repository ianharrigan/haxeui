package haxe.ui.toolkit.controls;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IScrollable;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.layout.DefaultLayout;
import haxe.ui.toolkit.util.TypeParser;

class HScroll extends Scroll implements IScrollable {
	private var _pos:Float = 0;
	private var _min:Float = 0;
	private var _max:Float = 100;
	private var _pageSize:Float = 0;
	private var _incrementSize:Float = 20;
	
	private var _deincButton:Button;
	private var _incButton:Button;
	private var _thumb:Button;
	
	private var _mouseDownOffset:Float = -1; // the offset from the thumb xpos where the mouse event was detected

	private var _scrollDirection:Int = 0;
	private var _scrollTimer:Timer;

	private var _hasButtons:Bool = true;
	
	public function new() {
		super();
		_layout = new HScrollLayout();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		
		if (_style != null) {
			if (_style.hasButtons != null) {
				_hasButtons = _style.hasButtons;
			}
		}
	}
	
	private override function initialize():Void {
		super.initialize();

		if (_hasButtons == true) {
			_deincButton = new Button();
			_deincButton.width = layout.innerHeight;
			_deincButton.percentHeight = 100;
			_deincButton.id = "deinc";
			_deincButton.addEventListener(MouseEvent.MOUSE_DOWN, _onDeinc);
			addChild(_deincButton);

			_incButton = new Button();
			_incButton.width = layout.innerHeight;
			_incButton.percentHeight = 100;
			_incButton.id = "inc";
			_incButton.addEventListener(MouseEvent.MOUSE_DOWN, _onInc);
			addChild(_incButton);
		}
		
		_thumb = new Button();
		_thumb.width = 50;
		_thumb.percentHeight = 100;
		_thumb.id = "thumb";
		_thumb.remainPressed = true;
		_thumb.addEventListener(MouseEvent.MOUSE_DOWN, _onThumbMouseDown);
		addChild(_thumb);
		
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
	}
	
	//******************************************************************************************
	// Evend handlers
	//******************************************************************************************
	private function _onThumbMouseDown(event:MouseEvent):Void {
		var ptStage:Point = new Point(event.stageX, event.stageY);
		_mouseDownOffset = ptStage.x - _thumb.x;

		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}
	
	private function _onScreenMouseMove(event:MouseEvent):Void {
		var xpos:Float = event.stageX - _mouseDownOffset;
		var minX:Float = 0;
		if (_deincButton != null) {
			minX = _deincButton.width + layout.spacingX;
		}
		var maxX:Float = layout.usableWidth - _thumb.width;
		if (_deincButton != null) {
			maxX += _deincButton.width + layout.spacingX;
		}
		if (xpos < minX) {
			xpos = minX;
		} else if (xpos > maxX) {
			xpos = maxX;
		}
		
		var ucx:Float = layout.usableWidth;
		ucx -= _thumb.width;
		var m:Int = Std.int(max - min);
		var v:Float = xpos - minX;
		var newValue:Float = min + ((v / ucx) * m);
		pos = Std.int(newValue);
	}
	
	private function _onScreenMouseUp(event:MouseEvent):Void {
		_mouseDownOffset = -1;
		if (_scrollTimer != null) {
			_scrollTimer.stop();
		}
		Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		Screen.instance.removeEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}
	
	private function _onDeinc(event:MouseEvent):Void {
		deincrementValue();
		_scrollDirection = 0;
		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		if (_scrollTimer == null) {
			_scrollTimer = new Timer(50, 1);
			_scrollTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onScrollTimerComplete);
		}
		_scrollTimer.reset();
		_scrollTimer.start();
	}
	
	private function _onInc(event:MouseEvent):Void {
		incrementValue();
		_scrollDirection = 1;
		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		if (_scrollTimer == null) {
			_scrollTimer = new Timer(50, 1);
			_scrollTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onScrollTimerComplete);
		}
		_scrollTimer.reset();
		_scrollTimer.start();
	}
	
	private function _onScrollTimerComplete(event:TimerEvent):Void {
		if (_scrollTimer != null) {
			if (_scrollDirection == 1) {
				incrementValue();
			} else if (_scrollDirection == 0) {
				deincrementValue();
			}
			_scrollTimer.reset();
			_scrollTimer.start();
		}
	}
	
	private function _onMouseDown(event:MouseEvent):Void {
		var performPaging:Bool = !_thumb.hitTest(event.stageX, event.stageY);
		if (_deincButton != null && _deincButton.hitTest(event.stageX, event.stageY) == true) {
			performPaging = false;
		}
		if (_incButton != null && _incButton.hitTest(event.stageX, event.stageY) == true) {
			performPaging = false;
		}
		if (performPaging == true) {
			if (event.localX > _thumb.x) { // page down
				pos += pageSize;
			} else { // page up
				pos -= pageSize;
			}
		}
	}
	
	//******************************************************************************************
	// IScrollable
	//******************************************************************************************
	public var pos(get, set):Float;
	public var min(get, set):Float;
	public var max(get, set):Float;
	public var pageSize(get, set):Float;
	public var incrementSize(get, set):Float;
	
	private function get_pos():Float {
		return _pos;
	}
	
	private function set_pos(value:Float):Float {
		if (value < _min) {
			value = _min;
		}
		if (value > _max) {
			value = _max;
		}
		if (value != _pos) {
			_pos = value;
			var changeEvent:Event = new Event(Event.CHANGE);
			dispatchEvent(changeEvent);
			invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}

	private function get_min():Float {
		return _min;
	}
	
	private function set_min(value:Float):Float {
		if (value != _min) {
			_min = value;
			if (_pos < _min) {
				_pos = _min;
			}
			invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}
	
	private function get_max():Float {
		return _max;
	}
	
	private function set_max(value:Float):Float {
		if (value != _max) {
			_max = value;
			if (_pos > _max) {
				_pos = _max;
			}
			invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}
	
	private function get_pageSize():Float {
		return _pageSize;
	}
	
	private function set_pageSize(value:Float):Float {
		if (value != _pageSize) {
			_pageSize = value;
			invalidate(InvalidationFlag.LAYOUT);
		}
		return value;
	}

	private function get_incrementSize():Float {
		return _incrementSize;
	}
	
	private function set_incrementSize(value:Float):Float {
		_incrementSize = value;
		return value;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public function deincrementValue():Void {
		pos -= _incrementSize;
	}
	
	public function incrementValue():Void {
		pos += _incrementSize;
	}
}

private class HScrollLayout extends DefaultLayout {
	public function new() {
		super();
	}
	
	public override function resizeChildren():Void {
		super.resizeChildren();
		
		var scroll:IScrollable = cast(container, IScrollable);
		var thumb:IDisplayObject =  container.findChild("thumb");
		if (thumb != null) {
			var m:Float = scroll.max - scroll.min;
			var ucx:Float = usableWidth;
			var thumbWidth = (scroll.pageSize / m) * ucx;
			if (thumbWidth < 20) {
				thumbWidth = 20;
			} else if (thumbWidth > ucx) {
				thumbWidth = ucx;
			}
			thumb.width = thumbWidth;
		}
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		var deinc:IDisplayObject =  container.findChild("deinc");
		var inc:IDisplayObject =  container.findChild("inc");
		if (inc != null) {
			inc.x = container.width - inc.width - padding.right;
		}

		var scroll:IScrollable = cast(container, IScrollable);
		var thumb:IDisplayObject =  container.findChild("thumb");
		if (thumb != null) {
			var m:Float = scroll.max - scroll.min;
			var u:Float = usableWidth;
			u -= thumb.width;
			//var x:Float = u / (m / scroll.pos);
			var x:Float = ((scroll.pos - scroll.min) / m) * u;
			x += padding.left;
			if (deinc != null) {
				x += deinc.width + spacingX;
				
			}
			thumb.x = x;
		}
	}
	
	// usable height returns the amount of available space for % size components 
	private override function get_usableWidth():Float {
		var ucx:Float = innerWidth;
		var deinc:IDisplayObject =  container.findChild("deinc");
		var inc:IDisplayObject =  container.findChild("inc");
		if (deinc != null) {
			ucx -= deinc.width + spacingX;
		}
		if (inc != null) {
			ucx -= inc.width + spacingX;
		}
		return ucx;
	}
}