package haxe.ui.toolkit.console;

import haxe.ui.toolkit.console.ui.ScriptEditor;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.resources.ResourceManager;
import pgr.dconsole.DC;
import pgr.dconsole.DCCommands;

class HaxeUIConsoleCommands {
	public static function init():Void {
		DC.registerCommand(exec, "exec", "x", "Executes a script", "To run a script simply use 'exec ${scriptResource}'.\nFunctionally identical to:\n    runScript(\"${scriptResource}\")\n    scripts run ${scriptResource}");
		DC.registerCommand(scripts, "scripts", "", "Performs actions on script resources", "The following actions are available:\n    scripts list\n    scripts run ${scriptResource}\n    scripts view ${scriptResource}\n    scripts create ${scriptResource}\n    scripts edit ${scriptResource}\n    scripts remove ${scriptResource}");
	}
	
	public static function exec(params:Array<String>):Void {
		if (params.length < 1) {
			DC.logError("No script resource specified");
			return;
		}
		
		HaxeUIConsoleFunctions.runScript(params[0]);
	}
	
	public static function scripts(params:Array<String>):Void {
		if (params.length < 1) {
			DC.logError("No script verb specified");
			return;
		}
		
		var verb:String = params[0];
		switch (verb) {
			case "list":
				HaxeUIConsoleFunctions.listScripts();
			case "run":
				if (params.length < 2) {
					DC.logError("No enough parameters for run verb");
					return;
				}
				HaxeUIConsoleFunctions.runScript(params[1]);
			case "view":
				if (params.length < 2) {
					DC.logError("No enough parameters for view verb");
					return;
				}
				HaxeUIConsoleFunctions.viewScript(params[1]);
			case "create":
				if (params.length < 2) {
					DC.logError("No enough parameters for create verb");
					return;
				}
				HaxeUIConsoleFunctions.createScript(params[1]);
			case "edit":
				if (params.length < 2) {
					DC.logError("No enough parameters for edit verb");
					return;
				}
				HaxeUIConsoleFunctions.editScript(params[1]);
			case "remove":
				if (params.length < 2) {
					DC.logError("No enough parameters for remove verb");
					return;
				}
				HaxeUIConsoleFunctions.removeScript(params[1]);
			default:
				DC.logError("Unknown script verb");
		}
		/*
		if (verb == "view") {
			if (params.length < 2) {
				DC.logError("No enough parameters for view verb");
				return;
			}
			
			var scriptRes:String = params[1];
			HaxeUIConsoleFunctions.viewScript(scriptRes);
		}
		*/
	}
}