package haxe.ui.samples.hello_world;

import flash.events.MouseEvent;
import haxe.ui.samples.Sample;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;

class HelloWorldControllerSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		root.addChild(new HelloWorldController().view);
	}
}

private class HelloWorldController extends XMLController {
	public function new() {
		super("samples/helloworld/hello.xml");
		
		attachEvent("button", MouseEvent.CLICK, function(e) {
			getComponentAs("label", Text).text = "Thanks!";
		});
	}
}