package haxe.ui.toolkit.themes;

import haxe.ui.toolkit.core.Macros;

class WindowsTheme extends Theme {
	public function new() {
		super();
		name = "windows";
	}
	
	public override function apply():Void {
		super.apply();
		Macros.addStyleSheet("styles/windows/windows.css");
		Macros.addStyleSheet("styles/windows/buttons.css");
		Macros.addStyleSheet("styles/windows/tabs.css");
		Macros.addStyleSheet("styles/windows/listview.css");
		Macros.addStyleSheet("styles/windows/scrolls.css");
		Macros.addStyleSheet("styles/windows/sliders.css");
		Macros.addStyleSheet("styles/windows/accordion.css");
		Macros.addStyleSheet("styles/windows/rtf.css");
		Macros.addStyleSheet("styles/windows/calendar.css");
		Macros.addStyleSheet("styles/windows/popups.css");
		Macros.addStyleSheet("styles/windows/menus.css");
	}
}