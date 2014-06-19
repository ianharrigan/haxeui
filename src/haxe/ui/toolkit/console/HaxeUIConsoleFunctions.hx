package haxe.ui.toolkit.console;

import haxe.ui.toolkit.console.ui.ScriptEditor;
import haxe.ui.toolkit.core.ClassManager;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.util.Identifier;
import pgr.dconsole.DC;
import pgr.dconsole.DCCommands;

class HaxeUIConsoleFunctions {
	public static function init():Void {
		DC.registerFunction(create, "create");
		DC.registerFunction(dispose, "dispose");
		DC.registerFunction(inspect, "inspect");
		DC.registerFunction(runScript, "runScript");
		DC.registerFunction(viewScript, "viewScript");
		DC.registerFunction(createScript, "createScript");
		DC.registerFunction(editScript, "editScript");
		DC.registerFunction(listScripts, "listScripts");
		DC.registerFunction(removeScript, "removeScript");
	}
	
	public static function create(type:String, text:String = null, id:String = null, width:Float = -1, height:Float = -1, x:Float = -1, y:Float = -1):Component {
		var comp:Component = null;
		if (type != null) {
			var className:String = ClassManager.instance.getComponentClassName(type);
			if (className != null) {
				comp = Type.createInstance(Type.resolveClass(className), []);
				if (id == null) {
					id = Identifier.createObjectId(comp);
					id = id.substr(id.lastIndexOf(".") + 1, id.length).toLowerCase();
				}
				if (text == null) {
					text = id;
				}
				
				if (width == -1) {
					width = 100;
				}
				if (height == -1) {
					height = 100;
				}
				
				comp.id = id;
				comp.text = text;
				if (width  != -1) {
					comp.width = width;
				}
				if (height  != -1) {
					comp.height = height;
				}
				RootManager.instance.currentRoot.addChild(comp);
				
				DC.logConfirmation("Created '" + id + "'");
				DC.registerObject(comp, id);
			}
		}
		return comp;
	}
	
	public static function dispose(target:Dynamic):Void {
		var c:Component = getComponent(target);
		if (c != null) {
			unregisterObjects(c);
			c.parent.removeChild(c);
		}
	}
	
	public static function inspect(target:Dynamic, verbose:Bool = false):Void {
		var c:Component = getComponent(target);
		if (c != null) {
			inspectComponent(c, 0, verbose);
		}
	}

	private static function getComponent(target:Dynamic):Component {
		var obj:Dynamic = null;
		if (Std.is(target, String)) {
			obj = DCCommands.getObject(target);
		} else {
			obj = target;
		}
		if (obj == null) {
			DC.logError(target + " not found");
			return null;
		}
		if (Std.is(obj, Component) == false) {
			DC.logError(target + " is not a haxeui component");
			return null;
		}
		
		var c:Component = cast obj;
		return c;
	}
	
	private static function inspectComponent(c:Component, indent:Int, verbose:Bool = false):Void {
		var s:String = "";
		var n:Int = indent - 1;
		var t:Component = cast c.parent;
		var arr:Array<String> = [];
		while (n > 0) {
			if (isLastChild(t)) {
				arr.push("   ");
			} else {
				arr.push(" │ ");
			}
			
			n--;
			t = cast t.parent;
		}
		arr.reverse();
		s += arr.join("");

		if (indent > 0) {
			if (isLastChild(c)) {
				s += " └ ";
			} else {
				s += " ├ ";
			}
		}

		var name:String = Type.getClassName(Type.getClass(c));
		name = name.substr(name.lastIndexOf(".") + 1, name.length);
		if (verbose  == false) {
			if (c.id != null) {
				name = "#" + c.id;
			}
			if (c.styleName != null) {
				name += "." + c.styleName;
			}
		}

		s += name;
		if (verbose == true) {
			var verboseDetails:Array<String> = [];
			if (c.id != null) {
				verboseDetails.push("id=" + c.id);
			}
			if (c.text != null) {
				verboseDetails.push("text=" + c.text);
			}
			if (c.styleName != null) {
				verboseDetails.push("styleName=" + c.styleName);
			}
			if (c.percentWidth > -1) {
				verboseDetails.push("width=" + c.percentWidth + "%");
			} else {
				verboseDetails.push("width=" + c.width);
			}
			if (c.percentHeight > -1) {
				verboseDetails.push("height=" + c.percentHeight + "%");
			} else {
				verboseDetails.push("height=" + c.height);
			}
			if (verboseDetails.length > 0) {
				s += " [" + verboseDetails.join(", ") + "]";
			}
		}
		
		DC.logInfo(s);
		for (child in c.children) {
			inspectComponent(cast child, indent + 1, verbose);
		}
	}
	
	private static function isLastChild(c:Component):Bool {
		var index:Int = c.parent.indexOfChild(c);
		return (index == c.parent.numChildren - 1);
	}
	
	public static function runScript(scriptRes:String):Void {
		var scriptData:String = getScriptData(scriptRes);
		if (scriptData == null) {
			DC.logError("Script '" + scriptRes + "' not found");
			return;
		}
		var n:Int = scriptData.lastIndexOf(";");
		scriptData = scriptData.substr(0, n);
		DCCommands.evaluate(scriptData);
	}
	
	public static function viewScript(scriptRes:String):Void {
		var scriptData:String = getScriptData(scriptRes);
		if (scriptData == null) {
			DC.logError("Script '" + scriptRes + "' not found");
			return;
		}

		var config:Dynamic = {
			width: 500,
			buttons: PopupButton.OK,
		};
		PopupManager.instance.showCustom(ScriptEditor.buildUI(scriptData) , "Script - " + scriptRes, config, function(result) {
		});
	}

	public static function createScript(scriptRes:String):Void {
		var config:Dynamic = {
			width: 500,
			buttons: PopupButton.CANCEL | PopupButton.CONFIRM,
		};
		PopupManager.instance.showCustom(ScriptEditor.buildUI() , "Script - " + scriptRes, config, function(result) {
			if (result == PopupButton.CONFIRM) {
				setScriptData(scriptRes, ScriptEditor.scriptContent);
			}
		});
	}
	
	public static function editScript(scriptRes:String):Void {
		var scriptData:String = getScriptData(scriptRes);
		if (scriptData == null) {
			DC.logError("Script '" + scriptRes + "' not found");
			return;
		}
		
		var config:Dynamic = {
			width: 500,
			buttons: PopupButton.CANCEL | PopupButton.CONFIRM,
		};
		PopupManager.instance.showCustom(ScriptEditor.buildUI(scriptData) , "Script - " + scriptRes, config, function(result) {
			if (result == PopupButton.CONFIRM) {
				setScriptData(scriptRes, ScriptEditor.scriptContent);
			}
		});
	}
	
	public static function removeScript(scriptRes:String):Void {
		if (HaxeUIConsole.scripts.exists(scriptRes) == false) {
			DC.logError("'" + scriptRes + "' doesnt exist");
			return;
		}
		
		HaxeUIConsole.scripts.remove(scriptRes);
	}
	
	public static function listScripts():Void {
		for (r in HaxeUIConsole.scripts.keys()) {
			DC.logInfo(r);
		}
	}
	
	private static function getScriptData(scriptRes:String):String {
		var scriptData:String = null;
		if (HaxeUIConsole.scripts.exists(scriptRes)) {
			scriptData = HaxeUIConsole.scripts.get(scriptRes);
		} else if (ResourceManager.instance.hasAsset(scriptRes)) {
			scriptData = ResourceManager.instance.getText(scriptRes);
		}
		return scriptData;
	}
	
	private static function setScriptData(scriptRes:String, scriptData:String):Void {
		HaxeUIConsole.scripts.set(scriptRes, scriptData);
		DC.logConfirmation("Script '" + scriptRes + "' saved");
	}
	
	private static function unregisterObjects(parent:Component):Void {
		if (parent == null) {
			return;
		}
		
		if (parent.id != null) {
			DC.unregisterObject(parent.id);
		}
		
		for (child in parent.children) {
			unregisterObjects(cast child);
		}
	}
}