package haxe.ui.toolkit.containers;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.ui.toolkit.controls.HScroll;
import haxe.ui.toolkit.controls.VScroll;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IEventDispatcher;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.layout.DefaultLayout;
import haxe.ui.toolkit.util.TypeParser;

class ScrollView extends Component {
	private var _hscroll:HScroll;
	private var _vscroll:VScroll;
	
	private var _showHScroll:Bool = true;
	private var _showVScroll:Bool = true;
	
	private var _eventTarget:Sprite;
	private var _downPos:Point;
	private var _scrollSensitivity:Int = 1;
	
	private var _autoHideScrolls:Bool = false;
	
	public function new() {
		super();
		
		_layout = new ScrollViewLayout();
		_eventTarget = new Sprite();
		_eventTarget.visible = false;
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		
		if (_style != null) {
			if (_style.autoHideScrolls != null) {
				_autoHideScrolls = TypeParser.parseBool(_style.autoHideScrolls);
			}
		}
	}
	
	private override function initialize():Void {
		super.initialize();

		addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		
		var content:IDisplayObject = getChildAt(0); // assume first child is content
		if (content != null) {
			cast(content, IEventDispatcher).addEventListener(Event.ADDED_TO_STAGE, function(e) {
				invalidate();
			});
		}
		
		sprite.addChild(_eventTarget);
	}
	
	public override function dispose():Void {
		sprite.removeChild(_eventTarget);
		super.dispose();
	}

	//******************************************************************************************
	// Helper props
	//******************************************************************************************
	public var hscrollPos(get, set):Float;
	public var hscrollMin(get, null):Float;
	public var hscrollMax(get, null):Float;
	public var hscrollPageSize(get, null):Float;

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
	
	private function get_hscrollMax():Float {
		if (_hscroll != null) {
			return _hscroll.max;
		}
		return 0;
	}
	
	private function get_hscrollPageSize():Float {
		if (_hscroll != null) {
			return _hscroll.pageSize;
		}
		return 0;
	}
	
	public var vscrollPos(get, set):Float;
	public var vscrollMin(get, null):Float;
	public var vscrollMax(get, null):Float;
	public var vscrollPageSize(get, null):Float;
	
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
	
	private function get_vscrollMax():Float {
		if (_vscroll != null) {
			return _vscroll.max;
		}
		return 0;
	}
	
	private function get_vscrollPageSize():Float {
		if (_vscroll != null) {
			return _vscroll.pageSize;
		}
		return 0;
	}
	
	//******************************************************************************************
	// Overridables
	//******************************************************************************************
	public override function invalidate(type:Int = InvalidationFlag.ALL):Void {
		super.invalidate();
		if (!_ready) {
			return;
		}

		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE) {
			checkScrolls();
			updateScrollRect();
			resizeEventTarget();
		}
	}
	
	//******************************************************************************************
	// Event handlers
	//******************************************************************************************
	private function _onHScrollChange(event:Event):Void {
		updateScrollRect();
	}
	
	private function _onVScrollChange(event:Event):Void {
		updateScrollRect();
	}
	
	private function _onMouseWheel(event:MouseEvent):Void {
		var content:IDisplayObject = getChildAt(0); // assume first child is content
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
		if (_vscroll != null) {
			inScroll = _vscroll.hitTest(event.stageX, event.stageY);
		}
		if (_hscroll != null && inScroll == false) {
			inScroll = _hscroll.hitTest(event.stageX, event.stageY);
		}
		
		var content:IDisplayObject = getChildAt(0); // assume first child is content
		if (content != null) {
			if (inScroll == false || content.width > layout.usableWidth || content.height > layout.usableHeight) {
				_downPos = new Point(event.stageX, event.stageY);
				root.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
				root.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			}
		}
	}
	
	private function _onMouseMove(event:MouseEvent):Void {
		if (_downPos != null) {
			var ypos:Float = event.stageY - _downPos.y;
			var xpos:Float = event.stageX - _downPos.x;
			if (Math.abs(xpos) >= _scrollSensitivity  || Math.abs(ypos) >= _scrollSensitivity) {
				_eventTarget.visible = true;
				var content:IDisplayObject = getChildAt(0); // assume first child is content
				if (content != null) {
					if (xpos != 0 && content.width > layout.usableWidth) {
						if (_showHScroll == true && _autoHideScrolls == true) {
							_hscroll.visible = true;
						}
						if (_hscroll != null) {
							_hscroll.pos -= xpos;
						}
					}
					
					if (ypos != 0 && content.height > layout.usableHeight) {
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
	
	private function _onMouseUp(event:MouseEvent):Void {
		_eventTarget.visible = false;
		_downPos = null;
		root.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		root.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		
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
		var content:IDisplayObject = getChildAt(0); // assume first child is content
		if (content != null) {
			// show hscroll if needed
			var invalidateLayout:Bool = false;
			var hpos:Float = 0;
			if (_hscroll != null) {
				hpos = _hscroll.pos;
			}
			if (content.width - hpos > layout.usableWidth) {
				if (_hscroll == null) {
					_hscroll = new HScroll();
					_hscroll.percentWidth = 100;
					_hscroll.addEventListener(Event.CHANGE, _onHScrollChange);
					_hscroll.visible = false;
					addChild(_hscroll);
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
				if (_vscroll == null) { // create vscroll
					_vscroll = new VScroll();
					_vscroll.percentHeight = 100;
					_vscroll.addEventListener(Event.CHANGE, _onVScrollChange);
					_vscroll.visible = false;
					addChild(_vscroll);
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
			
			if (invalidateLayout) {
				invalidate(InvalidationFlag.LAYOUT);
			}
		}
	}
	
	private function updateScrollRect():Void {
		if (numChildren > 0) {
			var content:IDisplayObject = getChildAt(0);
			if (content != null) {
				var xpos:Float = 0;
				if (_hscroll != null) {
					xpos = _hscroll.pos;
				}
				var ypos:Float = 0;
				if (_vscroll != null) {
					ypos = _vscroll.pos;
				}
				content.sprite.scrollRect = new Rectangle(xpos, ypos, layout.usableWidth, layout.usableHeight);
			}
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

private class ScrollViewLayout extends DefaultLayout {
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