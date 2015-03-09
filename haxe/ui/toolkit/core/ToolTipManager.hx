package haxe.ui.toolkit.core;

import haxe.ui.toolkit.controls.ToolTip;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import openfl.events.MouseEvent;

using ToolTipManager.ToolTipOptionsDefaults;
using ToolTipManager.ToolTipOptionsComponentDefaults;

@:enum abstract ToolTipPosition(String) {
	var Top = "top";
	var Bottom = "bottom";
	var Left = "left";
	var Right = "right";
	
	@:from static function fromString(s:String):ToolTipPosition {
		return switch (s) {
			case ToolTipPosition.Top: Top;
			case ToolTipPosition.Bottom: Bottom;
			case ToolTipPosition.Left: Left;
			case ToolTipPosition.Right: Right;
			default:
				throw "Invalid value for enum ToolTipPosition: " + s;
		}
	}
}

@:enum abstract ToolTipRelativeTo(String) {
	var Cursor = "cursor";
	var Target = "target";
	
	@:from static function fromString(s:String):ToolTipRelativeTo {
		return switch(s) {
			case ToolTipRelativeTo.Cursor: Cursor;
			case ToolTipRelativeTo.Target: Target;
			default:
				throw "Invalid value for enum ToolTipRelativeTo: " + s;
		}
	}
}

typedef ToolTipOptions = {
	@:optional var position:ToolTipPosition;
	@:optional var relativeTo:ToolTipRelativeTo;
	@:optional var center:Bool;
	@:optional var autoHide:Bool;
	@:optional var offsetX:Float;
	@:optional var offsetY:Float;
	@:optional var delay:Int;
	@:optional var follow:Bool;
}

class ToolTipOptionsDefaults {
	public static function applyDefaults(to:ToolTipOptions) {
		to.position = (to.position != null) ? to.position : ToolTipManager.instance.defaults.position;
		to.relativeTo = (to.relativeTo != null) ? to.relativeTo : ToolTipManager.instance.defaults.relativeTo;
		to.center = (to.center != null) ? to.center : ToolTipManager.instance.defaults.center;
		to.autoHide = (to.autoHide != null) ? to.autoHide : true;
		to.offsetX = (to.offsetX != null) ? to.offsetX : ToolTipManager.instance.defaults.offsetX;
		to.offsetY = (to.offsetY != null) ? to.offsetY : ToolTipManager.instance.defaults.offsetY;
		to.delay = (to.delay != null) ? to.delay : ToolTipManager.instance.defaults.delay;
		to.follow = (to.follow != null) ? to.follow : ToolTipManager.instance.defaults.follow;
	}
}

class ToolTipOptionsComponentDefaults {
	public static function applyDefaultsFromComponent(to:ToolTipOptions, from:Component) {
		if (from.toolTipPosition != null) to.position = from.toolTipPosition;
		if (from.toolTipRelativeTo != null) to.relativeTo = from.toolTipRelativeTo;
		if (from.toolTipCenter != null) to.center = from.toolTipCenter;
		if (from.toolTipOffsetX != null) to.offsetX = from.toolTipOffsetX;
		if (from.toolTipOffsetY != null) to.offsetY = from.toolTipOffsetY;
		if (from.toolTipFollow != null) to.follow = from.toolTipFollow;
	}
}

class ToolTipManager {
	private static var _instance:ToolTipManager;
	public static var instance(get_instance, null):ToolTipManager;
	private static function get_instance():ToolTipManager {
		if (_instance == null) {
			_instance = new ToolTipManager();
		}
		return _instance;
	}

	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public var defaults:ToolTipOptions = {
		position: ToolTipPosition.Top,
		relativeTo: ToolTipRelativeTo.Cursor,
		center: true,
		offsetX: 3,
		offsetY: 3,
		delay: 700,
		follow: false
	};
	
	private var _currentToolTip:ToolTip;
	
	public function new() {
		Screen.instance;
	}
	
	public function showToolTip(c:Component, options:ToolTipOptions = null, event:UIEvent = null) {
		if (_currentToolTip != null && _currentToolTip.component == c) {
			return;
		}

		if (options == null) {
			options = { };
		}
		
		options.applyDefaultsFromComponent(c);
		options.applyDefaults();
		if (event == null || event.component != c) {
			options.relativeTo = ToolTipRelativeTo.Target;
			options.autoHide = false;
		}

		hideCurrentToolTip();
		_currentToolTip = new ToolTip();
		_currentToolTip.text = c.toolTip;
		_currentToolTip.component = c;
		_currentToolTip.options = options;
		c.root.addChild(_currentToolTip);
		_currentToolTip.alpha = 0;
		
		positionTooltip(_currentToolTip, options);
		
		Actuate.tween(_currentToolTip, .3, { alpha: 1 } );
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}
	
	private function _onScreenMouseMove(event:MouseEvent):Void {
		if (_currentToolTip != null) {
			if (_currentToolTip.options.follow == true) {
				positionTooltip(_currentToolTip, _currentToolTip.options);
			}
			if (_currentToolTip.component.hitTest(event.stageX, event.stageY) == false && _currentToolTip.options.autoHide == true ) {
				hideCurrentToolTip();
			}
		}
	}
	
	private function positionTooltip(tooltip:ToolTip, options:ToolTipOptions):Void {
		var c:Component = tooltip.component;
		var xpos:Float = c.stageX - c.root.stageX;
		var ypos:Float = c.stageY - c.root.stageY;
		if (options.relativeTo == ToolTipRelativeTo.Cursor) {
			xpos = Screen.instance.cursorX;
			ypos = Screen.instance.cursorY;
		}
		
		switch (options.position) {
			case ToolTipPosition.Top:
				if (options.relativeTo == ToolTipRelativeTo.Cursor) {
					xpos += options.offsetX;
					if (options.center == true) {
						xpos -= _currentToolTip.width / 2;
					}
					ypos -= _currentToolTip.height + options.offsetY;
				} else if (options.relativeTo == ToolTipRelativeTo.Target) {
					if (options.center == true) {
						xpos = xpos + ((c.width / 2) - (_currentToolTip.width / 2));
					} else {
						xpos += options.offsetX;
					}
					ypos -= _currentToolTip.height + options.offsetY;
				}
			case ToolTipPosition.Bottom:
				if (options.relativeTo == ToolTipRelativeTo.Cursor) {
					xpos += options.offsetX;
					if (options.center == true) {
						xpos -= _currentToolTip.width / 2;
					}
					ypos += options.offsetY;
				} else if (options.relativeTo == ToolTipRelativeTo.Target) {
					if (options.center == true) {
						xpos = xpos + ((c.width / 2) - (_currentToolTip.width / 2));
					} else {
						xpos += options.offsetX;
					}
					ypos += _currentToolTip.height + options.offsetY;
				}
			case ToolTipPosition.Left:
				if (options.relativeTo == ToolTipRelativeTo.Cursor) {
					xpos -= _currentToolTip.width + options.offsetX;
					ypos += options.offsetY;
					if (options.center == true) {
						ypos -= _currentToolTip.height / 2;
					}
				} else if (options.relativeTo == ToolTipRelativeTo.Target) {
					xpos -= _currentToolTip.width + options.offsetX;
					if (options.center == true) {
						ypos = ypos + ((c.height / 2) - (_currentToolTip.height / 2));
					} else {
						ypos += options.offsetY;
					}
				}
			case ToolTipPosition.Right:
				if (options.relativeTo == ToolTipRelativeTo.Cursor) {
					xpos += options.offsetX;
					ypos += options.offsetY;
					if (options.center == true) {
						ypos -= _currentToolTip.height / 2;
					}
				} else if (options.relativeTo == ToolTipRelativeTo.Target) {
					xpos += c.width + options.offsetX;
					if (options.center == true) {
						ypos = ypos + ((c.height / 2) - (_currentToolTip.height / 2));
					} else {
						ypos += options.offsetY;
					}
				}
		}
		
		tooltip.x = xpos;
		tooltip.y = ypos;
	}
	
	public function hideCurrentToolTip():Void {
		Screen.instance.removeEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
		if (_currentToolTip != null) {
			var copy = _currentToolTip;
			Actuate.tween(_currentToolTip, .3, { alpha: 0 } ).onComplete(function() {
				copy.root.removeChild(copy);
			});
		}
		Screen.instance.removeEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
		_currentToolTip = null;
	}
	
	public function toolTipVisible(c:Component):Bool {
		if (_currentToolTip == null) {
			return false;
		}
		return (_currentToolTip.component == c);
	}
}