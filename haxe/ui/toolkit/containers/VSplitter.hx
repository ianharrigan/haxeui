package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.events.UIEvent;
import openfl.events.MouseEvent;

class VSplitter extends VBox implements IClonable<VSplitter> {
	private var _gripper:VSplitterGripper;
	private var _percents:Map<IDisplayObject, Float>;
	private var _mouseDownOffset:Float;
	
	public function new() {
		super();
	}
	
	public override function addChild(child:IDisplayObject):IDisplayObject {
		var r = null;
		if (Std.is(child, VSplitterGripper)) {
			r = super.addChild(child);
		} else {
			if (numChildren > 0) {
				var gripper:VSplitterGripper = new VSplitterGripper();
				gripper.addEventListener(UIEvent.MOUSE_DOWN, _onMouseDown);
				addChild(gripper);
			}
			r = super.addChild(child);
		}
		return r;
	}
	
	public override function addChildAt(child:IDisplayObject, index:Int):IDisplayObject {
		var r = null;
		if (Std.is(child, VSplitterGripper)) {
			r = super.addChildAt(child, index);
		} else {
			if (numChildren > 0) {
				var gripper:VSplitterGripper = new VSplitterGripper();
				gripper.addEventListener(UIEvent.MOUSE_DOWN, _onMouseDown);
				addChildAt(gripper, index);
			}
			r = super.addChildAt(child, index + 1);
		}
		return r;
	}
	
	public override function removeChild(child:IDisplayObject, dispose:Bool = true):IDisplayObject {
		var r = null;
		if (Std.is(child, VSplitterGripper)) {
			r = super.removeChild(child, dispose);
		} else {
			if (numChildren > 1) {
				removeChild(getChildAt(indexOfChild(child) - 1), dispose);
			}
			r = super.removeChild(child, dispose);
		}
		return r;
	}
	
	private function _onMouseDown(event:UIEvent):Void {
		_percents = new Map<IDisplayObject, Float>();
		_gripper = cast event.component;
		_mouseDownOffset = event.stageY - _gripper.y;
		
		_invalidating = true;
		for (c in children) {
			if (Std.is(c, VSplitterGripper) == false) {
				if (c.percentHeight != -1) {
					_percents.set(c, c.percentHeight);
					c.percentHeight = -1;
				}
			}
		}
		_invalidating = false;
		invalidate(InvalidationFlag.LAYOUT);
		
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function _onMouseMove(event:MouseEvent):Void {
		if (_gripper != null) {
			var delta:Float = event.stageY - _gripper.y - _mouseDownOffset;
		
			var index:Int = indexOfChild(_gripper);
			var before:Component = cast getChildAt(index - 1);
			var after:Component = cast getChildAt(index + 1);
			
			var newBefore:Float = before.height + delta;
			var newAfter:Float = after.height - delta;
			if (newBefore > before.minHeight && newAfter > after.minHeight
				&& newBefore - (before.layout.padding.top + before.layout.padding.bottom) > 0
				&& newAfter - (after.layout.padding.top + after.layout.padding.bottom) > 0) {
				before.height = newBefore;
				after.height = newAfter;
			}
		}
	}
	
	private function _onMouseUp(event:MouseEvent):Void {
		Screen.instance.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		_gripper = null;
		
		var ucy:Float = this.height;
		ucy -= ((numChildren - 1) / 2) * (2 * layout.spacingY);
		for (c in children) {
			if (_percents.exists(c) == false) {
				ucy -= c.height;
			}
		}
		
		
		_invalidating = true;
		for (c in _percents.keys()) {
			var newPercent:Float = (c.height / ucy) * 100;
			c.percentHeight = newPercent;
		}
		_invalidating = false;
		invalidate(InvalidationFlag.LAYOUT);
		_percents = null;
	}
}

@:dox(hide)
class VSplitterGripper extends Button {
	public function new() {
		super();
		remainPressed = true;
		useHandCursor = true;
	}
}