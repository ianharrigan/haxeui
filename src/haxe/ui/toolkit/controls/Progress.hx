package haxe.ui.toolkit.controls;

import flash.events.Event;
import haxe.ui.toolkit.core.base.State;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IDirectional;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IScrollable;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.layout.DefaultLayout;

/**
 Progress bar control
 **/
 
@:event("UIEvent.CHANGE", "Dispatched when the value of the progress bar changes") 
class Progress extends StateComponent implements IScrollable implements IDirectional implements IClonable<Progress> {
	private var _direction:String;
	private var _min:Float = 0;
	private var _max:Float = 100;
	private var _pos:Float = 0;
	private var _incrementSize:Float = 1;
	
	private var _valueBgComp:StateComponent;
	private var _valueComp:StateComponent;
	
	public function new() {
		super();
		addStates([State.NORMAL, State.DISABLED]);
		direction = Direction.HORIZONTAL;
		_valueBgComp = new StateComponent();
		_valueBgComp.addStates([State.NORMAL, State.DISABLED]);
		_valueBgComp.id = "background";
		_valueComp = new StateComponent();
		_valueComp.addStates([State.NORMAL, State.DISABLED]);
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
	/**
	 The direction of this progress bar. Can be `horizontal` or `vertical`
	 **/
	@:clonable
	public var direction(get, set):String;
	/**
	 Minimum value allowed for the progress bar
	 **/
	@:clonable
	public var min(get, set):Float;
	/**
	 Maximum value allowed for the progress bar
	 **/
	@:clonable
	public var max(get, set):Float;
	/**
	 Value of the progress bar
	 **/
	@:clonable
	public var pos(get, set):Float;
	/**
	 Not applicable to progress bar
	 **/
	@:clonable
	public var pageSize(get, set):Float;
	/**
	 How much the scrollbar should increment (or deincrement)
	 **/
	@:clonable
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
		if (value != _min) {
			_min = value;
			var changeEvent:Event = new Event(Event.CHANGE);
			dispatchEvent(changeEvent);
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
			var changeEvent:Event = new Event(Event.CHANGE);
			dispatchEvent(changeEvent);
			invalidate(InvalidationFlag.LAYOUT);
		}
		return _max;
	}
	
	private function get_pos():Float {
		return _pos;
	}
	
	private function set_pos(value:Float):Float {
		if (_ready) {
			if (value < _min) {
				value = _min;
			}
			if (value > _max) {
				value = _max;
			}
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

@exclude
class HProgressLayout extends DefaultLayout {
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
			var ucx:Float = usableWidth;
			
			var thumb:IDisplayObject =  container.findChild("thumb");
			if (thumb != null) {
				ucx -= thumb.width;
			}
			
			value.percentWidth = -1; // we dont want value to ever % size
			var cx:Float = (scroll.pos - scroll.min) / (scroll.max - scroll.min) * ucx; // get the position in percentage for (min, max) values. cx is always between (0, usableWidth)

			if (cx < 0) {
				cx = 0;
			} else if (cx > ucx) {
				cx = ucx;
			}

			if (thumb != null) {
				cx += thumb.width / 2;
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
			
			var thumb:IDisplayObject =  container.findChild("thumb");
			if (thumb != null) {
				var xpos:Float = value.x + value.width - (thumb.width / 2);
				thumb.x = Std.int(xpos);
			}
		}
	}
}

@exclude
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
			var ucy:Float = usableHeight;
			
			var thumb:IDisplayObject =  container.findChild("thumb");
			if (thumb != null) {
				ucy -= thumb.height;
			}
			
			value.percentHeight = -1; // we dont want value to ever % size
			var cy:Float = (scroll.pos - scroll.min) / (scroll.max - scroll.min) * ucy; // get the position in percentage for (min, max) values. cy is always between (0, usableWidth)
			
			if (cy < 0) {
				cy = 0;
			} else if (cy > ucy) {
				cy = ucy;
			}
			
			if (thumb != null) {
				cy += thumb.height / 2;
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
			value.y = ucy - value.height - background.layout.padding.bottom;
			
			var thumb:IDisplayObject =  container.findChild("thumb");
			if (thumb != null) {
				var ypos:Float = value.y - (thumb.height / 2);
				thumb.y = Std.int(ypos);
			}
		}
	}
}
