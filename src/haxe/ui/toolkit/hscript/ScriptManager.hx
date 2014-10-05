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
	private var _defaultClasses:Map<String, Class<Dynamic>>;
	
	public function new() {
		_defaultClasses = new Map < String, Class<Dynamic> > ();
		_defaultClasses.set("Std", Std);
		_defaultClasses.set("Math", Math);
		_defaultClasses.set("Client", ClientWrapper);
	}

	public var classes(get, null):Map<String, Class<Dynamic>>;
	private function get_classes():Map<String, Class<Dynamic>> {
		return _defaultClasses;
	}
	
	public function addClass(name:String, cls:Class<Dynamic>):Void {
		_defaultClasses.set(name, cls);
	}
	
	public function executeScript<T>(script:String):Null<T> {
		var fullScript:String = "";
		fullScript += script;
		var retVal = null;
		
		try {
			var parser = new hscript.Parser();
			var program = parser.parseString(fullScript);
			var interp = new ScriptInterp();
			
			retVal = interp.execute(program);
		} catch (e:Dynamic) {
			//trace("Problem running script: " + e);
			//trace(script);
			retVal = cast script;
		}
		return retVal;
	}
}