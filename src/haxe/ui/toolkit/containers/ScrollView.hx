package haxe.ui.toolkit.containers;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import haxe.ui.toolkit.controls.HScroll;
import haxe.ui.toolkit.controls.VScroll;
import haxe.ui.toolkit.core.base.State;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.layout.DefaultLayout;
import haxe.ui.toolkit.layout.VerticalLayout;

class ScrollView extends StateComponent {
	private var _hscroll:HScroll;
	private var _vscroll:VScroll;
	private var _container:Box;
	
	private var _showHScroll:Bool = true;
	private var _showVScroll:Bool = true;
	
	private var _eventTarget:Sprite;
	private var _downPos:Point;
	#if mobile
	private var _scrollSensitivity:Int = 0;
	#elseif html5
	private var _scrollSensitivity:Int = 1;
	#else
	private var _scrollSensitivity:Int = 0;
	#end
	
	private var _autoHideScrolls:Bool = false;
	private var _virtualScrolling:Bool = false;
	
	public function new() {
		super();
		addStates([State.NORMAL, State.DISABLED]);
		_layout = new ScrollViewLayout();
		_eventTarget = new Sprite();
		_eventTarget.visible = false;
		
		_container = new Box();
		_container.layout = new VerticalLayout();
		_container.id = "container";
		_container.percentWidth = _container.percentHeight = 100;
		addChild(_container);
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		
		if (_style != null) {
			_autoHideScrolls = _style.autoHideScrolls;
			if (Reflect.getProperty(_layout, "inlineScrolls") != null) {
				Reflect.setProperty(_layout, "inlineScrolls", _style.inlineScrolls);
			}
		}
	}
	
	private override function initialize():Void {
		super.initialize();

		addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		
		sprite.addChild(_eventTarget);
	}
	
	private override function postInitialize():Void {
		super.postInitialize();
		var content:IDisplayObject = _container.getChildAt(0); // assume first child is content
		if (content != null) {
			cast(content, IEventDispatcher).addEventListener(UIEvent.RESIZE, function(e) {
				invalidate(InvalidationFlag.SIZE);
			});
		}
	}
	
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = null;
		if (child == _container || child == _hscroll || child == _vscroll) {
			r = super.addChild(child);
		} else {
			r = _container.addChild(child);
		}
		return r;
	}
	
	public override function addChildAt(child:IDisplayObject, index:Int):IDisplayObject {
		var r = null;
		if (child == _container || child == _hscroll || child == _vscroll) {
			r = super.addChildAt(child, index);
		} else {
			r = _container.addChildAt(child, index);
		}
		return r;
	}
	
	public override function removeChild(child:IDisplayObject, dispose:Bool = true):IDisplayObject {
		var r = null;
		if (child == _container || child == _hscroll || child == _vscroll) {
			r = super.removeChild(child, dispose);
		} else {
			r = _container.removeChild(child, dispose);
		}
		return r;
	}
	
	public override function dispose():Void {
		sprite.removeChild(_eventTarget);
		super.dispose();
	}

	//******************************************************************************************
	// Helper props
	//******************************************************************************************
	public var virtualScrolling(get, set):Bool;
	private function get_virtualScrolling():Bool {
		return _virtualScrolling;
	}
	private function set_virtualScrolling(value:Bool):Bool {
		_virtualScrolling = value;
		return value;
	}
	
	public var showHScroll(get, set):Bool;
	public var showVScroll(get, set):Bool;
	
	private function get_showHScroll():Bool {
		return _showHScroll;
	}
	
	private function set_showHScroll(value:Bool):Bool {
		_showHScroll = value;
		return value;
	}
	
	private function get_showVScroll():Bool {
		return _showVScroll;
	}
	
	private function set_showVScroll(value:Bool):Bool {
		_showVScroll = value;
		return value;
	}
	
	public var hscrollPos(get, set):Float;
	public var hscrollMin(get, set):Float;
	public var hscrollMax(get, set):Float;
	public var hscrollPageSize(get, set):Float;

	private function get_hscrollPos():Float {
		if (_hscroll != null) {
			return _hscroll.pos;
		}
		return 0;
	}
	
	private function set_hscrollPos(value:Float) {
		if (_hscroll != null) {
			_hscroll.pos = value;
		}
		return value;
	}

	private function get_hscrollMin():Float {
		if (_hscroll != null) {
			return _hscroll.min;
		}
		return 0;
	}

	private function set_hscrollMin(value:Float):Float {
		if (_virtualScrolling == true) {
			
		}
		return value;
	}
	
	private function get_hscrollMax():Float {
		if (_hscroll != null) {
			return _hscroll.max;
		}
		return 0;
	}
	
	private function set_hscrollMax(value:Float):Float {
		if (_virtualScrolling == true) {
			createHScroll(true);
			_hscroll.max = value;
		}
		return value;
	}
	
	private function get_hscrollPageSize():Float {
		if (_hscroll != null) {
			return _hscroll.pageSize;
		}
		return 0;
	}
	
	private function set_hscrollPageSize(value:Float):Float {
		if (_virtualScrolling == true) {
			
		}
		return value;
	}
	
	public var vscrollPos(get, set):Float;
	public var vscrollMin(get, set):Float;
	public var vscrollMax(get, set):Float;
	public var vscrollPageSize(get, set):Float;
	
	private function get_vscrollPos():Float {
		if (_vscroll != null) {
			return _vscroll.pos;
		}
		return 0;
	}
	
	private function set_vscrollPos(value:Float) {
		if (_vscroll != null) {
			_vscroll.pos = value;
		}
		return value;
	}

	private function get_vscrollMin():Float {
		if (_vscroll != null) {
			return _vscroll.min;
		}
		return 0;
	}
	
	private function set_vscrollMin(value:Float):Float {
		if (_virtualScrolling == true) {
			
		}
		return value;
	}
	
	private function get_vscrollMax():Float {
		if (_vscroll != null) {
			return _vscroll.max;
		}
		return 0;
	}
	
	private function set_vscrollMax(value:Float):Float {
		if (_virtualScrolling == true) {
			createVScroll(true);
			_vscroll.max = value;
		}
		return value;
	}
	
	private function get_vscrollPageSize():Float {
		if (_vscroll != null) {
			return _vscroll.pageSize;
		}
		return 0;
	}
	
	private function set_vscrollPageSize(value:Float):Float {
		if (_virtualScrolling == true) {
			
		}
		return value;
	}
	
	//******************************************************************************************
	// Overridables
	//******************************************************************************************
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		if (!_ready || _invalidating) {
			return;
		}

		super.invalidate(type, recursive);
		_invalidating = true;
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE) {
			checkScrolls();
			updateScrollRect();
			resizeEventTarget();
		}
		_invalidating = false;
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onHScrollChange(event:Event):Void {
		updateScrollRect();
		var event:UIEvent = new UIEvent(UIEvent.SCROLL);
		dispatchEvent(event);
	}
	
	private function _onVScrollChange(event:Event):Void {
		updateScrollRect();
		var event:UIEvent = new UIEvent(UIEvent.SCROLL);
		dispatchEvent(event);
	}
	
	private function _onMouseWheel(event:MouseEvent):Void {
		var content:IDisplayObject = _container.getChildAt(0); // assume first child is content
		if (event.shiftKey || content.height < layout.usableHeight) {
			if (_hscroll != null && content.width > layout.usableWidth) {
				if (event.delta != 0) {
					if (event.delta < 0) {
						_hscroll.incrementValue();
					} else if (event.delta > 0) {
						_hscroll.deincrementValue();
					}
				}
			}
		} else {
			if (_vscroll != null && content.height > layout.usableHeight) {
				if (event.delta != 0) {
					if (event.delta < 0) {
						_vscroll.incrementValue();
					} else if (event.delta > 0) {
						_vscroll.deincrementValue();
					}
				}
			}
		}
	}
	
	private function _onMouseDown(event:MouseEvent):Void {
		var inScroll:Bool = false;
		if (_vscroll != null && _vscroll.visible == true) {
			inScroll = _vscroll.hitTest(event.stageX, event.stageY);
		}
		if (_hscroll != null && _hscroll.visible == true && inScroll == false) {
			inScroll = _hscroll.hitTest(event.stageX, event.stageY);
		}
		
		var content:IDisplayObject = _container.getChildAt(0); // assume first child is content
		if (content != null && inScroll == false && _virtualScrolling == false) {
			if (content.width > layout.usableWidth || content.height > layout.usableHeight) {
				_downPos = new Point(event.stageX, event.stageY);
				Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
				Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
			}
		}
		
		if (_virtualScrolling == true && (_vscroll != null || _hscroll != null)) {
			_downPos = new Point(event.stageX, event.stageY);
			Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
			Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
		}
	}
	
	private function _onScreenMouseMove(event:MouseEvent):Void {
		if (_downPos != null) {
			var ypos:Float = event.stageY - _downPos.y;
			var xpos:Float = event.stageX - _downPos.x;
			
			var target:DisplayObject =  event.target;
			while (target != null && Std.is(target, DisplayObject))
			{
				xpos /= target.scaleX;
				ypos /= target.scaleY;
				target = target.parent;
			}
			
			if (Math.abs(xpos) >= _scrollSensitivity  || Math.abs(ypos) >= _scrollSensitivity) {
				_eventTarget.visible = true;
				var content:IDisplayObject = _container.getChildAt(0); // assume first child is content
				if (content != null) {
					if (xpos != 0 && (content.width > layout.usableWidth || _virtualScrolling == true)) {
						if (_showHScroll == true && _autoHideScrolls == true) {
							_hscroll.visible = true;
						}
						if (_hscroll != null) {
							_hscroll.pos -= xpos;
						}
					}
					
					if (ypos != 0 && (content.height > layout.usableHeight || _virtualScrolling == true)) {
						if (_showVScroll == true && _autoHideScrolls == true) {
							_vscroll.visible = true;
						}
						if (_vscroll != null) {
							_vscroll.pos -= ypos;
						}
					}
					
					_downPos = new Point(event.stageX, event.stageY);
				}
			}
		}
	}
	
	private function _onScreenMouseUp(event:MouseEvent):Void {
		_eventTarget.visible = false;
		_downPos = null;
		Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		Screen.instance.removeEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
		
		if (_hscroll != null && _showHScroll == true && _autoHideScrolls == true) {
			_hscroll.visible = false;
		}
		if (_vscroll != null && _showVScroll == true && _autoHideScrolls == true) {
			_vscroll.visible = false;
		}
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function checkScrolls():Void { // checks to see if scrolls are needed, creates/displays/hides as appropriate
		if (_virtualScrolling == true) {
			return;
		}

		var content:IDisplayObject = _container.getChildAt(0); // assume first child is content
		if (content != null) {
			// show hscroll if needed
			var invalidateLayout:Bool = false;
			var hpos:Float = 0;
			if (_hscroll != null) {
				hpos = _hscroll.pos;
			}
			if (content.width - hpos > layout.usableWidth) {
				if (createHScroll() == true) {
					_hscroll.visible = false;
					invalidateLayout = true;
				}
				
				_hscroll.max = content.width - layout.usableWidth;
				_hscroll.pageSize = (layout.usableWidth / content.width) * _hscroll.max;
				if (_hscroll.visible == false && _showHScroll == true && _autoHideScrolls == false) {
					_hscroll.visible = true;
					invalidateLayout = true;
				}
			} else {
				if (_hscroll != null) {
					if (_hscroll.pos != 0) {
						_hscroll.pos = content.width - layout.usableWidth;
					}
					
					if (_hscroll.pos == 0) {
						if (_hscroll.visible == true) {
							_hscroll.visible = false;
							invalidateLayout = true;
						}
					} else {
						_hscroll.max = content.width - layout.usableWidth;
						_hscroll.pageSize = (layout.usableWidth / content.width) * _hscroll.max;
					}
				}
			}
			
			// show vscroll if needed
			var vpos:Float = 0;
			if (_vscroll != null) {
				vpos = _vscroll.pos;
			}
			if (content.height - vpos > layout.usableHeight) {
				if (createVScroll() == true) {
					_vscroll.visible = false;
					invalidateLayout = true;
				}
				
				_vscroll.max = content.height - layout.usableHeight;
				_vscroll.pageSize = (layout.usableHeight / content.height) * _vscroll.max;
				if (_vscroll.visible == false && _showVScroll == true && _autoHideScrolls == false) {
					_vscroll.visible = true;
					invalidateLayout = true;
				}
			} else {
				if (_vscroll != null) {
					if (_vscroll.pos != 0) {
						_vscroll.pos = content.height - layout.usableHeight;
					} 
					
					if (_vscroll.pos == 0) {
						if (_vscroll.visible == true) {
							_vscroll.visible = false;
							invalidateLayout = true;
						}
					} else {
						_vscroll.max = content.height - layout.usableHeight;
						_vscroll.pageSize = (layout.usableHeight / content.height) * _vscroll.max;
					}
				}
			}
			
			//invalidateLayout = true;
			if (invalidateLayout) {
				_invalidating = false;
				invalidate(InvalidationFlag.LAYOUT);
			}
		}
	}
	
	private function createHScroll(invalidateLayout:Bool = false):Bool {
		var created:Bool = false;
		if (_hscroll == null) {
			_hscroll = new HScroll();
			_hscroll.percentWidth = 100;
			_hscroll.addEventListener(Event.CHANGE, _onHScrollChange);
			if (_showHScroll == false) {
				_hscroll.visible = false;
			} else if (_autoHideScrolls == true) {
				_hscroll.visible = false;
			} else {
				_hscroll.visible = true;
			}
			addChild(_hscroll);
			created = true;
		}
		
		if (invalidateLayout) {
			_invalidating = false;
			invalidate(InvalidationFlag.LAYOUT);
		}
		
		return created;
	}
	
	private function createVScroll(invalidateLayout:Bool = false):Bool {
		var created:Bool = false;
		if (_vscroll == null) { // create vscroll
			_vscroll = new VScroll();
			_vscroll.percentHeight = 100;
			_vscroll.addEventListener(Event.CHANGE, _onVScrollChange);
			if (_showVScroll == false) {
				_vscroll.visible = false;
			} else if (_autoHideScrolls == true) {
				_vscroll.visible = false;
			} else {
				_vscroll.visible = true;
			}
			addChild(_vscroll);
		}
				
		if (invalidateLayout) {
			_invalidating = false;
			invalidate(InvalidationFlag.LAYOUT);
		}
		return created;
	}
	
	private function updateScrollRect():Void {
		if (numChildren > 0 && _virtualScrolling == false) {
			var content:IDisplayObject = _container.getChildAt(0);
			if (content != null) {
				var xpos:Float = 0;
				if (_hscroll != null) {
					xpos = _hscroll.pos;
				}
				var ypos:Float = 0;
				if (_vscroll != null) {
					ypos = _vscroll.pos;
				}
				content.x = -xpos;
				content.y = -ypos;
				//content.sprite.scrollRect = new Rectangle(xpos, ypos, layout.usableWidth, layout.usableHeight);
				_container.sprite.scrollRect = new Rectangle(0, 0, layout.usableWidth, layout.usableHeight);
			}
		} else {
			_container.sprite.scrollRect = new Rectangle(0, 0, layout.usableWidth, layout.usableHeight);
		}
	}
	
	private function resizeEventTarget():Void {
		var targetX:Float = layout.padding.left;
		var targetY:Float = layout.padding.top;
		var targetCX:Float = width - (layout.padding.left + layout.padding.right);
		var targetCY:Float = height - (layout.padding.top + layout.padding.bottom);
		if (_vscroll != null && _vscroll.visible == true) {
			targetCX -= _vscroll.width;
		}
		if (_hscroll != null && _hscroll.visible == true) {
			targetCY -= _hscroll.height;
		}
		
		_eventTarget.alpha = 0;
		_eventTarget.graphics.clear();
		_eventTarget.graphics.beginFill(0xFF00FF);
		_eventTarget.graphics.lineStyle(0);
		_eventTarget.graphics.drawRect(targetX, targetY, targetCX, targetCY);
		_eventTarget.graphics.endFill();
	}
}

@exclude
class ScrollViewLayout extends DefaultLayout {
	private var _inlineScrolls:Bool = false;
	
	public function new() {
		super();
	}
	
	public override function resizeChildren():Void {
		super.resizeChildren();
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		var hscroll:HScroll =  container.findChildAs(HScroll);
		var vscroll:VScroll =  container.findChildAs(VScroll);
		if (hscroll != null) {
			hscroll.y = container.height - hscroll.height - padding.bottom;
		}
		if (vscroll != null) {
			vscroll.x = container.width - vscroll.width - padding.right;
		}
	}
	
	// usable width returns the amount of available space for % size components 
	private override function get_usableWidth():Float {
		var ucx:Float = innerWidth;
		var vscroll:VScroll =  container.findChildAs(VScroll);
		if (vscroll != null && vscroll.visible == true && _inlineScrolls == false) {
			ucx -= vscroll.width + spacingX;
		}
		return ucx;
	}
	
	// usable height returns the amount of available space for % size components 
	private override function get_usableHeight():Float {
		var ucy:Float = innerHeight;
		var hscroll:HScroll =  container.findChildAs(HScroll);
		if (hscroll != null && hscroll.visible && _inlineScrolls == false) {
			ucy -= hscroll.height + spacingY;
		}
		return ucy;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public var inlineScrolls(get, set):Bool;
	
	private function get_inlineScrolls():Bool {
		return _inlineScrolls;
	}
	
	private function set_inlineScrolls(value:Bool):Bool {
		_inlineScrolls = value;
		return value;
	}
	
}