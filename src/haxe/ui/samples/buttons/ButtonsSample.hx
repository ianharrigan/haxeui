package haxe.ui.samples.buttons;

import haxe.ui.samples.Sample;
import haxe.ui.toolkit.core.Root;

class ButtonsSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		root.addChild(new ButtonsSampleController().view);
	}
}