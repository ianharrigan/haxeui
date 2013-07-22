package haxe.ui.toolkit.data;

import haxe.Json;

class JSONDataSource extends ArrayDataSource {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function create(config:Xml):Void {
		//super.create(config);
		
		var resource:String = config.get("resource");

		var nodeText:String = null;
		if (config.firstChild() != null) {
			nodeText = config.firstChild().nodeValue;
		}
		
		if (nodeText != null) {
			var jsonObject:Dynamic = Json.parse(nodeText);
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