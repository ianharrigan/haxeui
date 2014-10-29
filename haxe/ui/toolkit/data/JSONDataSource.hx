package haxe.ui.toolkit.data;

import haxe.Json;
import haxe.ui.toolkit.resources.ResourceManager;

class JSONDataSource extends ArrayDataSource {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function create(config:Xml = null):Void {
		//super.create(config);
		if (config == null) {
			return;
		}
		
		_id = config.get("id");
		
		var resource:String = config.get("resource");
		if (resource != null) {
			createFromResource(resource);
		}
		
		var nodeText:String = null;
		if (config.firstChild() != null) {
			nodeText = config.firstChild().nodeValue;
		}
		
		if (nodeText != null) {
			createFromString(nodeText);
		}
	}
	
	//******************************************************************************************
	// Helpers
	//******************************************************************************************
	public override function createFromString(data:String = null, config:Dynamic = null):Void {
		if (data != null) {
			var jsonObject:Dynamic = Json.parse(data);
			var arr:Array<Dynamic> = null;
			if (Std.is(jsonObject, Array)) {
				arr = cast(jsonObject, Array<Dynamic>);
				for (o in arr) {
					add(o);
				}
			}
		}
	}
}