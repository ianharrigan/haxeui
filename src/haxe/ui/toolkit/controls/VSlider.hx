package haxe.ui.toolkit.controls;

import flash.events.MouseEvent;
import flash.geom.Point;
import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.Screen;

class VSlider extends Slider {
	public function new() {
		super();
		direction = Direction.VERTICAL;
	}
	
	//******************************************************************************************
	// Event handler overrides
	//******************************************************************************************
	private override function _onMouseDown(event:MouseEvent):Void {
		var ptStage:Point = new Point(event.stageX, event.stageY);
		_mouseDownOffset = ptStage.y - _thumb.y;

		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}

	private override function _onScreenMouseMove(event:MouseEvent):Void {
		var ypos:Float = event.stageY - _mouseDownOffset;
		var minY:Float = 0;
		var maxY:Float = layout.usableHeight - _thumb.height;
		
		if (ypos < minY) {
			ypos = minY;
		} else if (ypos > maxY) {
			ypos = maxY;
		}
		
		var ucy:Float = layout.usableHeight;
		ucy -= _thumb.height;
		var m:Int = Std.int(max - min);
		var v:Float = ypos - minY;
		var newValue:Float = max - ((v / ucy) * m);
		pos = newValue;
	}
}