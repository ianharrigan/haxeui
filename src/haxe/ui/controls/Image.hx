package haxe.ui.controls;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import haxe.ui.core.Component;

class Image extends Component {
	public var bitmapAssetPath(null, setBitmapAssetPath):String;
	
	private var bmp:Bitmap;
	private var bmpData:BitmapData;
	
	public function new() {
		super();
		addStyleName("Image");
	}
	
	//************************************************************
	//                  OVERRIDES
	//************************************************************
	public override function resize():Void {
		super.resize();
	}

	//************************************************************
	//                  GETTERS AND SETTERS
	//************************************************************
	public function setBitmapAssetPath(value:String):String {
		if (bmp != null && contains(bmp)) {
			removeChild(bmp);
			bmpData.dispose();
			bmp = null;
			bmpData = null;
		}
		
		bmpData = Assets.getBitmapData(value);
		if (bmpData != null) {
			bmp = new Bitmap(bmpData);
			addChild(bmp);
			if (autoSize == true) {
				bmp.x = padding.left;
				bmp.y = padding.top;
				width = Std.int(bmpData.width + padding.left + padding.right);
				height = Std.int(bmpData.height + padding.top + padding.bottom);
			}
		}
		return value;
	}
}