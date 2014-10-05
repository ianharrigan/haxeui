package haxe.ui.toolkit.hscript;

import hscript.Interp;

class ScriptInterp extends Interp {
	public function new() {
		super();
		var defaultClasses:Map<String, Class<Dynamic>> = ScriptManager.instance.classes;
		for (name in defaultClasses.keys()) {
			var c:Class<Dynamic> = defaultClasses.get(name);
			try {
				var inst = Type.createInstance(c, []);
				if (Std.is(inst, Std)) {
					throw "Not sure why";
				}
				this.variables.set(name, inst);
			} catch (e:Dynamic) {
				this.variables.set(name, c);
			}
		}
	}
	
	override function get( o : Dynamic, f : String ) : Dynamic {
		if( o == null ) throw hscript.Expr.Error.EInvalidAccess(f);
		return Reflect.getProperty(o,f);
    }

    override function set( o : Dynamic, f : String, v : Dynamic ) : Dynamic {
		if( o == null ) throw hscript.Expr.Error.EInvalidAccess(f);
		Reflect.setProperty(o,f,v);
		return v;
    }
}