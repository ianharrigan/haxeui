package haxe.ui.toolkit.core;

import haxe.macro.Context;
import haxe.macro.Expr;

class Macros {
	macro public static function addStyleSheet(resourceId:String):Expr {
		var contents:String = sys.io.File.getContent("assets/" + resourceId);
		var code:String = "function() {\n";
		code += "\tvar styles:haxe.ui.toolkit.style.Styles = haxe.ui.toolkit.style.StyleParser.fromString(\"" + contents + "\");\n";
		//code += "\tstyles.dump();\n";
		code += "\thaxe.ui.toolkit.style.StyleManager.instance.addStyles(styles);\n";
		code += "}()\n";
		return Context.parseInlineString(code, Context.currentPos());
	}
	
	macro public static function registerComponentPackage(pack:String, prefix:String):Expr {
		
		var code:String = "function() {\n";
		var currentClassName:String = Context.getLocalClass().toString();
		var arr:Array<String> = pack.split(".");
		var dir:String = "src/" + arr.join("/"); // TODO: 'src' will be a problem
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
		
		code += "}()\n";
		//trace(code);
		return Context.parseInlineString(code, Context.currentPos());
	}
	
	macro public static function registerDataSourcePackage(pack:String):Expr {
		
		var code:String = "function() {\n";
		var currentClassName:String = Context.getLocalClass().toString();
		var arr:Array<String> = pack.split(".");
		var dir:String = "src/" + arr.join("/");
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
		
		code += "}()\n";
//		trace(code);
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