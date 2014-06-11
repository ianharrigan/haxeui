package;

import haxe.ui.toolkit.core.Toolkit;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.controls.TabBar;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.core.Macros;

class Main {
	public static function main() {
		Macros.addStyleSheet("../../assets/styles/gradient/gradient.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new SampleController().view);
		});
	}
}

private class SampleController extends XMLController {
	public function new() {
		super("assets/tabs.xml");
		
		var tabbar:TabBar = getComponentAs("tabbar", TabBar);
		if (tabbar != null) {
			tabbar.addTab("bob 1");
			tabbar.addTab("bob 2");
			tabbar.addTab("bob 3");
			tabbar.addTab("bob 4");
		}
		
		var hbox:HBox = getComponentAs("hbox", HBox);
		if (hbox != null) {
			trace(hbox.numChildren);
		}
	}
}