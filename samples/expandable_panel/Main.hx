package;

import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;

class Main {
	public static function main() {
		Macros.addStyleSheet("../../assets/styles/gradient/gradient.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new ExandandablePanelController().view);
		});
	}
}

private class ExandandablePanelController extends XMLController {
	public function new() {
		super("assets/expandablepanel.xml");
	}
}