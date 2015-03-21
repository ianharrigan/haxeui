package haxe.ui.toolkit.controls;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.resources.ResourceManager;
import openfl.display.Sprite;

#if yagp
import com.yagp.GifDecoder;
import com.yagp.Gif;
import com.yagp.GifPlayer;
import com.yagp.GifPlayerWrapper;
import com.yagp.GifRenderer;
#end

#if svg
import format.SVG;
#end

/**
 General purpose image control
 **/
class Image extends Component implements IClonable<Image> {
	private var _bmp:Bitmap;
	private var _resource:Dynamic;
	private var _stretch:Bool;
	private var _autoDisposeBitmapData:Bool = false;
	
	#if yagp
	private var _gifWrapper:GifPlayerWrapper;
	#end
	
	#if svg
	private var _svgSprite:Sprite;
	#end
	
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
			//sprite.addChild(_bmp);
			if (this.height > _bmp.height) {
				//_bmp.y = Std.int((this.height / 2) - (_bmp.height / 2));
			}
			
			if (autoSize == true) {
				this.width = _bmp.bitmapData.width;
				this.height = _bmp.bitmapData.height;
			}
		}
		
		#if yagp
		if (_gifWrapper != null && autoSize == true) {
			this.width = _gifWrapper.width;
			this.height = _gifWrapper.height;
		}
		#end

		#if svg
		if (_svgSprite != null && autoSize == true) {
			this.width = _svgSprite.width;
			this.height = _svgSprite.height;
		}
		#end
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
		
		#if yagp
		if (_gifWrapper != null && sprite.contains(_gifWrapper)) {
			_gifWrapper.dispose();
			sprite.removeChild(_gifWrapper);
		}
		#end
		
		#if svg
		if (_svgSprite != null && sprite.contains(_svgSprite)) {
			sprite.removeChild(_svgSprite);
		}
		#end
		
		super.dispose();
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		super.invalidate(type, recursive);
		
		if (type & InvalidationFlag.SIZE == InvalidationFlag.SIZE) {
			if (_stretch && _bmp != null) {
				_bmp.width = width;
				_bmp.height = height;
			}
			#if yagp
			if (_stretch && _gifWrapper != null && sprite.contains(_gifWrapper)) {
				_gifWrapper.width = width;
				_gifWrapper.height = height;
			}
			#end
			#if svg
			if (_stretch && _svgSprite != null && sprite.contains(_svgSprite)) {
				_svgSprite.width = width;
				_svgSprite.height = height;
			}
			#end
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
		
		#if yagp
		if (_gifWrapper != null && sprite.contains(_gifWrapper)) {
			_gifWrapper.dispose();
			sprite.removeChild(_gifWrapper);
		}
		#end
		
		#if svg
		if (_svgSprite != null && sprite.contains(_svgSprite)) {
			sprite.removeChild(_svgSprite);
		}
		#end
		
		var bmpData:BitmapData = null;
		if (Std.is(value, String)) {
			var res:String = value;
			if (StringTools.endsWith(res, ".gif")) {
				#if yagp
					var gif:Gif = GifDecoder.parseByteArray(ResourceManager.instance.getBytes(res));
					var player:GifPlayer = new GifPlayer(gif);
					_gifWrapper = new GifPlayerWrapper(player);
					sprite.addChild(_gifWrapper);
					if (autoSize == true && ready) {
						this.width = _gifWrapper.width;
						this.height = _gifWrapper.height;
					}
				#else
					trace("YAGP lib not found for .gif decoding");
				#end
			} else if (StringTools.endsWith(res, ".svg")) {
				#if svg
					var svg:SVG = ResourceManager.instance.getSVG(res);
					_svgSprite = new Sprite();
					//bmpData = new BitmapData(cast svg.data.width, cast svg.data.width);
					//_bmp = new Bitmap(bmpData);
					svg.render(_svgSprite.graphics);
					_svgSprite.width = svg.data.width;
					_svgSprite.height = svg.data.height;
					sprite.addChild(_svgSprite);
					if (autoSize == true && ready) {
						this.width = _svgSprite.width;
						this.height = _svgSprite.height;
					}
				#end
			} else {
				bmpData = ResourceManager.instance.getBitmapData(res);
			}
		} else if (Std.is(value, Bitmap)) {
			bmpData = cast(value, Bitmap).bitmapData;
		} else if (Std.is(value, BitmapData)) {
			bmpData = cast(value, BitmapData);
		}
		
		if (bmpData != null) {
			if (_bmp == null) {
				_bmp = new Bitmap(bmpData);
			}
			sprite.addChild(_bmp);
			if (autoSize == true && ready) {
				this.width = _bmp.bitmapData.width;
				this.height = _bmp.bitmapData.height;
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
		_autoSize = !value;
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