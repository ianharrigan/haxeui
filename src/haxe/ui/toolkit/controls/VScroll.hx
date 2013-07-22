package haxe.ui.toolkit.controls;

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

class VScroll extends Scroll implements IScrollable {
	private var _pos:Float = 0;
	private var _min:Float = 0;
	private var _max:Float = 100;
	private var _pageSize:Float = 50;
	private var _incrementSize:Float = 20;
	
	private var _deincButton:Button;
	private var _incButton:Button;
	private var _thumb:Button;
	
	private var _mouseDownOffset:Float = -1; // the offset from the thumb ypos where the mouse event was detected
	
	private var _scrollDirection:Int = 0;
	private var _scrollTimer:Timer;
	
	private var _hasButtons:Bool = true;
	
	public function new() {
		super();
		_layout = new VScrollLayout();
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
			_deincButton.percentWidth = 100;
			_deincButton.height = layout.innerWidth;
			_deincButton.id = "deinc";
			_deincButton.addEventListener(MouseEvent.MOUSE_DOWN, _onDeinc);
			addChild(_deincButton);
			
			_incButton = new Button();
			_incButton.percentWidth = 100;
			_incButton.height = layout.innerWidth;
			_incButton.id = "inc";
			_incButton.addEventListener(MouseEvent.MOUSE_DOWN, _onInc);
			addChild(_incButton);
		}
		
		_thumb = new Button();
		_thumb.percentWidth = 100;
		_thumb.height = 50;
		_thumb.id = "thumb";
		_thumb.remainPressed = true;
		_thumb.addEventListener(MouseEvent.MOUSE_DOWN, _onThumbMouseDown);
		addChild(_thumb);
		
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onThumbMouseDown(event:MouseEvent):Void {
		var ptStage:Point = new Point(event.stageX, event.stageY);
		_mouseDownOffset = ptStage.y - _thumb.y;

		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}
	
	private function _onScreenMouseMove(event:MouseEvent):Void {
		var ypos:Float = event.stageY - _mouseDownOffset;
		var minY:Float = 0;
		if (_deincButton != null) {
			minY = _deincButton.height + layout.spacingY;
		}
		var maxY:Float = layout.usableHeight - _thumb.height;
		if (_deincButton != null) {
			maxY += _deincButton.height + layout.spacingY;
		}
		if (ypos < minY) {
			ypos = minY;
		} else if (ypos > maxY) {
			ypos = maxY;
		}
		
		var ucy:Float = layout.usableHeight;
		ucy -= _thumb.height;
		var m:Int = Std.int(max - min);
		var v:Float = ypos - minY;
		var newValue:Float = min + ((v / ucy) * m);
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
			if (event.localY > _thumb.y) { // page down
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

private class VScrollLayout extends DefaultLayout {
	public function new() {
		super();
	}
	
	public override function resizeChildren():Void {
		super.resizeChildren();
		
		var scroll:IScrollable = cast(container, IScrollable);
		var thumb:IDisplayObject =  container.findChild("thumb");
		if (thumb != null) {
			var m:Float = scroll.max - scroll.min;
			var ucy:Float = usableHeight;
			var thumbHeight = (scroll.pageSize / m) * ucy;
			if (thumbHeight < 20) {
				thumbHeight = 20;
			} else if (thumbHeight > ucy) {
				thumbHeight = ucy;
			}
			thumb.height = thumbHeight;
		}
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		var deinc:IDisplayObject =  container.findChild("deinc");
		var inc:IDisplayObject =  container.findChild("inc");
		if (inc != null) {
			inc.y = container.height - inc.height - padding.bottom;
		}
		
		var scroll:IScrollable = cast(container, IScrollable);
		var thumb:IDisplayObject =  container.findChild("thumb");
		if (thumb != null) {
			var m:Float = scroll.max - scroll.min;
			var u:Float = usableHeight;
			u -= thumb.height;
			//var y:Float = u / (m / scroll.pos);
			var y:Float = ((scroll.pos - scroll.min) / m) * u;
			y += padding.top;
			if (deinc != null) {
				y += deinc.height + spacingY;
				
			}
			thumb.y = y;
		}
	}
	
	// usable height returns the amount of available space for % size components 
	private override function get_usableHeight():Float {
		var ucy:Float = innerHeight;
		var deinc:IDisplayObject =  container.findChild("deinc");
		var inc:IDisplayObject =  container.findChild("inc");
		if (deinc != null) {
			ucy -= deinc.height + spacingY;
		}
		if (inc != null) {
			ucy -= inc.height + spacingY;
		}
		return ucy;
	}
}