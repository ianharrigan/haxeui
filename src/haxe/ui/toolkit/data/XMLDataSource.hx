package haxe.ui.toolkit.data;

class XMLDataSource extends ArrayDataSource {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function create(config:Xml):Void {
		super.create(config);
		
		var resource:String = config.get("resource");
	}
}