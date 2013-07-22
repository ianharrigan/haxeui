package haxe.ui.samples.lists;

import flash.events.MouseEvent;
import haxe.ui.samples.Sample;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.core.Root;

class ListsSample extends Sample {
	public function new() {
		super();
	}
	
	public override function run(root:Root):Void {
		var list:ListView = new ListView();
		list.width = 300;
		list.height = 300;
		for (n in 0...30) { 
			 
			list.dataSource.add( { text:"Item " + n } );
		}
		root.addChild(list);
		
		root.addEventListener(MouseEvent.CLICK, function(e) {
			list.invalidate();
		});
	}
}