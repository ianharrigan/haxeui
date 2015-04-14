package haxe.ui.toolkit.resources;

import openfl.display.BitmapData;

interface IResourceHook {
	function getBitmapData(resourceId:String, locale:String = null):BitmapData;
}