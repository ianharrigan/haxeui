package haxe.ui.toolkit.hscript;

class ScriptUtils {
	public static function isScript(data:String):Bool {
		if (data.indexOf("+") != -1
			|| data.indexOf("-") != -1
			|| data.indexOf("*") != -1
			|| data.indexOf("/") != -1
			|| data.indexOf("(") != -1
			|| data.indexOf(")") != -1
			|| data.indexOf("[") != -1
			|| data.indexOf("]") != -1) {
			return true;
		}
		return false;
	}
}