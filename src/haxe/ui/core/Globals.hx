package haxe.ui.core;

class Globals {
	private static var flags:Hash<String>;
	
	public static function add(id:String):Void {
		if (flags == null) {
			flags = new Hash<String>();
		}
		flags.set(id, id);
	}
	
	public static function has(id:String):Bool {
		if (flags == null) {
			return false;
		}
		return flags.exists(id);
	}
}