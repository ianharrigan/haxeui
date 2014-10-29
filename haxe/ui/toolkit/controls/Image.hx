package haxe.ui.toolkit.controls;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.resources.ResourceManager;

/**
 General purpose image control
 **/
class Image extends Component implements IClonable<Image> {
	private var _bmp:Bitmap;
	private var _resource:Dynamic;
	private var _stretch:Bool;
	private var _autoDisposeBitmapData:Bool = false;
	
	public function new() {
		super();
		autoSize = true;
	}
	
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();
		
		if (_bmp != null) {
			sprite.addChild(_bmp);
			if (this.height > _bmp.height) {
				_bmp.y = Std.int((this.height / 2) - (_bmp.height / 2));
			}
		}
	}
	
	/**
	 Destroy the image and free the resources (will be called by the framework automatically)
	 **/
	public override function dispose():Void {
		if (_bmp != null) {
			if (_autoDisposeBitmapData == true) {
				_bmp.bitmapData.dispose();
			}
			sprite.removeChild(_bmp);
			_bmp = null;
		}
		super.dispose();
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		super.invalidate(type, recursive);
		
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE) {
			if (_stretch && _bmp != null) {
				_bmp.width = width;
				_bmp.height = height;
			}
		}
	}
	
	private override function get_value():Dynamic {
		return resource;
	}
	
	private override function set_value(newValue:Dynamic):Dynamic {
		resource = newValue;
		return newValue;
	}
	
	//******************************************************************************************
	// Methods/props
	//******************************************************************************************
	/**
	 The resource asset for this image: eg `assets/myimage.jpeg`
	 **/
	@:clonable
	public var resource(get, set):Dynamic;
	@:clonable
	public var stretch(get, set):Bool;
	@:clonable
	public var autoDisposeBitmapData(get, set):Bool;
	
	private function get_resource():Dynamic {
		return _resource;
	}
	
	private function set_resource(value:Dynamic):Dynamic {
		if (_bmp != null) {
			if (_autoDisposeBitmapData == true) {
				_bmp.bitmapData.dispose();
			}
			sprite.removeChild(_bmp);
			_bmp = null;
		}
		
		var bmpData:BitmapData = null;
		if (Std.is(value, String)) {
			bmpData = ResourceManager.instance.getBitmapData(cast(value, String));
		} else if (Std.is(value, Bitmap)) {
			bmpData = cast(value, Bitmap).bitmapData;
		} else if (Std.is(value, BitmapData)) {
			bmpData = cast(value, BitmapData);
		}
		
		if (bmpData != null) {
			_bmp = new Bitmap(bmpData);
			sprite.addChild(_bmp);
			if (autoSize == true) {
				this.width = bmpData.width;
				this.height = bmpData.height;
			}
		}
		
		_resource = value;
		return value;
	}
	
	private function get_stretch():Bool {
		return _stretch;
	}
	
	private function set_stretch(value:Bool):Bool {
		if (_stretch == value) {
			return value;
		}
		_stretch = value;
		invalidate(InvalidationFlag.SIZE);
		return value;
	}
	
	private function get_autoDisposeBitmapData():Bool {
		return _autoDisposeBitmapData;
	}
	
	private function set_autoDisposeBitmapData(value:Bool):Bool {
		_autoDisposeBitmapData = value;
		return value;
	}
}