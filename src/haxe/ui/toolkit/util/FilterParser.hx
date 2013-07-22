package haxe.ui.toolkit.util;

import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;

class FilterParser {
	private static var filterParamDefaults = {
		blur: ["4", "4", "1"],
		dropShadow: ["4", "45", "0", "1", "4", "4", "1", "1", "false", "false", "false"],
		glow: ["16711680", "1", "6", "6", "2", "1", "false", "false"]
	};
	
	public static function parseFilter(filterString:String):BitmapFilter {
		#if (html5)
			return null;
		#end
		var filter:BitmapFilter = null;
		var filterName:String = null;
		var filterParams:String = null;
		
		var n1:Int = filterString.indexOf("(");
		var n2:Int = filterString.indexOf(")");
		if (n1 != -1 && n2 != -1) {
			filterName = filterString.substr(0, n1);
			filterParams = filterString.substr(n1 + 1, n2 - n1 - 1);
		} else {
			filterName = filterString;
		}
		
		if (filterName != null) {
			filterName = StringTools.trim(filterName);
			filter = createFilter(filterName, filterParams);
		}
		
		return filter;
	}
	
	public static function createFilter(filterName:String, filterParams:String):BitmapFilter {
		var filter:BitmapFilter = null;

		var params:Array<String> = null;
		if (filterParams != null) {
			params = filterParams.split(",");
		}
		
		params = copyFilterDefaults(filterName, params);
		
		if (filterName == "blur") {
			filter = createBlurFilter(params);
		} else if (filterName == "dropShadow") {
			filter = createDropShadowFilter(params);
		} else if (filterName == "glow") {
			filter = createGlowFilter(params);
		}
		
		return filter;
	}

	// blurX : Float = 4, blurY : Float = 4, quality : Int = 1
	private static function createBlurFilter(params:Array<String>):BlurFilter {
		var filter:BlurFilter = new BlurFilter(
			TypeParser.parseFloat(params[0]), // blurX
			TypeParser.parseFloat(params[1]), // blurY
			TypeParser.parseInt(params[2]) // quality
		);
		return filter;
	}
	
	// ?distance : Float, ?angle : Float, ?color : UInt, ?alpha : Float, ?blurX : Float, ?blurY : Float, ?strength : Float, ?quality : Int, ?inner : Bool, ?knockout : Bool, ?hideObject : Bool 
	private static function createDropShadowFilter(params:Array<String>):DropShadowFilter {
		var filter:DropShadowFilter = new DropShadowFilter(
			TypeParser.parseFloat(params[0]), // distance
			TypeParser.parseFloat(params[1]), // angle
			TypeParser.parseInt(params[2]), // color
			TypeParser.parseFloat(params[3]), // alpha
			TypeParser.parseFloat(params[4]), // blurX
			TypeParser.parseFloat(params[5]), // blurY
			TypeParser.parseFloat(params[6]), // strength
			TypeParser.parseInt(params[7]), // quality
			TypeParser.parseBool(params[8]), // inner
			TypeParser.parseBool(params[9]), // knockout
			TypeParser.parseBool(params[10]) // hideObject
		);
		return filter;
	}
	
	// color : UInt = 16711680, alpha : Float = 1, blurX : Float = 6, blurY : Float = 6, strength : Float = 2, quality : Int = 1, inner : Bool = false, knockout : Bool = false
	private static function createGlowFilter(params:Array<String>):GlowFilter {
		var filter:GlowFilter = new GlowFilter(
			TypeParser.parseInt(params[0]), // color
			TypeParser.parseFloat(params[1]), // alpha
			TypeParser.parseFloat(params[2]), // blurX
			TypeParser.parseFloat(params[3]), // blurY
			TypeParser.parseFloat(params[4]), // strength
			TypeParser.parseInt(params[5]), // quality
			TypeParser.parseBool(params[6]), // inner
			TypeParser.parseBool(params[7]) // knockout
		);
		return filter;
	}
	
	private static function copyFilterDefaults(filterName:String, params:Array<String>):Array<String> {
		var copy:Array<String> = new Array<String>();
		
		var defaultParams:Array<String> = Reflect.field(filterParamDefaults, filterName);
		if (defaultParams != null) {
			for (p in defaultParams) {
				copy.push(p);
			}
		}
		if (params != null) {
			var n:Int = 0;
			for (p in params) {
				copy[n] = p;
				n++;
			}
		}
		
		return copy;
	}
}