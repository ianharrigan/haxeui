package haxe.ui.samples.test;

import haxe.ui.samples.Sample;
import haxe.ui.toolkit.core.Root;

class TestSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		var controller:TestController = new TestController();
		root.addChild(controller.view);
	}
}