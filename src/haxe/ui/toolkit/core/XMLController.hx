package haxe.ui.toolkit.core;

import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.resources.ResourceManager;

class XMLController extends Controller {
	public function new(xmlResourceId:String) {
		super(Toolkit.processXml(Xml.parse(ResourceManager.instance.getText(xmlResourceId))));
	}
}