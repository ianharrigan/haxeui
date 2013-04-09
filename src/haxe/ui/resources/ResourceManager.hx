package haxe.ui.resources;
import haxe.Resource;
import nme.Assets;
import nme.display.BitmapData;
import nme.utils.ByteArray;

class ResourceManager {
	public static var defaultResType:String = "asset";
	
	public static function getBitmapData(resourceId:String):BitmapData {
		var resInfo:ResourceInfo = processResourceId(resourceId);
		var bmp:BitmapData = null;
		
		if (resInfo.type == "asset") {
			bmp = Assets.getBitmapData(resInfo.id);
		} else if (resInfo.type == "embedded") {
			#if !(flash || neko || html5)
			var bytes:haxe.io.Bytes = Resource.getBytes(resInfo.id);
			bmp = BitmapData.loadFromHaxeBytes(ByteArray.fromBytes(bytes));
			#else
			bmp = Assets.getBitmapData(resInfo.id);
			#end
		}
		
		return bmp;
	}
	
	public static function getText(resourceId:String, locale:String = null):String {
		var resInfo:ResourceInfo = processResourceId(resourceId);
		var str:String = null;

		if (resInfo.type == "asset") {
			str = Assets.getText(resInfo.id);
		} else if (resInfo.type == "embedded") {
			str = Resource.getString(resInfo.id);
		}
		return str;
	}
	
	private static function processResourceId(resourceId:String):ResourceInfo {
		var resType:String = defaultResType;
		if (resourceId.indexOf("://") != -1) {
			var arr:Array<String> = resourceId.split("://");
			resType = StringTools.trim(arr[0]);
			resourceId = StringTools.trim(arr[1]);
		}
		
		#if (flash || neko)
			resType = "asset";
		#end
		#if (html5)
			resType = "embedded";
		#end
		
		var info:ResourceInfo = new ResourceInfo();
		info.type = resType;
		info.id = resourceId;
		
		return info;
	}
}

class ResourceInfo {
	public function new() {
		
	}
	
	public var type:String;
	public var id:String;
}