package haxe.ui.toolkit.data;

class ArrayDataSource extends DataSource {
	private var array:Array<Dynamic>;
	private var pos:Int = 0;
	
	public function new() {
		super();
		array = new Array<Dynamic>();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function create(config:Xml):Void {
		super.create(config);
		
		var resource:String = config.get("resource");
		var delimeter:String = config.get("delimeter");
		if (delimeter == null) {
			delimeter = ",";
		}
		var nodeText:String = null;
		if (config.firstChild() != null) {
			nodeText = config.firstChild().nodeValue;
		}
		
		if (nodeText != null) {
			var arr:Array<String> = nodeText.split(delimeter);
			if (arr != null) {
				for (s in arr) {
					var o = { text: StringTools.trim(s) };
					add(o);
				}
			}
		}
	}
	
	private override function _moveFirst():Bool {
		pos = 0;
		if (array == null || array.length == 0) {
			return false;
		}
		return true;
	}
	
	private override function _moveNext():Bool {
		if (array == null || array.length == 0) {
			return false;
		}
		var b:Bool = false;
		if (pos + 1 < array.length) {
			pos += 1;
			b = true;
		}
		
		return b;
	}
	
	private override function _get():Dynamic {
		if (array == null || array.length == 0) {
			return null;
		}
		return array[pos];
	}
	
	private override function _add(o:Dynamic):Bool {
		array.push(o);
		return true;
	}
	
	private override function _remove():Bool {
		return array.remove(get());
	}
}