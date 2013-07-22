package haxe.ui.toolkit.core.xml;

import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.style.StyleParser;
import haxe.ui.toolkit.style.Styles;

class StyleProcessor extends XMLProcessor {
	public function new() {
		super();
	}
	
	public override function process(node:Xml):Dynamic {
		var styleData:String = node.firstChild().nodeValue;
		styleData = StringTools.trim(styleData);
		var styles:Styles = StyleParser.fromString(styleData);
		StyleManager.instance.addStyles(styles);
		return null;
	}
}