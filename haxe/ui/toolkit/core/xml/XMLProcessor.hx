package haxe.ui.toolkit.core.xml;

class XMLProcessor implements IXMLProcessor {
	public function new() {
		
	}
	
	public function process(node:Xml):Dynamic {
		return null;
	}
	
	public function stripNamespace(nodeName:String):String {
		var n:Int = nodeName.indexOf(":");
		if (n != -1) {
			nodeName = nodeName.substr(n + 1, nodeName.length);
		}
		nodeName = nodeName.toLowerCase();
		
		return nodeName;
	}
}