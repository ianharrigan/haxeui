package haxe.ui.toolkit.data;

class MySQLDataSource extends DataSource {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	public override function create(config:Xml):Void {
		super.create(config);
		
		var connectionString:String = config.get("connectionString");
	}
}