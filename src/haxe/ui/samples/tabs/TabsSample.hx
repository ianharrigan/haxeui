package haxe.ui.samples.tabs;

import haxe.ui.samples.Sample;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;

class TabsSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		root.addChild(new TabsController().view);
	}
}

private class TabsController extends XMLController {
	public function new() {
		super("samples/tabs/tabs.xml");
	}
}