package haxe.ui.toolkit.controls;

import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.events.UIEvent;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.net.URLRequest;

class Link extends Text {
	/**
	 Link state is "normal" (default state)
	 **/
	public static inline var STATE_NORMAL = "normal";
	/**
	 Link state is "over"
	 **/
	public static inline var STATE_OVER = "over";
	/**
	 Link state is "down"
	 **/
	public static inline var STATE_DOWN = "down";
	
	private var _isDown:Bool = false;
	private var _isOver:Bool = false;
	
	public function new() {
		super();
		useHandCursor = true;
	}
	
	public override function initialize():Void {
		super.initialize();
		
		// need to use screen as neko/cpp doesnt receive events unless background is solid colour
		Screen.instance.addEventListener(MouseEvent.MOUSE_DOWN, _onScreenMouseDown);
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onScreenMouseMove);
	}
	
	private function _onScreenMouseDown(e:MouseEvent):Void {
		if (ensureVisible() == false) {
			return;
		}
		
		if (hitTest(e.stageX, e.stageY) == true) {
			_isDown = true;
			state = STATE_DOWN;
			Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		}
	}

	private function _onScreenMouseMove(e:MouseEvent):Void {
		if (ensureVisible() == false) {
			return;
		}
		
		if (hitTest(e.stageX, e.stageY) == true) {
			if (_isDown == true) {
				state = STATE_DOWN;
			} else {
				state = STATE_OVER;
			}
			_isOver = true;
		} else if (_isOver == true) {
			state = STATE_NORMAL;
			_isOver = false;
		}
	}
	
	private function _onScreenMouseUp(e:MouseEvent):Void {
		if (ensureVisible() == false) {
			return;
		}
		
		Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onScreenMouseUp);
		if (hitTest(e.stageX, e.stageY) == true && _isDown == true) {
			_isDown = false;
			state = STATE_OVER;
			
			#if (!flash)
			var uiEvent:UIEvent = new UIEvent(UIEvent.CLICK);
			dispatchEvent(uiEvent);
			#end
			
			if (url != null) {
				Lib.getURL(new URLRequest(url));
			}
		} else if (_isOver == false) {
			_isDown = false;
			state = STATE_NORMAL;
		}
	}
	
	public var url(default, default):String;
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	private override function get_states():Array<String> {
		return [STATE_NORMAL, STATE_OVER, STATE_DOWN];
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	private function ensureVisible():Bool {
		if (visible == false) {
			return false;
		}
		var p = parent;
		while (p != null) {
			if  (p.visible == false) {
				return false;
			}
			p = p.parent;
		}
		
		return true;
	}
	
}