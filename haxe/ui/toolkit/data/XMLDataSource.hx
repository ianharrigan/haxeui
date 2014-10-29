package haxe.ui.toolkit.data;

class XMLDataSource extends ArrayDataSource {
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
			nodeText = config.firstElement().toString();
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
			var xml:Xml = Xml.parse(data);
			if (xml != null) {
				var it:Iterator<Xml> = xml.firstElement().elements();
				for (e in it) {
					var o = { };
					for (attrName in e.attributes()) {
						Reflect.setField(o, attrName, e.get(attrName));
					}
					if (Reflect.fields(o).length != 0) {
						add(o);
					}
				}
			}
		}
	}
}