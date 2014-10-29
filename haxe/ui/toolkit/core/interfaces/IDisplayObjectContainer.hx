package haxe.ui.toolkit.core.interfaces;

interface IDisplayObjectContainer extends IDisplayObject { // as display object but with children & layouts
	public var numChildren(get, null):Int;
	public var children(get, null):Array<IDisplayObject>;
	
	public function indexOfChild(child:IDisplayObject):Int;
	public function getChildAt(index:Int):IDisplayObject;
	
	public function addChildAt(child:IDisplayObject, index:Int):IDisplayObject;
	public function addChild(child:IDisplayObject):IDisplayObject;
	public function removeChild(child:IDisplayObject, dispose:Bool = true):IDisplayObject;
	public function removeChildAt(index:Int, dispose:Bool = true):IDisplayObject;
	public function findChild<T>(id:String, type:Class<T> = null, recursive:Bool = false):Null<T>;
	public function findChildAs<T>(type:Class<T>):Null<T>;
	public function removeAllChildren(dispose:Bool = true):Void;
	public function contains(child:IDisplayObject):Bool;
	public function setChildIndex(child:IDisplayObject, index:Int):Void;
	
	public var layout(get, set):ILayout;
	
	public var autoSize(get, set):Bool;
}