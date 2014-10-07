package;

import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.themes.GradientTheme;

class Main {
	public static function main() {
		Toolkit.theme = new GradientTheme();
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