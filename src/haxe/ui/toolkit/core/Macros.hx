package haxe.ui.toolkit.core;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.ui.toolkit.hscript.ScriptUtils;

class Macros {
	macro public static function addStyleSheet(resourcePath:String):Expr {
		if (sys.FileSystem.exists(resourcePath) == false) {
			var paths:Array<String> = Context.getClassPath();
			for (path in paths) {
				path = path + "/" + resourcePath;
				if (sys.FileSystem.exists(path)) {
					resourcePath = path;
					break;
				}
			}
		}
		
		var contents:String = sys.io.File.getContent(resourcePath);
		var code:String = "function() {\n";
		var arr:Array<String> = contents.split("}");
		
		for (s in arr) {
			if (StringTools.trim(s).length > 0) {
				var n:Int = s.indexOf("{");
				var rule:String = StringTools.trim(s.substring(0, n));
				var style:String = s.substring(n + 1, s.length);
				style = StringTools.replace(style, "\"", "\\\"");
				code += "\tMacros.addStyle(\"" + rule + "\", \"" + style + "\");\n";
			}
		}
		code += "}()\n";
		//trace(code);
		return Context.parseInlineString(code, Context.currentPos());
	}
	
	macro public static function addStyle(rule:String, style:String):Expr {
		var code:String = "function() {\n";
		
		code += "\tvar style:haxe.ui.toolkit.style.Style = new haxe.ui.toolkit.style.Style({\n";
		var styles:Array<String> = style.split(";");
		var dynamicValues:Map<String, String> = new Map<String, String>();
		for (styleData in styles) {
			styleData = StringTools.trim(styleData);
			if (styleData.length > 0) {
				var props:Array<String> = styleData.split(":");
				var propName:String = StringTools.trim(props[0]);
				var propValue:String = StringTools.trim(props[1]);
				if (ScriptUtils.isScript(propValue) && propName != "filter" && propName != "icon" && propName != "backgroundImage" && propName != "fontName") {
					dynamicValues.set(propName, propValue);
					continue;
				}
				
				if (propName == "width" && propValue.indexOf("%") != -1) { // special case for width
					propName = "percentWidth";
					propValue = propValue.substr(0, propValue.length - 1);
				} else if (propName == "height" && propValue.indexOf("%") != -1) { // special case for height
					propName = "percentHeight";
					propValue = propValue.substr(0, propValue.length - 1);
				} else if (propName == "filter") {
					var filterParams = "";
					var n:Int = propValue.indexOf("(");
					if (n != -1) {
						filterParams = propValue.substring(n + 1, propValue.length - 1);
					}
					if (StringTools.startsWith(propValue, "dropShadow")) {
						propValue = "new flash.filters.DropShadowFilter(" + filterParams + ")";
					} else if (StringTools.startsWith(propValue, "blur")) {
						propValue = "new flash.filters.BlurFilter(" + filterParams + ")";
					} else if (StringTools.startsWith(propValue, "glow")) {
						propValue = "new flash.filters.GlowFilter(" + filterParams + ")";
					} else {
						propValue = "null";
					}
				} else if (propName == "backgroundImageScale9") {
					var coords:Array<String> = propValue.split(",");
					var x1:Int = Std.parseInt(coords[0]);
					var y1:Int = Std.parseInt(coords[1]);
					var x2:Int = Std.parseInt(coords[2]);
					var y2:Int = Std.parseInt(coords[3]);
					propValue = "new flash.geom.Rectangle(" + x1 + "," + y1 + "," + (x2 - x1) + "," + (y2 - y1) + ")";
				} else if (propName == "backgroundImageRect") {
					var arr:Array<String> = propValue.split(",");
					propValue = "new flash.geom.Rectangle(" + Std.parseInt(arr[0]) + "," + Std.parseInt(arr[1]) + "," + Std.parseInt(arr[2]) + "," + Std.parseInt(arr[3]) + ")";
				}
				
				if (StringTools.startsWith(propValue, "#")) { // lazyness
					propValue = "0x" + propValue.substr(1, propValue.length - 1);
				}
				
				code += "\t\t" + propName + ":" + propValue + ",\n";
			}
		}
		code += "\t});\n";
		for (property in dynamicValues.keys()) {
			var value:String = dynamicValues.get(property);
			code += "\tstyle.addDynamicValue(\"" + property + "\", \"" + value + "\");\n";
		}
		code += "\thaxe.ui.toolkit.style.StyleManager.instance.addStyle(\"" + rule + "\", style);\n";
				
		code += "}()\n";
		return Context.parseInlineString(code, Context.currentPos());
	}
	
	macro public static function registerComponentPackage(pack:String, prefix:String):Expr {

		var code:String = "function() {\n";
		var currentClassName:String = Context.getLocalClass().toString();
		var arr:Array<String> = pack.split(".");
		var paths:Array<String> = Context.getClassPath();
		
		for (path in paths) {
			var dir:String = path + arr.join("/");
			if(!sys.FileSystem.exists(dir) || !sys.FileSystem.isDirectory(dir)) {
				continue;
			}
			var files:Array<String> = sys.FileSystem.readDirectory(dir);
			if (files != null) {
				for (file in files) {
					if (file.indexOf(".hx") != -1) {
						var name:String = file.substr(0, file.length - 3);
						var path:String = Context.resolvePath(dir + "/" + file);
						
						var types:Array<haxe.macro.Type> = Context.getModule(pack + "." + name);
						
						for (t in types) {
							var className:String = getClassNameFromType(t);
							if (hasInterface(t, "haxe.ui.toolkit.core.interfaces.IDisplayObject")) {
								if (className == pack + "." + name) {
									if (currentClassName.indexOf("ClassManager") != -1) {
										code += "\tregisterComponentClass(" + className + ", '" + name.toLowerCase() + "', '" + prefix + "');\n";
									} else {
										code += "\tClassManager.instance.registerComponentClass(" + className + ", '" + name.toLowerCase() + "', '" + prefix + "');\n";
									}
								}
							}
						}
					}
				}
			}
		}
		
		code += "}()\n";
		//trace(code);
		return Context.parseInlineString(code, Context.currentPos());
	}
	
	macro public static function registerDataSourcePackage(pack:String):Expr {
		
		var code:String = "function() {\n";
		var currentClassName:String = Context.getLocalClass().toString();
		var arr:Array<String> = pack.split(".");
		var paths:Array<String> = Context.getClassPath();

		for (path in paths) {
			var dir:String = path + arr.join("/");
			if(!sys.FileSystem.exists(dir) || !sys.FileSystem.isDirectory(dir)) {
				continue;
			}
			var files:Array<String> = sys.FileSystem.readDirectory(dir);
			if (files != null) {
				for (file in files) {
					if (file.indexOf(".hx") != -1) {
						var name:String = file.substr(0, file.length - 3);
						var path:String = Context.resolvePath(dir + "/" + file);
						
						var types:Array<haxe.macro.Type> = Context.getModule(pack + "." + name);
						
						for (t in types) {
							var className:String = getClassNameFromType(t);
							if (hasInterface(t, "haxe.ui.toolkit.data.IDataSource")) {
								if (className == pack + "." + name) {
									name = StringTools.replace(name, "DataSource", "");
									if (name.length > 0) {
										if (currentClassName.indexOf("ClassManager") != -1) {
											code += "\tregisterDataSourceClass(" + className + ", '" + name.toLowerCase() + "');\n";
										} else {
											code += "\tClassManager.instance.registerDataSourceClass(" + className + ", '" + name.toLowerCase() + "');\n";
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		code += "}()\n";
		//trace(code);
		return Context.parseInlineString(code, Context.currentPos());
	}
	
	private static function getClassNameFromType(t:haxe.macro.Type):String {
		var className:String = "";
		switch (t) {
				case TAnonymous(t): className = t.toString();
				case TMono(t): className = t.toString();
				case TLazy(t): className = "";
				case TFun(t, _): className = t.toString();
				case TDynamic(t): className = "";
				case TInst(t, _): className = t.toString();
				case TEnum(t, _): className = t.toString();
				case TType(t, _): className = t.toString();
				case TAbstract(t, _): className = t.toString();
		}
		return className;
	}
	
	private static function hasInterface(t:haxe.macro.Type, interfaceRequired:String):Bool {
		var has:Bool = false;
		switch (t) {
				case TAnonymous(t): {};
				case TMono(t): {};
				case TLazy(t): {};
				case TFun(t, _): {};
				case TDynamic(t): {};
				case TInst(t, _): {
					while (t != null) {
						for (i in t.get().interfaces) {
							var interfaceName:String = i.t.toString();
							if (interfaceName == interfaceRequired) {
								has = true;
								break;
							}
						}
						
						if (has == false) {
							if (t.get().superClass != null) {
								t = t.get().superClass.t;
							} else {
								t = null;
							}
						} else {
							break;
						}
					}
				}
				case TEnum(t, _): {};
				case TType(t, _): {};
				case TAbstract(t, _): {};
		}
		
		return has;
	}
}