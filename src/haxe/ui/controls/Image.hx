package haxe.ui.controls;

import haxe.ui.resources.ResourceManager;
import nme.display.Bitmap;
import nme.display.BitmapData;
import haxe.ui.core.Component;

class Image extends Component {
	public var resourceId(null, setResourceId):String;
	
	private var bmp:Bitmap;
	private var bmpData:BitmapData;
	
	public function new() {
		super();
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
	public function setResourceId(value:String):String {
		if (bmp != null && contains(bmp)) {
			removeChild(bmp);
			bmpData.dispose();
			bmp = null;
			bmpData = null;
		}
		
		bmpData = ResourceManager.getBitmapData(value);
		if (bmpData != null) {
			bmp = new Bitmap(bmpData);
			addChild(bmp);
			if (autoSize == true) {
				bmp.x = layout.padding.left;
				bmp.y = layout.padding.top;
				width = Std.int(bmpData.width + layout.padding.left + layout.padding.right);
				height = Std.int(bmpData.height + layout.padding.top + layout.padding.bottom);
			}
		}
		return value;
	}
}