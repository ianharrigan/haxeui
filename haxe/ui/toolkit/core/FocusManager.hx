package haxe.ui.toolkit.core;

class FocusManager {
	private static var _instance:FocusManager;
	public static var instance(get, null):FocusManager;
	private static function get_instance():FocusManager {
		if (_instance == null) {
			_instance = new FocusManager();
		}
		return _instance;
	}
	
	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	public function new() {
		
	}
}