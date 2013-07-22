package haxe.ui.toolkit.core;

import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.core.Toolkit;

class XMLController extends Controller {
	public function new(xmlResourceId:String) {
		super(Toolkit.processXml(Xml.parse(ResourceManager.instance.getText(xmlResourceId))));
	}
}