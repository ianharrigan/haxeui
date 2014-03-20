package haxe.ui.toolkit.controls;

import flash.events.MouseEvent;
import haxe.ui.toolkit.core.interfaces.Direction;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.Screen;

/**
 Vertical slider bar control
 **/
class VSlider extends Slider implements IClonable<VSlider> {
	public function new() {
		super();
		direction = Direction.VERTICAL;
	}
	
	//******************************************************************************************
	// Event handler overrides
	//******************************************************************************************
	private override function _onMouseDown(event:MouseEvent):Void {
		startTracking(event.stageY - _thumb.stageY);
	}

	private override function _onScreenMouseMove(event:MouseEvent):Void {
		var ypos:Float = event.stageY - this.stageY - _mouseDownOffset;
		pos = Std.int(calcPosFromCoord(ypos));
	}
	
	private override function _onBackgroundMouseDown(event:MouseEvent):Void {
		if (_thumb.hitTest(event.stageX, event.stageY) == false) {
			var ypos:Float = event.stageY - this.stageY;
			ypos -= _thumb.height / 2;
			pos = Std.int(calcPosFromCoord(ypos));
			_thumb.state = Button.STATE_DOWN;
			startTracking(_thumb.height / 2);
		}
	}

	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function startTracking(offset:Float):Void {
		_mouseDownOffset = offset;
		
		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function calcPosFromCoord(ypos:Float):Float {
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
		return newValue;
	}
}