package haxe.ui.samples.hello_world;

import flash.events.MouseEvent;
import haxe.ui.samples.Sample;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Root;

class HelloWorldSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		var vbox:VBox = new VBox();
		
		var label:Text = new Text();
		label.id = "label"; // for css
		label.text = "Hello World!";
		vbox.addChild(label);
		
		var button:Button = new Button();
		button.id = "button"; // for css
		button.text = "Click Me!";
		button.addEventListener(MouseEvent.CLICK, function(e) {
			label.text = "Thanks!";
		});
		vbox.addChild(button);
		
		root.addChild(vbox);
		
		
	}
}