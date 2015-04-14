package haxe.ui.toolkit.resources;

import openfl.display.BitmapData;
import openfl.utils.ByteArray;

interface IResourceHook {
	function getBitmapData(resourceId:String, locale:String = null):BitmapData;
	function getText(resourceId:String, locale:String = null):String;
	function getBytes(resourceId:String, locale:String = null):ByteArray;
}