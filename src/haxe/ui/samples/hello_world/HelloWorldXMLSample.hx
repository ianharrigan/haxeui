package haxe.ui.samples.hello_world;

import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import haxe.ui.samples.Sample;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.interfaces.IDisplayObjectContainer;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.resources.ResourceManager;

class HelloWorldXMLSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		var xml:Xml = Xml.parse(ResourceManager.instance.getText("samples/helloworld/hello.xml"));
		var ui:IDisplayObjectContainer = Toolkit.processXml(xml);
		ui.findChild("button").addEventListener(MouseEvent.CLICK, function(e) {
			ui.findChild("label", Text).text = "Thanks!";
		});
		root.addChild(ui);
	}
}
