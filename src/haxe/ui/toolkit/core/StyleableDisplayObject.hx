package haxe.ui.toolkit.core;

import flash.filters.BitmapFilter;
import flash.geom.Rectangle;
import haxe.ds.StringMap;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IStyleableDisplayObject;
import haxe.ui.toolkit.layout.GridLayout;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleHelper;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.util.FilterParser;

class StyleableDisplayObject extends DisplayObjectContainer implements IStyleableDisplayObject implements IClonable<StyleableDisplayObject>  {
	private var _style:Style;
	private var _storedStyles:StringMap<Style>; // styles stored for ease later
	private var _styleName:String;
	private var _inlineStyle:Style;
	private var _setStyle:Style;
	
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overridables
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		_setStyle = _style;
		refreshStyle();
		_style.merge(_setStyle);
	}
	
	public override function paint():Void {
		//super.paint(); // no point in clearing twice
		if (_width == 0 || _height == 0) { // can happen
			return;
		}
		
		var rc:Rectangle = new Rectangle(0, 0, _width, _height); // doesnt like 0 widths/heights
		StyleHelper.paintStyle(graphics, style, rc);
	}
	
	public override function invalidate(type:Int = InvalidationFlag.ALL, recursive:Bool = false):Void {
		if (!_ready || _invalidating) {
			return;
		}
		
		super.invalidate(type, recursive);
		if (type & InvalidationFlag.STYLE == InvalidationFlag.STYLE) {
			refreshStyle();
		}
	}
	
	private override function set_id(value:String):String { // if id changes, rebuild styles
		if (value == id) {
			return value;
		}
		var v:String = super.set_id(value);
		if (_ready) {
			buildStyles();
			_style = StyleManager.instance.buildStyleFor(this);
			_style.merge(_setStyle);
			invalidate(InvalidationFlag.DISPLAY);
		}
		return v;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	public var style(get, set):Style;
	@:clonable
	public var styleName(get, set):String;
	public var inlineStyle(get, set):Style;
	
	private function get_style():Style {
		if (_style == null) {
			_style = new Style();
		}
		return _style;
	}
	
	private function set_style(value:Style):Style {
		_style = value;
		_style.target = this;
		//applyStyle();
		return value;
	}
	
	private function get_styleName():String {
		return _styleName;
	}
	
	private function set_styleName(value:String):String {
		_styleName = value;
		if (_ready) {
			buildStyles();
			_style = StyleManager.instance.buildStyleFor(this);
			_style.merge(_setStyle);
			invalidate(InvalidationFlag.DISPLAY);
		}
		return value;
	}

	private function get_inlineStyle():Style {
		if (_inlineStyle == null) {
			_inlineStyle = new Style();
		}
		return _inlineStyle;
	}
	
	private function set_inlineStyle(value:Style):Style {
		_inlineStyle = value;
		if (_inlineStyle != null) {
			_inlineStyle.target = this;
		}
		if (_ready) {
			buildStyles();
			_style = StyleManager.instance.buildStyleFor(this);
			_style.merge(_setStyle);
			invalidate(InvalidationFlag.DISPLAY);
		}
		return value;
	}
	
	public function storeStyle(id:String, value:Style):Void {
		if (_storedStyles == null) {
			_storedStyles = new StringMap<Style>();
		}
		_storedStyles.set(id, value);
	}
	
	public function retrieveStyle(id:String):Style {
		if (_storedStyles == null) {
			return null;
		}
		return _storedStyles.get(id);
	}
	
	public function applyStyle():Void {
		if (_style == null) {
			return;
		}
		
		if (_inlineStyle != null) {
			_style.merge(_inlineStyle);
		}
		if (_style != null) {
			if (_style.alpha != -1) {
				_sprite.alpha = _style.alpha;
			} else {
				_sprite.alpha = 1;
			}
			
			#if !html5
			if (_style.filter != null) {
				_sprite.filters = [_style.filter];
			} else {
				_sprite.filters = [];
			}
			#end
		}
		
		invalidate(InvalidationFlag.DISPLAY);
	}
	
	private function buildStyles():Void {
		
	}
	
	private function refreshStyle():Void {
		//_setStyle = _style;
		buildStyles();
		if (Std.is(this, StateComponent)) {
			var state:String = cast(this, StateComponent).state;
			if (state == null) {
				state = "normal";
			}
			_style = retrieveStyle(state);//StyleManager.instance.buildStyleFor(this, cast(this, StateComponent).state);
			if (_style == null) {
				_style = StyleManager.instance.buildStyleFor(this, cast(this, StateComponent).state);
			}
		} else {
			_style = StyleManager.instance.buildStyleFor(this);
		}
		
		_style.merge(_inlineStyle);
		//_style.merge(_setStyle);
		
		if (_style != null) {
			// get props from style if they exist
			if (_style.width != -1 && width == 0) {
				width = _style.width;
			}
			if (_style.height != -1 && height == 0) {
				height = _style.height;
			}

			if (_style.percentWidth != -1 && percentWidth == -1) {
				percentWidth = _style.percentWidth;
			}
			if (_style.percentHeight != -1 && percentHeight == -1) {
				percentHeight = _style.percentHeight;
			}
			if (_style.autoSizeSet) {
				autoSize = _style.autoSize;
			}
			
			// set layout props from style
			if (layout != null) {
				if (_style.paddingLeft != -1) {
					layout.padding.left = _style.paddingLeft;
				}
				if (_style.paddingTop != -1) {
					layout.padding.top = _style.paddingTop;
				}
				if (_style.paddingRight != -1) {
					layout.padding.right = _style.paddingRight;
				}
				if (_style.paddingBottom != -1) {
					layout.padding.bottom = _style.paddingBottom;
				}
				if (_style.spacingX != -1) {
					_layout.spacingX = _style.spacingX;
				}
				if (_style.spacingY != -1) {
					_layout.spacingY = _style.spacingY;
				}
			}
		}
		
		applyStyle();
	}
}