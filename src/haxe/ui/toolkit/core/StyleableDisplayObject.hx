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
	private var _mainStyle:Style;
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
		StyleHelper.paintStyle(graphics, mainStyle, rc);
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
			_mainStyle = StyleManager.instance.buildStyleFor(this);
			invalidate(InvalidationFlag.DISPLAY);
		}
		return v;
	}
	
	private override function set_layout(value:ILayout):ILayout {
		value = super.set_layout(value);
		if (_mainStyle != null) { // better way/place to do this
			// set layout props from style
			if (layout != null) {
				if (_mainStyle.paddingLeft != -1) {
					layout.padding.left = _mainStyle.paddingLeft;
				}
				if (_mainStyle.paddingTop != -1) {
					layout.padding.top = _mainStyle.paddingTop;
				}
				if (_mainStyle.paddingRight != -1) {
					layout.padding.right = _mainStyle.paddingRight;
				}
				if (_mainStyle.paddingBottom != -1) {
					layout.padding.bottom = _mainStyle.paddingBottom;
				}
				if (_mainStyle.spacingX != -1) {
					_layout.spacingX = _mainStyle.spacingX;
				}
				if (_mainStyle.spacingY != -1) {
					_layout.spacingY = _mainStyle.spacingY;
				}
			}
		}
		return value;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	public var mainStyle(get, set):Style;
	@:clonable
	public var styleName(get, set):String;
	public var style(get, set):Style;
	
	private function get_mainStyle():Style {
		if (_mainStyle == null) {
			_mainStyle = new Style();
			_mainStyle.target = this;
		}
		return _mainStyle;
	}
	
	private function set_mainStyle(value:Style):Style {
		_mainStyle = value;
		_mainStyle.target = this;
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
			_mainStyle = StyleManager.instance.buildStyleFor(this);
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
			_mainStyle = StyleManager.instance.buildStyleFor(this);
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
		if (_mainStyle == null) {
			return;
		}
		
		if (_inlineStyle != null) {
			_mainStyle.merge(_inlineStyle);
		}
		if (_mainStyle != null) {
			if (_mainStyle.alpha != -1) {
				_sprite.alpha = _mainStyle.alpha;
			} else {
				_sprite.alpha = 1;
			}
			
			if (_mainStyle.horizontalAlignment != null) {
				this.horizontalAlign = _mainStyle.horizontalAlignment;
			}
			if (_mainStyle.verticalAlignment != null) {
				this.verticalAlign = _mainStyle.verticalAlignment;
			}
			
			#if !html5
			if (_mainStyle.filter != null) {
				_sprite.filters = [_mainStyle.filter];
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
			_mainStyle = retrieveStyle(state);//StyleManager.instance.buildStyleFor(this, cast(this, StateComponent).state);
			if (_mainStyle == null) {
				_mainStyle = StyleManager.instance.buildStyleFor(this, cast(this, StateComponent).state);
			}
		} else {
			_mainStyle = StyleManager.instance.buildStyleFor(this);
		}
		
		_mainStyle.merge(_inlineStyle);
		
		if (_mainStyle != null) {
			// get props from style if they exist
			if (_mainStyle.width != -1 && width == 0) {
				width = _mainStyle.width;
			}
			if (_mainStyle.height != -1 && height == 0) {
				height = _mainStyle.height;
			}

			if (_mainStyle.percentWidth != -1 && percentWidth == -1) {
				percentWidth = _mainStyle.percentWidth;
			}
			if (_mainStyle.percentHeight != -1 && percentHeight == -1) {
				percentHeight = _mainStyle.percentHeight;
			}
			if (_mainStyle.autoSizeSet) {
				autoSize = _mainStyle.autoSize;
			}
			
			// set layout props from style
			if (layout != null) {
				if (_mainStyle.paddingLeft != -1) {
					layout.padding.left = _mainStyle.paddingLeft;
				}
				if (_mainStyle.paddingTop != -1) {
					layout.padding.top = _mainStyle.paddingTop;
				}
				if (_mainStyle.paddingRight != -1) {
					layout.padding.right = _mainStyle.paddingRight;
				}
				if (_mainStyle.paddingBottom != -1) {
					layout.padding.bottom = _mainStyle.paddingBottom;
				}
				if (_mainStyle.spacingX != -1) {
					_layout.spacingX = _mainStyle.spacingX;
				}
				if (_mainStyle.spacingY != -1) {
					_layout.spacingY = _mainStyle.spacingY;
				}
			}
		}
		
		applyStyle();
		Macros.endProfile();
	}
}