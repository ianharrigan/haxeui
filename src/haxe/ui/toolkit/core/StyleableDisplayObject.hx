package haxe.ui.toolkit.core;

import openfl.geom.Rectangle;
import haxe.ds.StringMap;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.core.interfaces.ILayout;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.interfaces.IStyleableDisplayObject;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleHelper;
import haxe.ui.toolkit.style.StyleManager;

class StyleableDisplayObject extends DisplayObjectContainer implements IStyleableDisplayObject implements IClonable<StyleableDisplayObject>  {
	private var _baseStyle:Style;
	private var _storedStyles:StringMap<Style>; // styles stored for ease later
	private var _styleName:String;
	private var _inlineStyle:Style;
	
	private var _lazyLoadStyles:Bool = true;
	
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overridables
	//******************************************************************************************
	private override function preInitialize():Void {
		super.preInitialize();
		refreshStyle();
	}
	
	public override function paint():Void {
		//super.paint(); // no point in clearing twice
		if (_width == 0 || _height == 0 || _ready == false) { // can happen
			return;
		}
		
		var rc:Rectangle = new Rectangle(0, 0, _width, _height); // doesnt like 0 widths/heights
		StyleHelper.paintStyle(graphics, _baseStyle, rc);
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
			if (_lazyLoadStyles == false) {
				buildStyles();
			} else {
				clearStyles();
			}
			_baseStyle = StyleManager.instance.buildStyleFor(this);
			invalidate(InvalidationFlag.DISPLAY);
		}
		return v;
	}
	
	private override function set_layout(value:ILayout):ILayout {
		value = super.set_layout(value);
		if (_baseStyle != null) { // better way/place to do this
			// set layout props from style
			if (layout != null) {
				if (_baseStyle.paddingLeft != -1) {
					layout.padding.left = _baseStyle.paddingLeft;
				}
				if (_baseStyle.paddingTop != -1) {
					layout.padding.top = _baseStyle.paddingTop;
				}
				if (_baseStyle.paddingRight != -1) {
					layout.padding.right = _baseStyle.paddingRight;
				}
				if (_baseStyle.paddingBottom != -1) {
					layout.padding.bottom = _baseStyle.paddingBottom;
				}
				if (_baseStyle.spacingX != -1) {
					_layout.spacingX = _baseStyle.spacingX;
				}
				if (_baseStyle.spacingY != -1) {
					_layout.spacingY = _baseStyle.spacingY;
				}
			}
		}
		return value;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	public var baseStyle(get, set):Style;
	@:clonable
	public var styleName(get, set):String;
	public var style(get, set):Style;
	
	private function get_baseStyle():Style {
		if (_baseStyle == null) {
			_baseStyle = new Style();
			_baseStyle.target = this;
		}
		return _baseStyle;
	}
	
	private function set_baseStyle(value:Style):Style {
		_baseStyle = value;
		_baseStyle.target = this;
		//applyStyle();
		return value;
	}
	
	private function get_styleName():String {
		return _styleName;
	}
	
	private function set_styleName(value:String):String {
		_styleName = value;
		if (_ready) {
			if (_lazyLoadStyles == false) {
				buildStyles();
			} else {
				clearStyles();
			}
			_baseStyle = StyleManager.instance.buildStyleFor(this);
			invalidate(InvalidationFlag.DISPLAY);
		}
		return value;
	}

	private function get_style():Style {
		if (_inlineStyle == null) {
			_inlineStyle = new Style();
			_inlineStyle.target = this;
		}
		return _inlineStyle;
	}
	
	private function set_style(value:Style):Style {
		_inlineStyle = value;
		if (_inlineStyle != null) {
			_inlineStyle.target = this;
		}
		if (_ready) {
			if (_lazyLoadStyles == false) {
				buildStyles();
			} else {
				clearStyles();
			}
			_baseStyle = StyleManager.instance.buildStyleFor(this);
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
		var style:Style = null;
		
		if (_lazyLoadStyles == false) {
			if (_storedStyles == null) {
				return null;
			}
			style = _storedStyles.get(id);
		} else {
			if (_ready) {
				style = StyleManager.instance.buildStyleFor(this, id);
			}
		}
		
		return style;
	}
	
	public function applyStyle():Void {
		if (_baseStyle == null) {
			return;
		}
		
		if (_inlineStyle != null) {
			_baseStyle.merge(_inlineStyle);
		}
		if (_baseStyle != null) {
			if (_baseStyle.alpha != -1) {
				_sprite.alpha = _baseStyle.alpha;
			} else {
				_sprite.alpha = 1;
			}
			
			if (_baseStyle.horizontalAlignment != null) {
				this.horizontalAlign = _baseStyle.horizontalAlignment;
			}
			if (_baseStyle.verticalAlignment != null) {
				this.verticalAlign = _baseStyle.verticalAlignment;
			}
			
			#if !html5
			if (_baseStyle.filter != null) {
				_sprite.filters = [_baseStyle.filter];
			} else {
				_sprite.filters = [];
			}
			#end
		}
		
		invalidate(InvalidationFlag.DISPLAY);
	}
	
	private function buildStyles():Void {
		
	}
	
	private function clearStyles():Void {
		_storedStyles = new StringMap<Style>();
	}
	
	private function refreshStyle():Void {
		Macros.beginProfile();
		if (_lazyLoadStyles == false) {
			buildStyles();
		}
		if (Std.is(this, StateComponent)) {
			var state:String = cast(this, StateComponent).state;
			if (state == null) {
				state = "normal";
			}
			_baseStyle = retrieveStyle(state);//StyleManager.instance.buildStyleFor(this, cast(this, StateComponent).state);
			if (_baseStyle == null) {
				_baseStyle = StyleManager.instance.buildStyleFor(this, cast(this, StateComponent).state);
			}
		} else {
			_baseStyle = StyleManager.instance.buildStyleFor(this);
		}
		
		_baseStyle.merge(_inlineStyle);
		
		if (_baseStyle != null) {
			// get props from style if they exist
			if (_baseStyle.width != -1 && width == 0) {
				width = _baseStyle.width;
			}
			if (_baseStyle.height != -1 && height == 0) {
				height = _baseStyle.height;
			}

			if (_baseStyle.percentWidth != -1 && percentWidth == -1) {
				percentWidth = _baseStyle.percentWidth;
			}
			if (_baseStyle.percentHeight != -1 && percentHeight == -1) {
				percentHeight = _baseStyle.percentHeight;
			}
			if (_baseStyle.autoSizeSet) {
				autoSize = _baseStyle.autoSize;
			}
			
			// set layout props from style
			if (layout != null) {
				if (_baseStyle.paddingLeft != -1) {
					layout.padding.left = _baseStyle.paddingLeft;
				}
				if (_baseStyle.paddingTop != -1) {
					layout.padding.top = _baseStyle.paddingTop;
				}
				if (_baseStyle.paddingRight != -1) {
					layout.padding.right = _baseStyle.paddingRight;
				}
				if (_baseStyle.paddingBottom != -1) {
					layout.padding.bottom = _baseStyle.paddingBottom;
				}
				if (_baseStyle.spacingX != -1) {
					_layout.spacingX = _baseStyle.spacingX;
				}
				if (_baseStyle.spacingY != -1) {
					_layout.spacingY = _baseStyle.spacingY;
				}
			}
		}
		
		applyStyle();
		Macros.endProfile();
	}
}