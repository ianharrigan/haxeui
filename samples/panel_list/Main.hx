package;

import haxe.ui.toolkit.core.Toolkit;
import flash.events.MouseEvent;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.core.Macros;

class Main {
	public static function main() {
		Macros.addStyleSheet("../../assets/styles/gradient/gradient.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new AccordionController().view);
		});
	}
}

private class AccordionController extends XMLController {
	public function new() {
		super("assets/panellist.xml");
	}
}