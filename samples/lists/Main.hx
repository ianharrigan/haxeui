package;

import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.themes.GradientTheme;

class Main {
	public static function main() {
		Toolkit.theme = new GradientTheme();
		Toolkit.init();
		Toolkit.openFullscreen(function(root:Root) {
			var list:ListView = new ListView();
			list.width = 300;
			list.height = 300;
			for (n in 0...30) { 

				list.dataSource.add( { text:"Item " + n } );
			}
			root.addChild(list);
		});
	}
}
