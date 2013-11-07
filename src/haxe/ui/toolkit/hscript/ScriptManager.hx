package haxe.ui.toolkit.hscript;

class ScriptManager {
	private static var _instance:ScriptManager;
	public static var instance(get, null):ScriptManager;
	private static function get_instance():ScriptManager {
		if (_instance == null) {
			_instance = new ScriptManager();
		}
		return _instance;
	}

	//******************************************************************************************
	// Instance methods/props
	//******************************************************************************************
	private var _scripts:Array<String>;
	
	public function new() {
		_scripts = new Array<String>();
	}
	
	public function addScript(script:String):Void {
		_scripts.push(script);
	}
	
	public function executeScript<T>(script:String):Null<T> {
		var fullScript:String = "";
		for (s in _scripts) {
			fullScript += s + "\n\n";
		}
		fullScript += script;
		var retVal = null;
		
		try {
			var parser = new hscript.Parser();
			var program = parser.parseString(fullScript);
			var interp = new hscript.Interp();
			
			var clientWrapper:ClientWrapper = new ClientWrapper();
			interp.variables.set("Client", clientWrapper);

			retVal = interp.execute(program);
		} catch (e:Dynamic) {
			trace("Problem running script: " + e);
			trace(script);
		}
		return retVal;
	}
}