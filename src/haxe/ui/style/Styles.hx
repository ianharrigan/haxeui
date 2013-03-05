package haxe.ui.style;

class Styles {
	var styles:Hash<Dynamic>;
	
	public var styleNames(getStyleNames, null):Iterator<String>;
	
	public function new() {
		styles = new Hash<Dynamic>();
	}
	
	public function addStyle(styleName:String, style:Dynamic):Dynamic {
		styles.set(styleName, style);
		return style;
	}
	
	public function getStyle(styleName:String):Dynamic {
		return styles.get(styleName);
	}
	
	public function getStyleNames():Iterator<String> {
		return styles.keys();
	}
}