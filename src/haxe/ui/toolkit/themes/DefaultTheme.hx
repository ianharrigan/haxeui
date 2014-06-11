package haxe.ui.toolkit.themes;

import haxe.ui.toolkit.style.DefaultStyles;
import haxe.ui.toolkit.style.StyleManager;

class DefaultTheme extends Theme {
	public function new() {
		super();
		name = "default";
		Theme.addAsset(name, DefaultStyles);
	}
	
	/*
	public override function apply():Void {
		super.apply();
		StyleManager.instance.addStyles(new DefaultStyles());
	}
	*/
}