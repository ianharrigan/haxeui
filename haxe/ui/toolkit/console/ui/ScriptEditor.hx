package haxe.ui.toolkit.console.ui;

import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.core.Component;

class ScriptEditor {
	private static var scriptText:TextInput;
	
	public static function buildUI(scriptContent:String = ""):Component {
		scriptContent = StringTools.replace(scriptContent, "\r\n", "\n");
		
		scriptText = new TextInput();
		scriptText.text = scriptContent;
		scriptText.multiline = true;
		scriptText.wrapLines = false;
		scriptText.percentWidth = 100;
		scriptText.height = 300;
		
		return scriptText;
	}
	
	public static var scriptContent(get, set):String;
	private static function get_scriptContent():String {
		return scriptText.text;
	}
	private static function set_scriptContent(value:String):String {
		value = StringTools.replace(value, "\r\n", "\n");
		scriptText.text = value;
		return value;
	}
}