package haxe.ui.toolkit.layout;

import flash.geom.Rectangle;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.ILayout;

class Layout implements ILayout {
	private var _container:IDisplayObjectContainer;
	private var _padding:Rectangle;
	private var _spacingX:Int = 0;
	private var _spacingY:Int = 0;
	
	public function new() {
		_padding = new Rectangle();
	}
	
	//******************************************************************************************
	// ILayout
	//******************************************************************************************
	public var container(get, set):IDisplayObjectContainer;
	public var padding(get, set):Rectangle;  
	public var spacingX(get, set):Int;
	public var spacingY(get, set):Int;
	
	private function get_container():IDisplayObjectContainer {
		return _container;
	}
	
	private function set_container(value:IDisplayObjectContainer):IDisplayObjectContainer {
		_container = value;
		refresh();
		return value;
	}
	
	private function get_padding():Rectangle {
		return _padding;
	}
	
	private function set_padding(value:Rectangle):Rectangle {
		_padding = value;
		refresh();
		return value;
	}
	
	private function get_spacingX():Int {
		return _spacingX;
	}
	
	private function set_spacingX(value:Int):Int {
		_spacingX = value;
		refresh();
		return value;
	}
	
	private function get_spacingY():Int {
		return _spacingY;
	}
	
	private function set_spacingY(value:Int):Int {
		_spacingY = value;
		refresh();
		return value;
	}
	
	public function refresh():Void {
		if (container != null && container.ready) {
			resizeChildren();
			repositionChildren();
		}
	}
	
	private function resizeChildren():Void {
	}
	
	private function repositionChildren():Void {
	}

	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public var innerWidth(get, null):Float;
	public var innerHeight(get, null):Float;
	public var usableWidth(get, null):Float;
	public var usableHeight(get, null):Float;
	
	// Inner width returns the size of the component minus padding
	private function get_innerWidth():Float {
		var icx:Float = container.width - (padding.left + padding.right);
		return icx;
	}
	
	// Inner height returns the size of the component minus padding
	private function get_innerHeight():Float {
		var icy:Float = container.height - (padding.top + padding.bottom);
		return icy;
	}
	
	// usable width returns the amount of available space for % size components 
	private function get_usableWidth():Float {
		var ucx:Float = innerWidth;
		return ucx;
	}
	
	// usable height returns the amount of available space for % size components 
	private function get_usableHeight():Float {
		var ucy:Float = innerHeight;
		return ucy;
	}
}