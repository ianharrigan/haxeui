package haxe.ui.samples.hello_world;

import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;

class HelloWorldCSSSample extends HelloWorldSample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		Macros.addStyleSheet("samples/helloworld/hello.css");
		super.run(root);
	}
}