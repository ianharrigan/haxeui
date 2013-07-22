package haxe.ui.samples.accordion;

import haxe.ui.samples.Sample;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;

class AccordionSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		root.addChild(new AccordionController().view);
	}
}

private class AccordionController extends XMLController {
	public function new() {
		super("samples/accordion/accordion.xml");
	}
}