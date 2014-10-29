package;

import haxe.ui.toolkit.core.Toolkit;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.themes.GradientTheme;

class Main {
	public static function main() {
		Toolkit.theme = new GradientTheme();
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new CodeEditorController().view);
		});
	}
}

private class CodeEditorController extends XMLController {
	public function new() {
		super("assets/code_editor.xml");
	}
}