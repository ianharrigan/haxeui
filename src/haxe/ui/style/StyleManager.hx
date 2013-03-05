package haxe.ui.style;

import nme.Assets;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.geom.Rectangle;
import haxe.ui.style.windows.WindowsStyles;

class StyleManager {
	private static var inheritanceWhitelist = {
		"fontName": "",
		"fontSize": "",
		"color": "",
		"backgroundColor": "",
		"icon": "",
		"borderColor": "",
		"borderSize": "",
		"autoHideScrolls": "",
		"innerScrolls": "",
		"cornerRadius": "",
		
		"xxxpaddingLeft": "",
		"xxpaddingTop": "",
		"xpaddingRight": "",
		"xxpaddingBottom": "",
		"xxxspacingX": "",
		"xxxspacingY": "",
		"xxxwidth": "",
		"xxxheight": "",
	};

	
	private static var currentStyles:Styles;
	public static var styles(getStyles, setStyles):Styles;
	
	private static function getStyles():Styles {
		if (currentStyles == null) {
			currentStyles = new WindowsStyles();
		}
		return currentStyles;
	}
	
	private static function setStyles(value:Styles):Styles {
		currentStyles = value;
		return value;
	}
	
	public static function styleFromString(styleString:String, inheritStylesFrom:String = null):Dynamic {
		var s = { };
		var arr:Array<String> = styleString.split(" ");
		var inheritAll:Bool = false;
		for (n in 0...arr.length) {
			var styleName:String = arr[n];
			var style:Dynamic = StyleManager.styles.getStyle(styleName);
			if (style != null) {
				for (field in Reflect.fields(style)) {
					var value:Dynamic = Reflect.field(style, field);
					if (styleName == inheritStylesFrom || styleName.indexOf(inheritStylesFrom) == 0) {
						inheritAll = true;
					} 
					
					if (Reflect.hasField(inheritanceWhitelist, field) || inheritAll == true) {
						if (value != null) {
							Reflect.setField(s, field, value);
						}
					}
				}
			}
		}

		return s;
	}
	
	public static function mergeStyle(originalStyle:Dynamic, newStyle:Dynamic):Dynamic {
		var mergedStyle = { };
		if (originalStyle != null) {
			for (field in Reflect.fields(originalStyle)) {
				var value:Dynamic = Reflect.field(originalStyle, field);
				Reflect.setField(mergedStyle, field, value);
			}
		}
		if (newStyle != null) {
			for (field in Reflect.fields(newStyle)) {
				var value:Dynamic = Reflect.field(newStyle, field);
				Reflect.setField(mergedStyle, field, value);
			}
		}
		return mergedStyle;
	}
}