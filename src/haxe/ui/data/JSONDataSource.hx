package haxe.ui.data;
import haxe.ui.resources.ResourceManager;

class JSONDataSource extends ArrayDataSource {
	public function new(jsonString:String) {
		var jsonObject:Dynamic = Json.parse(jsonString);
		var array:Array<Dynamic> = null;
		if (Std.is(jsonObject, Array)) {
			array = cast(jsonObject, Array<Dynamic>);
		}
		super(array);
	}
	
	//************************************************************
	//                  HELPERS
	//************************************************************
	public static function fromResource(resourceId:String):JSONDataSource {
		var jsonString:String = ResourceManager.getText(resourceId);
		var ds = new JSONDataSource(jsonString);
		return ds;
	}
}