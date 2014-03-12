package haxe.ui.toolkit.core;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.ui.toolkit.hscript.ScriptUtils;
import haxe.ui.toolkit.util.StringUtil;

class Macros {
	macro public static function addClonable():Array<Field> {
        var pos = haxe.macro.Context.currentPos();
        var fields = haxe.macro.Context.getBuildFields();
		if (hasInterface(Context.getLocalType(), "haxe.ui.toolkit.core.interfaces.IClonable") == false) {
			return fields;
		}

		var currentCloneFn = getFunction("clone", fields);
		var t:haxe.macro.Type = Context.getLocalType();
		var className:String = getClassNameFromType(t);
		var filePath = StringTools.replace(className, ".", "/");
		filePath = "src/" + filePath + ".hx";
		pos = Context.makePosition( { min: 0, max:0, file: filePath});

		var useSelf:Bool = false;
		if (getSuperClass(t) == null) {
			useSelf = true;
		}
		
		var n1:Int = className.indexOf("_");
		if (n1 != -1) {
			var n2:Int = className.indexOf(".", n1);
			className = className.substr(0, n1) + className.substr(n2 + 1, className.length);
		}
		
		if (currentCloneFn == null) {
			var code:String = "";
			code += "function():" + className + " {\n";
			if (useSelf == false) {
				code += "var c:" + className + " = cast super.clone();\n";
			} else {
				code += "var c:" + className + " = self();\n";
			}
			for (f in getFieldsWithMeta("clonable", fields)) {
				code += "c." + f.name + " = this." + f.name + ";\n";
			}
			code += "return c;\n";
			code += "}\n";
		
			//trace(code);
			
			var access:Array<Access> = [APublic];
			if (useSelf == false) {
				access.push(AOverride);
			}
			addFunction("clone", Context.parseInlineString(code, pos), access, fields, pos);
		} else {
			var code:String = "";
			if (useSelf == false) {
				code += "var c:" + className + " = cast super.clone()\n";
			} else {
				code += "var c:" + className + " = self()\n";
			}

			insertLine(currentCloneFn, Context.parseInlineString(code, pos), 0);
			
			for (f in getFieldsWithMeta("clonable", fields)) {
				code = "c." + f.name + " = this." + f.name + "";
				insertLine(currentCloneFn, Context.parseInlineString(code, pos), -1);
			}

			insertLine(currentCloneFn, Context.parseInlineString("return c", pos), -1);
		}

		var code:String = "";
		code += "function():" + className + " {\n";
		code += "return new " + className + "();\n";
		code += "}\n";
		var access:Array<Access> = [APrivate];
		if (useSelf == false) {
			access.push(AOverride);
		}
		addFunction("self", Context.parseInlineString(code, pos), access, fields, pos);

		return fields;
	}
	
	macro public static function addEvents(types:Array<String>):Array<Field> {
        var pos = haxe.macro.Context.currentPos();
        var fields = haxe.macro.Context.getBuildFields();
		
		for (type in types) {
			//addEvent(type, fields);
			
			var name = "on" + StringUtil.capitalizeFirstLetter(type);
			var tparam = TPath( { pack : ["haxe","ui","toolkit","events"], name : "UIEvent", params : [], sub : null } );
			var tvoid = TPath( { pack : [], name : "Void", params : [], sub : null } );
			var tfn = TFunction([tparam], tvoid);
			fields.push( { name : name, doc : null, meta : [{name: "exclude", pos: haxe.macro.Context.currentPos() }], access : [APublic], kind : FProp("default", "set", tfn, null), pos : haxe.macro.Context.currentPos() } );
			
			var code = "function (value:haxe.ui.toolkit.events.UIEvent->Void):haxe.ui.toolkit.events.UIEvent->Void {\n";
			code += "" + name + " = value;\n";
			code += "addEventListener(haxe.ui.toolkit.events.UIEvent.PREFIX + \"" + type + "\", _handleEvent);\n";
			code += "return value;\n";
			code += "}";
			
			var fnSetter = switch (Context.parseInlineString(code, haxe.macro.Context.currentPos()) ).expr {
				case EFunction(_,f): f;
				case _: throw "false";
			}
			fields.push( { name : "set_" + name, doc : null, meta : [{name: "exclude", pos: haxe.macro.Context.currentPos() }], access : [APrivate], kind : FFun(fnSetter), pos : haxe.macro.Context.currentPos() } );
		}
		
		return fields;
	}
	
	macro public static function buildController(resourcePath:String):Array<Field> {
        var pos = haxe.macro.Context.currentPos();
        var fields = haxe.macro.Context.getBuildFields();
		var ctor = null;
		for (f in fields) {
			if (f.name == "new") {
				switch (f.kind) {
					case FFun(f):
							ctor = f;
						break;
					default:
				}
			}
		}

		if (ctor == null) Context.error("A class building a controller must have a constructor", Context.currentPos());
		
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

		resourcePath = StringTools.replace(resourcePath, "\\", "/");
		resourcePath = StringTools.replace(resourcePath, "//", "/");
		
		if (sys.FileSystem.exists(resourcePath) == false) {
			Context.error("XML file not found", Context.currentPos());
		}
		
		var e:Expr = Context.parseInlineString("super(\"" + resourcePath + "\")", Context.currentPos());
		ctor.expr = switch(ctor.expr.expr) {
			case EBlock(el): macro $b{insertExpr(el, 0, e)};
			case _: macro $b { insertExpr([ctor.expr], 0, e) }
		}
		
		var contents:String = sys.io.File.getContent(resourcePath);
		var xml:Xml = Xml.parse(contents);
		var types:Map<String, String> = new Map<String, String>();
		processNode(xml.firstElement(), types);
		
		var n:Int = 1;
		for (id in types.keys()) {
			var cls:String = types.get(id);
			var classArray:Array<String> = cls.split(".");
			var className = classArray.pop();
	        var ttype = TPath( { pack : classArray, name : className, params : [], sub : null } );
			fields.push( { name : id, doc : null, meta : [], access : [APrivate], kind : FVar(ttype, null), pos : pos } );
			
			var e:Expr = Context.parseInlineString("this." + id + " = getComponentAs(\"" + id + "\", " + cls + ")", Context.currentPos());
			ctor.expr = switch(ctor.expr.expr) {
				case EBlock(el): macro $b{insertExpr(el, n, e)};
				case _: macro $b { insertExpr([ctor.expr], n, e) }
			}
		}
		
		return fields;
	}
	
	private static function processNode(node:Xml, types:Map < String, String > ):Void {
		var nodeName:String = node.nodeName;
		var n:Int = nodeName.indexOf(":");
		if (n != -1) {
			nodeName = nodeName.substr(n + 1, nodeName.length);
		}
		nodeName = nodeName.toLowerCase();
		
		var id:String = node.get("id");
		if (id != null && id.length > 0) {
			var cls:String = componentClasses.get(nodeName);
			if (cls != null) {
				types.set(id, cls);
			}
		}
		for (child in node.elements()) {
			processNode(child, types);
		}
	}
	
	private static function getFunction(name:String, fields:Array<Field>) {
		var fn = null;
		for (f in fields) {
			if (f.name == name) {
				switch (f.kind) {
					case FFun(f):
							fn = f;
						break;
					default:
				}
				break;
			}
		}
		return fn;
	}
	
	private static function addFunction(name:String, e:Expr, access:Array<Access>, fields:Array<Field>, pos:Position):Void {
		var fn = switch (e).expr {
			case EFunction(_,f): f;
			case _: throw "false";
		}
		fields.push( { name : name, doc : null, meta : [], access : access, kind : FFun(fn), pos : pos } );
	}
	
	private static function getFieldsWithMeta(meta:String, fields:Array<Field>):Array<Field> {
		var arr:Array<Field> = new Array<Field>();

		for (f in fields) {
			if (hasMeta(f, meta)) {
				arr.push(f);
			}
		}
		
		return arr;
	}
	
	private static function getSuperClass(t:haxe.macro.Type) {
		var superClass = null;
		switch (t) {
				case TAnonymous(t): {};
				case TMono(t): {};
				case TLazy(t): {};
				case TFun(t, _): {};
				case TDynamic(t): {};
				case TInst(t, _): {
					superClass = t.get().superClass;
				}
				case TEnum(t, _): {};
				case TType(t, _): {};
				case TAbstract(t, _): {};
		}
		return superClass;
	}
	
	private static function insertLine(fn, e:Expr, location:Int):Void {
		fn.expr = switch(fn.expr.expr) {
			case EBlock(el): macro $b{insertExpr(el, location, e)};
			case _: macro $b { insertExpr([fn.expr], location, e) }
		}
	}
	
	private static function insertExpr(arr:Array<Expr>, pos:Int, item:Expr):Array<Expr> {
		if (pos == -1) {
			arr.push(item);
		} else {
			arr.insert(pos, item);
		}
		return arr;
	}
	
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
				if (ScriptUtils.isScript(propValue) && !ScriptUtils.isCssException(propName)) {
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
	
	private static var componentClasses:Map<String, String> = new Map<String, String>();
	macro public static function registerComponentPackage(pack:String):Expr {

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
									var entryName:String = name.toLowerCase();
									componentClasses.set(entryName, className);
									if (currentClassName.indexOf("ClassManager") != -1) {
										code += "\tregisterComponentClass(" + className + ", '" + name.toLowerCase() + "');\n";
									} else {
										code += "\tClassManager.instance.registerComponentClass(" + className + ", '" + name.toLowerCase() + "');\n";
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
	
	private static function hasMeta(f:Field, meta:String):Bool {
		var has:Bool = false;
		for (m in f.meta) {
			if (m.name == meta || m.name == ":" + meta) {
				has = true;
				break;
			}
		}
		return has;
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