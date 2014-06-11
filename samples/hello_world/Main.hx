package;

import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Text;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.core.Macros;

class Main {
	public static function main() {
		//Macros.addStyleSheet("../../assets/styles/gradient/gradient.css");
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
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
		});
	}
}
