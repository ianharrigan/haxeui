package haxe.ui.toolkit.data;

interface IDataSource {
	public var id(get, set):String;
	public var allowEvents(get, set):Bool;
	
	public function create(config:Xml = null):Void;
	public function createFromString(data:String = null, config:Dynamic = null):Void;
	public function createFromResource(resourceId:String, config:Dynamic = null):Void;
	
	public function open():Bool;
	public function close():Bool;
	public function moveFirst():Bool;
	public function moveNext():Bool;
	public function get():Dynamic;
	public function add(o:Dynamic):Bool;
	public function update(o:Dynamic):Bool;
	public function remove():Bool;
	public function removeAll():Void;
	public function hash():String;
	public function size():Int;
}