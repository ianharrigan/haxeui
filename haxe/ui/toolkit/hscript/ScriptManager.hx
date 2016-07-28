package haxe.ui.toolkit.hscript;
import haxe.ui.toolkit.core.Client;

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
	private var _defaultClasses:Map<String, Dynamic>;
	
	public function new() {
		_defaultClasses = new Map<String, Dynamic>();
		_defaultClasses.set("Std", Std);
		_defaultClasses.set("Math", Math);
		_defaultClasses.set("Client", Client.instance);
		_defaultClasses.set("Timer", Timer);
	}

	public var classes(get, null):Map<String, Dynamic>;
	private function get_classes():Map<String, Dynamic> {
		return _defaultClasses;
	}
	
	public function addClass(name:String, cls:Dynamic):Void {
		_defaultClasses.set(name, cls);
	}
	
	public function executeScript<T>(script:String):Null<T> {
		if(script == null) return null;
		var retVal = null;
		
		try {
			var parser = new hscript.Parser();
			var program = parser.parseString(script);
			var interp = new ScriptInterp();
			
			retVal = interp.execute(program);
			
			#if (cpp && haxe_ver >= 3.3)
			    // workaround for https://github.com/HaxeFoundation/hxcpp/issues/489
			    if (retVal == null) retVal = cast script;
			#end
		} catch (e:Dynamic) {
			//trace("Problem running script: " + e);
			//trace(script);
			retVal = cast script;
		}
		return retVal;
	}
}
