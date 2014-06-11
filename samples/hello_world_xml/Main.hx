package;

import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.core.Macros;

class Main {
	public static function main() {
		Macros.addStyleSheet("../../assets/styles/gradient/gradient.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			var xml:Xml = Xml.parse(ResourceManager.instance.getText("assets/hello.xml"));
			var ui:IDisplayObjectContainer = Toolkit.processXml(xml);
			ui.findChild("button").addEventListener(MouseEvent.CLICK, function(e) {
				ui.findChild("label", Text).text = "Thanks!";
			});
			root.addChild(ui);
		});
	}
}
