package haxe.ui.toolkit.themes;

import haxe.ui.toolkit.core.Macros;

class GradientTheme extends Theme {
	public function new() {
		super();
		name = "gradient";
		Theme.addAsset(name, "styles/gradient/gradient.css");
	}

	/*
	public override function apply():Void {
		super.apply();
		#if mobile
			Macros.addStyleSheet("styles/gradient/gradient_mobile.css");
		#else
			Macros.addStyleSheet("styles/gradient/gradient.css");
		#end
	}
	*/
}