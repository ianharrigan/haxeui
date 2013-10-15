package haxe.ui.toolkit.core;

import flash.display.Sprite;
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.interfaces.ILayout;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.layout.DefaultLayout;

import haxe.CallStack;

class DisplayObjectContainer extends DisplayObject implements IDisplayObjectContainer {
	private var _children:Array<IDisplayObject>;
	
	// used in IDisplayObjectContainer getters/setters
	private var _layout:ILayout;
	private var _autoSize:Bool = false; // by default we dont want components to size themselves based on their contents, we want it the other way round
	
	public function new() {
		super();
		_layout = new DefaultLayout();
		_children = new Array<IDisplayObject>();
	}

	//******************************************************************************************
	// Overridables
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		_layout.container = this;
		
		#if html5
		if (_childrenToAdd != null) {
			for (child in _childrenToAdd) {
				addChild(child);
			}
			_childrenToAdd = null;
		}
		#end
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL):Void {
		super.invalidate();
		if (!_ready) {
			return;
		}

		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE
			|| type & InvalidationFlag.LAYOUT == InvalidationFlag.LAYOUT) {
			_layout.refresh();
		}
	}
	
	//******************************************************************************************
	// IDisplayObjectContainer
	//******************************************************************************************
	public var numChildren(get, null):Int;
	public var layout(get, set):ILayout;
	public var children(get, null):Array<IDisplayObject>;
	public var autoSize(get, set):Bool;
	
	private function get_numChildren():Int {
		return _children.length;
	}
	
	private function get_children():Array<IDisplayObject> {
		return _children;
	}
	
	public function indexOfChild(child:IDisplayObject):Int {
		var index:Int = std.Lambda.indexOf(_children, child);
		return index;
	}
	
	public function getChildAt(index:Int):IDisplayObject {
		return _children[index];
	}
	
	#if html5
	private var _childrenToAdd:Array<IDisplayObject>;
	#end
	
	public function addChildAt(child:IDisplayObject, index:Int):IDisplayObject {
		if (child == null) {
			return null;
		}
		
		#if html5
		if (_ready == false) {
			if (_childrenToAdd == null) {
				_childrenToAdd = new Array<IDisplayObject>();
			}
			_childrenToAdd.insert(index, child);
			return child;
		}
		#end
		
		var childSprite:Sprite = child.sprite;
		
		if (Std.is(child, IDisplayObjectContainer)) {
			cast(child, IDisplayObjectContainer).parent = this;
		}
		
		child.root = root;
		_children.insert(index, child);		
		_sprite.addChildAt(childSprite, index);
		invalidate(InvalidationFlag.LAYOUT);
		return child;
	}
	
	public function addChild(child:IDisplayObject):IDisplayObject {
		if (child == null) {
			return null;
		}
		
		#if html5
		if (_ready == false) {
			if (_childrenToAdd == null) {
				_childrenToAdd = new Array<IDisplayObject>();
			}
			_childrenToAdd.push(child);
			return child;
		}
		#end
		
		var childSprite:Sprite = child.sprite;
		
		if (Std.is(child, IDisplayObjectContainer)) {
			cast(child, IDisplayObjectContainer).parent = this;
		}
		
		child.root = root;
		_children.push(child);		
		_sprite.addChild(childSprite);
		invalidate(InvalidationFlag.LAYOUT);
		return child;
	}
	
	public function removeChild(child:IDisplayObject, dispose:Bool = true):IDisplayObject {
		if (child == null) {
			return null;
		}
		
		var childSprite:Sprite = child.sprite;
		if (_sprite.contains(childSprite)) {
			_sprite.removeChild(childSprite);
			_children.remove(child);
			if (dispose == true) {
				child.dispose();
			}
			invalidate(InvalidationFlag.LAYOUT);
		}
		return child;
	}
	
	public function removeAllChildren():Void {
		while (_children.length > 0) {
			var child:IDisplayObject = _children[0];
			removeChild(child);
		}
	}
	
	public function findChildAs<T>(type:Class<T>):Null<T> {
		var match:Component = null;
		for (child in children) {
			if (Std.is(child, type)) {
				match = cast child;
				break;
			}
		}
		return cast match;
	}
	
	public function findChild<T>(id:String, type:Class<T> = null):Null<T> {
		var match:Component = null;
		for (child in children) {
			if (child.id == id) {
				match = cast child;
				break;
			}
		}
		return cast match;
	}
	
	private function get_layout():ILayout {
		return _layout;
	}
	
	private function set_layout(value:ILayout):ILayout {
		_layout = value;
		_layout.container = this;
		return value;
	}
	
	// if autoSize is true then components will resize themselves based on child components and the layout
	private function get_autoSize():Bool {
		return _autoSize;
	}
	
	private function set_autoSize(value:Bool):Bool {
		_autoSize = value;
		return _autoSize;
	}
	
	//******************************************************************************************
	// IDisplayObject
	//******************************************************************************************
	public override function dispose():Void {
		for (child in children) {
			try {
				removeChild(child);
			} catch (e:Dynamic) {
				var stack:Array<haxe.StackItem> = CallStack.exceptionStack();
				trace("Problem removing component: " + this + ", " + child + "(" + e + "), callstack:");
				trace(CallStack.toString(stack));
			}
		}
		super.dispose();
	}

	private override function set_root(value:Root):Root {
		super.set_root(value);
		for (child in children) {
			child.root = value;
		}
		return value;
	}
	
}