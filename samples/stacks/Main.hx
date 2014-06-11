package;

import haxe.ui.toolkit.core.Toolkit;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.core.Macros;

class Main {
	public static function main() {
		Macros.addStyleSheet("../../assets/styles/gradient/gradient.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new StacksController().view);
		});
	}
}

private class StacksController extends XMLController {
	public function new() {
		super("assets/stacks.xml");
		
		attachEvent("showStack1", MouseEvent.CLICK, function(e) {
			showStack1();
		});
		attachEvent("showStack2", MouseEvent.CLICK, function(e) {
			showStack2();
		});
		attachEvent("showStack3", MouseEvent.CLICK, function(e) {
			showStack3();
		});
		attachEvent("showStack4", MouseEvent.CLICK, function(e) {
			showStack4();
		});
	}
	
	private function showStack1():Void {
		getComponentAs("stacks", Stack).selectedIndex = 0;
	}

	private function showStack2():Void {
		getComponentAs("stacks", Stack).selectedIndex = 1;
	}

	private function showStack3():Void {
		getComponentAs("stacks", Stack).selectedIndex = 2;
	}

	private function showStack4():Void {
		getComponentAs("stacks", Stack).selectedIndex = 3;
	}
}