package haxe.ui.toolkit.core.interfaces;

import flash.display.Sprite;
import haxe.ui.toolkit.core.Root;

interface IDisplayObject extends IEventDispatcher extends IClonable<IDisplayObject> { // canvas/sprite
	public var parent(get, set):IDisplayObjectContainer; // null is valid
	public var root(get, set):Root;
	public var id(get, set):String;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var percentWidth(get, set):Float;
	public var percentHeight(get, set):Float;
	public var ready(get, null):Bool;
	public var sprite(get, null):Sprite; // make this private, should never access the sprite
	public var stageX(get, null):Float;
	public var stageY(get, null):Float;
	public var visible(get, set):Bool;
	
	public function hitTest(stageX:Float, stageY:Float):Bool;
	
	public function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void;
	public function dispose():Void;
	
	public var horizontalAlign(get, set):String;
	public var verticalAlign(get, set):String;
}