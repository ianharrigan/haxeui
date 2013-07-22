package haxe.ui.toolkit.core;

class FocusManager {
	private static var _instance:FocusManager;
	public static var instance(getInstance, null):FocusManager;
	public static function getInstance():FocusManager {
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