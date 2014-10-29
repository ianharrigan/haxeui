package haxe.ui.toolkit.util;

class XmlUtil {
	public static function getPathValues(xml:Xml, path:String):Array<String> {
		var values:Array<String> = new Array<String>();
		var parts:Array<String> = path.split("/");
		for (p in parts) {
			if (p.length == 0) {
				parts.remove(p);
			}
		}

		var matchToFind:String = parts[0];
		parts.remove(matchToFind);
		if (xml.nodeName == matchToFind) {
			if (parts.length > 1) {
				for (child in xml.elements()) {
					values = values.concat(getPathValues(child, parts.join("/")));
				}
			} else {
				matchToFind = parts.pop();
				if (StringTools.startsWith(matchToFind, "@")) {
					var attrName:String = matchToFind.substr(1, matchToFind.length);
					var attrValue:String = xml.get(attrName);
					if (attrValue != null) {
						values.push(attrValue);
					}
				} else if (matchToFind == "text()") {
					var nodeValue:String = xml.firstChild().nodeValue;
					if (nodeValue != null) {
						values.push(nodeValue);
					}
				}
			}
		}
		return values;
	}
}