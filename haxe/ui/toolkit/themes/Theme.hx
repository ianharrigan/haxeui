package haxe.ui.toolkit.themes;

import haxe.ds.HashMap;
import haxe.macro.Expr.Var;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.style.StyleParser;
import haxe.ui.toolkit.style.Styles;

class Theme {
	public var name(default, default):String;
	
	private static var assets:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
	
	public function new() {
	}
	
	public function apply():Void {
		applyAssetList(name);
		applyAssetList("__PUBLIC__");
	}
	
	private function applyAssetList(n:String):Void {
		var list:Array<Dynamic> = assets.get(n);
		if (list == null) {
			return;
		}

		for (asset in list) {
			applyAsset(asset);
		}
	}
	
	private function applyAsset(asset:Dynamic):Void {
		if (Std.is(asset, String)) {
			if (StringTools.endsWith(asset, ".css")) {
				StyleManager.instance.addStyles(StyleParser.fromString(ResourceManager.instance.getText(asset)));
			}
		} else if (Std.is(asset, Class)) {
			var styles:Styles = Type.createInstance(asset, []);
			if (styles != null) {
				StyleManager.instance.addStyles(styles);
			}
		}
	}
	
	public static function addPublicAsset(asset:Dynamic):Void {
		addAsset("__PUBLIC__", asset);
	}
	
	public static function addAsset(t:String, asset:Dynamic):Void {
		var list:Array<Dynamic> = assets.get(t);
		if (list == null) {
			list = new Array<Dynamic>();
			assets.set(t, list);
		}
		list.push(asset);
	}
}