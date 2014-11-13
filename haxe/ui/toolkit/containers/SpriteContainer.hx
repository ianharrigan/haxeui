package haxe.ui.toolkit.containers;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import openfl.display.Sprite;
import haxe.ui.toolkit.core.interfaces.IClonable;

class SpriteContainer extends Component implements IClonable<SpriteContainer> {
	private var _childSprite:Sprite;
	private var _spriteClass:String;
	private var _stretch:Bool;
	
	public function new(childSprite:Sprite = null) {
		super();
		this.childSprite = childSprite;
		autoSize = true;
	}
	
	private override function initialize():Void {
		super.initialize();
		if (_childSprite != null) {
			if (autoSize == true) {
				_childSprite.x = layout.padding.left;
				_childSprite.y = layout.padding.top;
				this.width = _childSprite.width + (layout.padding.left + layout.padding.right);
				this.height = _childSprite.height + (layout.padding.top + layout.padding.bottom);
			}
		}
	}
	
	public override function dispose():Void {
		if (_childSprite != null) {
			sprite.removeChild(_childSprite);
		}
		super.dispose();
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		super.invalidate(type, recursive);
		
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE) {
			if (_stretch == true && _childSprite != null) {
				_childSprite.x = layout.padding.left;
				_childSprite.y = layout.padding.top;
				_childSprite.width = this.width - (layout.padding.left + layout.padding.right);
				_childSprite.height = this.height - (layout.padding.top + layout.padding.bottom);
			}
		}
	}
	
	@:clonable
	public var childSprite(get, set):Sprite;
	private function get_childSprite():Sprite {
		return _childSprite;
	}
	
	private function set_childSprite(value:Sprite):Sprite {
		if (value == null && _childSprite != null) {
			sprite.removeChild(_childSprite);
			_childSprite = null;
		}
		if (value != _childSprite) {
			if (_childSprite != null) {
				sprite.removeChild(_childSprite);
			}
			_childSprite = value;
			sprite.addChild(_childSprite);
			if (autoSize == true && ready) {
				_childSprite.x = layout.padding.left;
				_childSprite.y = layout.padding.top;
				this.width = _childSprite.width + (layout.padding.left + layout.padding.right);
				this.height = _childSprite.height + (layout.padding.top + layout.padding.bottom);
			}
		}
		return value;
	}
	
	@:clonable
	public var spriteClass(get, set):String;
	private function get_spriteClass():String {
		return _spriteClass;
	}
	
	private function set_spriteClass(value:String):String {
		if (value == null) {
			childSprite = null;
			_spriteClass = null;
			return value;
		}
		
		if (value != _spriteClass) {
			var cls:Class<Dynamic> = Type.resolveClass(value);
			if (cls != null) {
				var inst:Sprite = Type.createInstance(cls, []);
				if (inst != null && Std.is(inst, Sprite)) {
					childSprite = inst;
					_spriteClass = value;
				}
			}
		}
		
		return value;
	}
	
	@:clonable
	public var stretch(get, set):Bool;
	private function get_stretch():Bool {
		return _stretch;
	}
	
	private function set_stretch(value:Bool):Bool {
		if (_stretch == value) {
			return value;
		}
		_autoSize = !value;
		_stretch = value;
		invalidate(InvalidationFlag.SIZE);
		return value;
	}
}