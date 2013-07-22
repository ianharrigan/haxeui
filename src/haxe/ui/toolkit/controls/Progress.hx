package haxe.ui.toolkit.controls;

import flash.display.Bitmap;
import flash.events.Event;
import flash.Lib;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IDirectional;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IScrollable;
import haxe.ui.toolkit.layout.DefaultLayout;
import haxe.ui.toolkit.layout.Layout;

class Progress extends Component implements IScrollable implements IDirectional {
	private var _direction:String;
	private var _min:Float = 0;
	private var _max:Float = 100;
	private var _pos:Float = 0;
	private var _incrementSize:Float = 1;
	
	private var _valueBgComp:Component;
	private var _valueComp:Component;
	
	public function new() {
		super();
		
		direction = Direction.HORIZONTAL;
		_valueBgComp = new Component();
		_valueBgComp.id = "background";
		_valueComp = new Component();
		_valueComp.id = "value";
	}
	
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		addChild(_valueBgComp);
		_valueBgComp.addChild(_valueComp);
	}
	
	//******************************************************************************************
	// ProgressBar methods/properties
	//******************************************************************************************
	public var direction(get, set):String;
	public var min(get, set):Float;
	public var max(get, set):Float;
	public var pos(get, set):Float;
	public var pageSize(get, set):Float;
	public var incrementSize(get, set):Float;
	
	private function get_direction():String {
		return _direction;
	}
	
	private function set_direction(value:String):String {
		_direction = value;
		if (value == Direction.HORIZONTAL) {
			_layout = new HProgressLayout();
		} else if (value == Direction.VERTICAL) {
			_layout = new VProgressLayout();
		}
		return value;
	}
	
	private function get_min():Float {
		return _min;
	}
	
	private function set_min(value:Float):Float {
		_min = value;
		return value;
	}
	
	private function get_max():Float {
		return _max;
	}
	
	private function set_max(value:Float):Float {
		_max = value;
		return _max;
	}
	
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
	
	private function get_pageSize():Float {
		return 0;
	}
	
	private function set_pageSize(value:Float):Float {
		return value;
	}
	
	private function get_incrementSize():Float {
		return _incrementSize;
	}
	
	private function set_incrementSize(value:Float):Float {
		_incrementSize = value;
		return value;
	}
}

private class HProgressLayout extends DefaultLayout {
	public function new() {
		super();
	}
	
	public override function resizeChildren():Void {
		super.resizeChildren();

		var background:Component = container.findChild("background", Component);
		var value:IDisplayObject = null;
		if (background != null) {
			 value = background.findChild("value");
		}
		
		var scroll:IScrollable = cast(container, IScrollable);
		if (value != null) {
			var m:Float = scroll.max - scroll.min;
			var ucx:Float = usableWidth;
			
			var thumb:IDisplayObject =  container.findChild("thumb");
			if (thumb != null) {
				ucx -= thumb.width;
			}
			
			value.percentWidth = -1; // we dont want value to ever % size
			var cx:Float = (scroll.pos / m) * ucx;

			if (cx < 0) {
				cx = 0;
			} else if (cx > ucx) {
				cx = ucx;
			}
			
			if (cx == 0) {
				value.visible = false;
			} else {
				value.width = cx;
				value.visible = true;
			}
		}
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		var background:Component =  container.findChild("background", Component);
		var value:IDisplayObject =  null;
		if (background != null) {
			background.y = (container.height / 2) - (background.height / 2);
			value = background.findChild("value");
		}

		var scroll:IScrollable = cast(container, IScrollable);
		if (value != null) {
			//value.y = (container.height / 2) - (value.height / 2);
			
			var thumb:IDisplayObject =  container.findChild("thumb");
			if (thumb != null) {
				var xpos:Float = value.x;
				if (scroll.pos != scroll.min) {
					xpos += value.width;
					if (scroll.pos != scroll.max) { // bit of a hack
						xpos--;
					}
				}
				thumb.x = Std.int(xpos);
			}
		}
	}
}

class VProgressLayout extends DefaultLayout {
	public function new() {
		super();
	}
	
	public override function resizeChildren():Void {
		super.resizeChildren();

		var background:Component = container.findChild("background", Component);
		var value:IDisplayObject = null;
		if (background != null) {
			 value = background.findChild("value");
		}
		
		var scroll:IScrollable = cast(container, IScrollable);
		if (value != null) {
			var m:Float = scroll.max - scroll.min;
			var ucy:Float = usableHeight;
			
			var thumb:IDisplayObject =  container.findChild("thumb");
			if (thumb != null) {
				ucy -= thumb.height;
			}
			
			value.percentHeight = -1; // we dont want value to ever % size
			var cy:Float = (scroll.pos / m) * ucy;
			if (cy < 0) {
				cy = 0;
			} else if (cy > ucy) {
				cy = ucy;
			}
			
			if (cy == 0) {
				value.visible = false;
			} else {
				value.height = cy;
				value.visible = true;
			}
		}
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();

		var background:Component =  container.findChild("background", Component);
		var value:IDisplayObject = null;
		if (background != null) {
			background.x = (container.width / 2) - (background.width / 2);
			value = background.findChild("value");
		}
		
		var scroll:IScrollable = cast(container, IScrollable);
		if (value != null) {
			var ucy:Float = usableHeight;
			//value.x = (container.width / 2) - (value.width / 2);
			value.y = ucy - value.height - background.layout.padding.bottom;
			
			var thumb:IDisplayObject =  container.findChild("thumb");
			if (thumb != null) {
				var ypos:Float = value.y;
				if (scroll.pos != scroll.min) {
					ypos -= thumb.height;
					if (scroll.pos != scroll.max) { // bit of a hack
						ypos++;
					}
				} else {
					ypos = innerHeight - thumb.height;
				}
				thumb.y = Std.int(ypos);
			}
		}
	}
}
