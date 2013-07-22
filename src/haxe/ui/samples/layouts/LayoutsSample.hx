package haxe.ui.samples.layouts;

import haxe.ui.samples.Sample;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;

class LayoutsSample extends Sample {

	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		root.addChild(new LayoutsController().view);
	}
}

private class LayoutsController extends XMLController {
	public function new() {
		super("samples/layouts/layouts.xml");
	}
}