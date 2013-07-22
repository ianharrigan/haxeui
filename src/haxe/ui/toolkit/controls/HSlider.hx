package haxe.ui.toolkit.controls;

import flash.events.MouseEvent;
import flash.geom.Point;
import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.Screen;

class HSlider extends Slider {
	public function new() {
		super();
		direction = Direction.HORIZONTAL;
	}
	
	//******************************************************************************************
	// Event handler overrides
	//******************************************************************************************
	private override function _onMouseDown(event:MouseEvent):Void {
		var ptStage:Point = new Point(event.stageX, event.stageY);
		_mouseDownOffset = ptStage.x - _thumb.x;

		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}

	private override function _onScreenMouseMove(event:MouseEvent):Void {
		var xpos:Float = event.stageX - _mouseDownOffset;
		var minX:Float = 0;
		var maxX:Float = layout.usableWidth - _thumb.width;
		
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
}