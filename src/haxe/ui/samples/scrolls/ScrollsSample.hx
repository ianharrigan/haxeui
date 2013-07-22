package haxe.ui.samples.scrolls;

import haxe.ui.samples.Sample;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;

class ScrollsSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		root.addChild(new ScrollsController().view);
	}
}

private class ScrollsController extends XMLController {
	public function new() {
		super("samples/scrolls/scrolls.xml");
	}
}