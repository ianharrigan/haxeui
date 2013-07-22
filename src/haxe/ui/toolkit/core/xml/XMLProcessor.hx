package haxe.ui.toolkit.core.xml;

class XMLProcessor implements IXMLProcessor {
	public function new() {
		
	}
	
	public function process(node:Xml):Dynamic {
		return null;
	}
	
	public function stripNamespace(nodeName:String):String {
		var nodeNS:String = null;
		var n:Int = nodeName.indexOf(":");
		if (n != -1) {
			nodeNS = nodeName.substr(0, n);
			nodeName = nodeName.substr(n + 1, nodeName.length);
		}
		
		return nodeName;
	}
}