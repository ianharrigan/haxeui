package haxe.ui.toolkit.core;

import flash.filters.BitmapFilter;
import flash.geom.Rectangle;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IStyleable;
import haxe.ui.toolkit.layout.GridLayout;
import haxe.ui.toolkit.style.StyleHelper;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.util.FilterParser;

class StyleableDisplayObject extends DisplayObjectContainer implements IStyleable  {
	private var _style:Dynamic;
	private var _storedStyles:Hash<Dynamic>; // styles stored for ease later
	
	private var _currentFilterString:String = null;
	
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overridables
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();

		buildStyles();
		if (Std.is(this, StateComponent)) {
			_style = StyleManager.instance.buildStyleFor(this, cast(this, StateComponent).state);
		} else {
			_style = StyleManager.instance.buildStyleFor(this);
		}
		
		if (_style != null) {
			// get props from style if they exist
			if (_style.width != null && width == 0) {
				width = _style.width;
			}
			if (_style.height != null && height == 0) {
				height = _style.height;
			}

			if (_style.percentWidth != null && percentWidth == -1) {
				percentWidth = _style.percentWidth;
			}
			if (_style.percentHeight != null && percentHeight == -1) {
				percentHeight = _style.percentHeight;
			}
			
			// set layout props from style
			if (layout != null) {
				if (_style.paddingLeft != null) {
					layout.padding.left = _style.paddingLeft;
				}
				if (_style.paddingTop != null) {
					layout.padding.top = _style.paddingTop;
				}
				if (_style.paddingRight != null) {
					layout.padding.right = _style.paddingRight;
				}
				if (_style.paddingBottom != null) {
					layout.padding.bottom = _style.paddingBottom;
				}
				
				for (field in Reflect.fields(_style)) {
					if (Reflect.field(_layout, "set_" + field) != null) {
						Reflect.setProperty(_layout, field, Reflect.field(_style, field));
					}
				}
			}
		}
		
		applyStyle();
	}
	
	public override function paint():Void {
		//super.paint(); // no point in clearing twice
		if (_width == 0 || _height == 0) { // can happen
			return;
		}
		
		var rc:Rectangle = new Rectangle(0, 0, _width, _height); // doesnt like 0 widths/heights
		StyleHelper.paintStyle(graphics, style, rc);
	}
	
	
	private override function set_id(value:String):String { // if id changes, rebuild styles
		var v:String = super.set_id(value);
		buildStyles();
		_style = StyleManager.instance.buildStyleFor(this);
		invalidate(InvalidationFlag.DISPLAY);
		return v;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	public var style(get, set):Dynamic;
	
	private function get_style():Dynamic {
		return _style;
	}
	
	private function set_style(value:Dynamic):Dynamic {
		_style = value;
		applyStyle();
		return value;
	}
	
	public function storeStyle(id:String, value:Dynamic):Void {
		if (_storedStyles == null) {
			_storedStyles = new Hash<Dynamic>();
		}
		_storedStyles.set(id, value);
	}
	
	public function retrieveStyle(id:String):Dynamic {
		if (_storedStyles == null) {
			return null;
		}
		return _storedStyles.get(id);
	}
	
	private function applyStyle():Void {
		if (_style.alpha != null) {
			_sprite.alpha = _style.alpha;
		} else {
			_sprite.alpha = 1;
		}
		
		if (_style.filter != null) {
			if (_currentFilterString != _style.filter) {
				var filter:BitmapFilter = FilterParser.parseFilter(_style.filter);
				if (filter != null) {
					_sprite.filters = [filter];
				} else {
					_sprite.filters = [];
				}
				_currentFilterString = _style.filter;
			}
		} else {
			_sprite.filters = [];
			_currentFilterString = null;
		}
		
		invalidate(InvalidationFlag.DISPLAY);
	}
	
	public function buildStyles():Void {
		
	}
}