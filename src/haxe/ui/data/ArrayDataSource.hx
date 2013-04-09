package haxe.ui.data;

class ArrayDataSource extends DataSource {
	private var array:Array<Dynamic>;
	
	private var pos:Int = 0;
	
	public function new(array:Array<Dynamic> = null) {
		super();
		this.array = array;
		if (this.array == null) {
			this.array = new Array<Dynamic>();
		}
 	}
	
	private override function internalMoveFirst():Bool {
		pos = 0;
		if (array == null || array.length == 0) {
			return false;
		}
		return true;
	}
	
	private override function internalMoveNext():Bool {
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
	
	private override function internalGet():Dynamic {
		if (array == null || array.length == 0) {
			return null;
		}
		return array[pos];
	}
	
	private override function internalAdd(o:Dynamic):Bool {
		array.push(o);
		return true;
	}
	
	private override function internalRemove():Bool {
		return array.remove(get());
	}
}