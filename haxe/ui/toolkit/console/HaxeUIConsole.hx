package haxe.ui.toolkit.console;
import haxe.ui.toolkit.resources.ResourceManager;
import openfl.Assets;
import pgr.dconsole.DC;

class HaxeUIConsole {
	public static var scripts:Map<String, String> = new Map<String, String>();

	public static function init():Void {
		DC.init(.5, "DOWN", HaxeUIConsoleTheme.HAXEUI_THEME);
		
		HaxeUIConsoleCommands.init();
		HaxeUIConsoleFunctions.init();
		
		DC.registerObject(new ConsoleWrapper(), "console");
		
		for (r in Assets.list()) {
			if (StringTools.endsWith(r, ".hscript")) {
				scripts.set(r, ResourceManager.instance.getText(r));
			}
		}
	}
}