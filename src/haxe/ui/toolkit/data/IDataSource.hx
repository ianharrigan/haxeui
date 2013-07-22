package haxe.ui.toolkit.data;

interface IDataSource {
	public var id(get, set):String;
	public function create(config:Xml):Void;
	
	public function open():Bool;
	public function close():Bool;
	public function moveFirst():Bool;
	public function moveNext():Bool;
	public function get():Dynamic;
	public function add(o:Dynamic):Bool;
	public function update(o:Dynamic):Bool;
	public function remove():Bool;
	public function hash():String;
}