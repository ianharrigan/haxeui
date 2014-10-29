package haxe.ui.toolkit.data;

import haxe.ui.toolkit.resources.ResourceManager;

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
	public override function create(config:Xml = null):Void {
		super.create(config);
		
		if (config == null) {
			return;
		}
		
		_id = config.get("id");
		
		var delimeter:String = config.get("delimeter");
		if (delimeter == null) {
			delimeter = ",";
		}
		delimeter = StringTools.replace(delimeter, "\\n", "\n");
		
		var resource:String = config.get("resource");
		if (resource != null) {
			createFromResource(resource, { delimeter: delimeter });
		}
		
		var nodeText:String = null;
		if (config.firstChild() != null) {
			nodeText = config.firstChild().nodeValue;
		}
		
		if (nodeText != null) {
			createFromString(nodeText, { delimeter: delimeter });
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
	
	public override function size():Int {
		return array.length;
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public override function createFromString(data:String = null, config:Dynamic = null):Void {
		if (data != null) {
			if (config == null) {
				config = { };
			}
			config.delimeter = (config.delimeter != null) ? config.delimeter : ",";
			
			var arr:Array<String> = data.split(config.delimeter);
			if (arr != null) {
				for (s in arr) {
					s = StringTools.trim(s);
					if (s.length > 0) {
						var o = { text: s };
						add(o);
					}
				}
			}
		}
	}
}