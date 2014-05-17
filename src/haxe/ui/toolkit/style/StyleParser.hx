package haxe.ui.toolkit.style;

import flash.geom.Rectangle;
import haxe.ui.toolkit.hscript.ScriptUtils;
import haxe.ui.toolkit.util.FilterParser;
import haxe.ui.toolkit.util.StringUtil;

class StyleParser {
	public static function fromString(styleString:String):Styles {
		if (styleString == null || styleString.length == 0) {
			return new Styles();
		}
		
		var styles = new Styles();

		var n1:Int = -1;
		var n2:Int = styleString.indexOf("{", 0);
		while (n2 > -1) {
			var n3:Int = styleString.indexOf("}", n2);
			
			var styleName:String = StringTools.trim(styleString.substr(n1 + 1, n2 - n1 - 1));
			var styleData:String = styleString.substr(n2 + 1, n3 - n2 - 1);
			var style:Style = new Style();
			var props:Array<String> = styleData.split(";");
			for (prop in props) {
				prop = StringTools.trim(prop);
				if (StringTools.startsWith(prop, "//")) {
					continue;
				}

				if (prop != null && prop.length > 0) {
					var temp:Array<String> = prop.split(":");
					var propName = StringTools.trim(temp[0]);
					propName = StringUtil.capitalizeHyphens(propName);
					if (Reflect.field(style, "set_" + propName) == null) {
						trace("Warning: " + propName + " no found");
						continue;
					}
					
					var propValue = StringTools.trim(temp[1]);
					if (temp.length == 3) {
						propValue += ":" + StringTools.trim(temp[2]);
					}
					
					propValue = StringTools.replace(propValue, "\"", "");
					propValue = StringTools.replace(propValue, "'", "");
					if (ScriptUtils.isScript(propValue) && !ScriptUtils.isCssException(propName)) {
						style.addDynamicValue(propName, propValue);
						continue;
					}
					
					if (propName == "width" && propValue.indexOf("%") != -1) { // special case for width
						propName = "percentWidth";
						propValue = propValue.substr(0, propValue.length - 1);
					} else if (propName == "height" && propValue.indexOf("%") != -1) { // special case for height
						propName = "percentHeight";
						propValue = propValue.substr(0, propValue.length - 1);
					} else if (propName == "filter") {
						style.filter = FilterParser.parseFilter(propValue);
						continue;
					} else if (propName == "backgroundImageScale9") {
						var coords:Array<String> = propValue.split(",");
						var x1:Int = Std.parseInt(coords[0]);
						var y1:Int = Std.parseInt(coords[1]);
						var x2:Int = Std.parseInt(coords[2]);
						var y2:Int = Std.parseInt(coords[3]);
						var scale9:Rectangle = new Rectangle();
						scale9.left = x1;
						scale9.top = y1;
						scale9.right = x2;
						scale9.bottom = y2;
						style.backgroundImageScale9 = scale9;
						continue;
					} else if (propName == "backgroundImageRect") {
						var arr:Array<String> = propValue.split(",");
						style.backgroundImageRect = new Rectangle(Std.parseInt(arr[0]), Std.parseInt(arr[1]), Std.parseInt(arr[2]), Std.parseInt(arr[3]));
						continue;
					}
					
					if (propValue.indexOf(",") != -1 || !StringTools.startsWith(propValue, "#") && Std.string(Std.parseFloat(propValue)) == Std.string(Math.NaN)) { // TODO: must be a bad way of doing this
						if (propValue == "true" || propValue == "false") {
							Reflect.setProperty(style, propName, propValue == "true");
						} else {
							Reflect.setProperty(style, propName, propValue);
						}
					} else {
						if (StringTools.startsWith(propValue, "#")) { // lazyness
							propValue = "0x" + propValue.substr(1, propValue.length - 1);
						}
						if (StringTools.startsWith(propValue, "0x")) {
							Reflect.setProperty(style, propName, Std.parseInt(propValue));
						} else {
							Reflect.setProperty(style, propName, Std.parseFloat(propValue));
						}
					}
				}
			}
			
			if (styleName.indexOf(",") == -1) {
				styles.addStyle(styleName, style);
			} else {
				var arr:Array<String> = styleName.split(",");
				for (s in arr) {
					s = StringTools.trim(s);
					styles.addStyle(s, style);
				}
			}
			
			n1 = n3;
			n2 = styleString.indexOf("{", n1);
		}
		
		return styles;
	}
}