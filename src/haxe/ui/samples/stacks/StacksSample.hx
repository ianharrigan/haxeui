package haxe.ui.samples.stacks;

import flash.events.MouseEvent;
import haxe.ui.samples.Sample;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;

class StacksSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		root.addChild(new LayoutsController().view);
	}
}

private class LayoutsController extends XMLController {
	public function new() {
		super("samples/stacks/stacks.xml");
		
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