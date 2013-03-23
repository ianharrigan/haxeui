package haxe.ui.style;
import haxe.ui.resources.ResourceManager;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.GradientType;
import nme.display.Graphics;
import nme.display.InterpolationMethod;
import nme.display.SpreadMethod;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;

class StyleHelper {
	private static var sectionCache:Hash<BitmapData>;
	
	public static function paintCompoundBitmap(g:Graphics, resourceId:String, resourceRect:Rectangle, sourceRects:Hash<Rectangle>, targetRect:Rectangle):Void {
		targetRect.left = Std.int(targetRect.left);
		targetRect.top = Std.int(targetRect.top);
		targetRect.right = Std.int(targetRect.right);
		targetRect.bottom = Std.int(targetRect.bottom);
		
		// top row
		var tl:Rectangle = sourceRects.get("top.left");
		if (tl != null) {
			paintBitmapSection(g, resourceId, resourceRect, tl, new Rectangle(0, 0, tl.width, tl.height));
		} else {
			tl = new Rectangle();
		}
		
		var tr:Rectangle = sourceRects.get("top.right");
		if (tr != null) {
			paintBitmapSection(g, resourceId, resourceRect, tr, new Rectangle(targetRect.width - tr.width, 0, tr.width, tr.height));
		} else {
			tr = new Rectangle();
		}

		var t:Rectangle = sourceRects.get("top");
		if (t != null) {
			paintBitmapSection(g, resourceId, resourceRect, t, new Rectangle(tl.width, 0, (targetRect.width - tl.width - tr.width), t.height));
		} else {
			t = new Rectangle();
		}
		
		// bottom row
		var bl:Rectangle = sourceRects.get("bottom.left");
		if (bl != null) {
			paintBitmapSection(g, resourceId, resourceRect, bl, new Rectangle(0, targetRect.height - bl.height, bl.width, bl.height));
		} else {
			bl = new Rectangle();
		}

		var br:Rectangle = sourceRects.get("bottom.right");
		if (br != null) {
			paintBitmapSection(g, resourceId, resourceRect, br, new Rectangle(targetRect.width - br.width, targetRect.height - br.height, br.width, br.height));
		} else {
			br = new Rectangle();
		}

		var b:Rectangle = sourceRects.get("bottom");
		if (b != null) {
			paintBitmapSection(g, resourceId, resourceRect, b, new Rectangle(bl.width, targetRect.height - b.height, (targetRect.width - bl.width - br.width), b.height));
		} else {
			b = new Rectangle();
		}
		
		// middle row
		var l:Rectangle = sourceRects.get("left");
		if (l != null) {
			paintBitmapSection(g, resourceId, resourceRect, l, new Rectangle(0, tl.height, l.width, (targetRect.height - tl.height - bl.height)));
		} else {
			l = new Rectangle();
		}

		var r:Rectangle = sourceRects.get("right");
		if (r != null) {
			paintBitmapSection(g, resourceId, resourceRect, r, new Rectangle(targetRect.width - r.width, tr.height, r.width, (targetRect.height - tl.height - bl.height)));
		} else {
			r = new Rectangle();
		}

		var m:Rectangle = sourceRects.get("middle");
		if (m != null) {
			paintBitmapSection(g, resourceId, resourceRect, m, new Rectangle(l.width, t.height, (targetRect.width - l.width - r.width), (targetRect.height - t.height - b.height)));
		} else {
			m = new Rectangle();
		}
	}

	public static function paintBitmapSection(g:Graphics, resourceId:String, resourceRect:Rectangle, src:Rectangle, dst:Rectangle):Void {
		var srcData:BitmapData = getBitmapSection(resourceId, resourceRect);
		if (srcData == null) {
			return;
		}
		
		if (resourceRect == null) {
			resourceRect = new Rectangle(0, 0, srcData.width, srcData.height);
		}
		
		var cacheId:String = resourceId + "_" + resourceRect.left + "_" + resourceRect.top + "_" + resourceRect.width + "_" + resourceRect.height + "___" + src.left + "_" + src.top + "_" + src.width + "_" + src.height;
		var section:BitmapData = sectionCache.get(cacheId);
		if (section == null) {
			var fillcolor = #if (neko) {rgb:0x00FFFFFF, a:0 }; #else 0x00FFFFFF; #end
			section = new BitmapData(Std.int(src.width), Std.int(src.height), true, fillcolor);
			section.copyPixels(srcData, src, new Point(0, 0));
			sectionCache.set(cacheId, section);
		}

		src.left = Std.int(src.left);
		src.top = Std.int(src.top);
		src.bottom = Std.int(src.bottom);
		src.right = Std.int(src.right);
		dst.left = Std.int(dst.left);
		dst.top = Std.int(dst.top);
		dst.bottom = Std.int(dst.bottom);
		dst.right = Std.int(dst.right);
		
		var mat:Matrix = new Matrix();
        mat.scale(dst.width / section.width, dst.height / section.height);
        mat.translate(dst.left, dst.top);
		
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(section, mat, false, false);
        g.drawRect(dst.x, dst.y, dst.width, dst.height);
        g.endFill();
	}
	
	private static function getBitmapSection(resourceId:String, rc:Rectangle = null):BitmapData {
		if (sectionCache == null) {
			sectionCache = new Hash<BitmapData>();
		}
		
		if (rc == null) {
			var resource:BitmapData = ResourceManager.getBitmapData(resourceId);
			if (resource != null) {
				rc = new Rectangle(0, 0, resource.width, resource.height);
			}
		}

		var cacheId:String = resourceId + "_" + rc.left + "_" + rc.top + "_" + rc.width + "_" + rc.height;
		var section:BitmapData = sectionCache.get(cacheId);
		
		if (section == null) {
			var resource:BitmapData = ResourceManager.getBitmapData(resourceId);
			if (resource != null) {
				var fillcolor = #if (neko) {rgb:0x00FFFFFF, a:0 }; #else 0x00FFFFFF; #end
				section = new BitmapData(Std.int(rc.width), Std.int(rc.height), true, fillcolor);
				section.copyPixels(resource, rc, new Point(0, 0));
				sectionCache.set(cacheId, section);
			}
		}
		
		return section;
	}
	
	public static function paintStyle(g:Graphics, style:Dynamic, rc:Rectangle):Void {
		g.clear();
		if (style.backgroundColor != null || style.borderColor != null) {
			if (style.borderColor != null) {
				var borderSize:Int = 1;
				if (style.borderSize != null) {
					borderSize = style.borderSize;
				}
				if (borderSize > 0) {
					g.lineStyle(0, style.borderColor);
					rc.inflate( -(borderSize / 2), -(borderSize / 2));
				}
			}
			
			if (style.backgroundColor != null) {
				if (style.backgroundColorGradientEnd != null) {
					var w:Int = Std.int(rc.width);
					var h:Int = Std.int(rc.height);
					var colors:Array<Int> = [style.backgroundColor, style.backgroundColorGradientEnd];
					var alphas:Array<Int> = [1, 1];
					var ratios:Array<Int> = [0, 255];
					var matrix:Matrix = new Matrix();
					matrix.createGradientBox(w-2, h-2, Math.PI/2, 0, 0);				
									
					g.beginGradientFill(GradientType.LINEAR, 
													colors,
													alphas,
													ratios, 
													matrix, 
													SpreadMethod.PAD, 
													InterpolationMethod.LINEAR_RGB, 
													0);
				} else {
					g.beginFill(style.backgroundColor);
				}
			}
			
			if (style.cornerRadius != null || style.cornerRadiusTopLeft != null || style.cornerRadiusTopRight != null || style.cornerRadiusBottomLeft != null || style.cornerRadiusBottomRight != null) {
				var radiusTopLeft:Float = (style.cornerRadius != null) ? style.cornerRadius : 0;
				var radiusTopRight:Float = (style.cornerRadius != null) ? style.cornerRadius : 0;
				var radiusBottomLeft:Float = (style.cornerRadius != null) ? style.cornerRadius : 0;
				var radiusBottomRight:Float = (style.cornerRadius != null) ? style.cornerRadius : 0;
				radiusTopLeft = (style.cornerRadiusTopLeft != null) ? style.cornerRadiusTopLeft : radiusTopLeft;
				radiusTopRight = (style.cornerRadiusTopRight != null) ? style.cornerRadiusTopRight : radiusTopRight;
				radiusBottomLeft = (style.cornerRadiusBottomLeft != null) ? style.cornerRadiusBottomLeft : radiusBottomLeft;
				radiusBottomRight = (style.cornerRadiusBottomRight != null) ? style.cornerRadiusBottomRight : radiusBottomRight;
				
				#if !(cpp || neko || html5)
					g.drawRoundRectComplex(rc.left, rc.top, rc.width, rc.height, radiusTopLeft, radiusTopRight, radiusBottomLeft, radiusBottomRight);
				#else
					g.drawRect(rc.left, rc.top, rc.width, rc.height);
				#end
			} else {
				g.drawRect(rc.left, rc.top, rc.width, rc.height);
			}
			
			g.endFill();
		}
		
		if (style.backgroundImage != null) {
			var backgroundImageRect:Rectangle = null;
			if (style.backgroundImageRect != null) {
				var arr:Array<String> = style.backgroundImageRect.split(",");
				backgroundImageRect = new Rectangle(Std.parseInt(arr[0]), Std.parseInt(arr[1]), Std.parseInt(arr[2]), Std.parseInt(arr[3]));
			}
			
			if (style.backgroundImageScale9 != null) {
				paintScale9(g, style.backgroundImage, backgroundImageRect, style.backgroundImageScale9, rc);
			} else {
				var rects:Hash<Rectangle> = new Hash<Rectangle>();
				var bitmapData:BitmapData = getBitmapSection(style.backgroundImage, backgroundImageRect);
				rects.set("middle", new Rectangle(0, 0, bitmapData.width, bitmapData.height));
				paintCompoundBitmap(g, style.backgroundImage, backgroundImageRect, rects, rc);
			}
		}
	}
	
	public static function paintScale9(g:Graphics, resourceId:String, resourceRect:Rectangle, scale9:String, rc:Rectangle):Void {
		if (scale9 != null) { // create parts
			var resource:BitmapData = getBitmapSection(resourceId, resourceRect);
			if (resource == null) {
				return;
			}
			
			var w:Int = resource.width;
			var h:Int = resource.height;
			var coords:Array<String> = scale9.split(",");
			var x1:Int = Std.parseInt(coords[0]);
			var y1:Int = Std.parseInt(coords[1]);
			var x2:Int = Std.parseInt(coords[2]);
			var y2:Int = Std.parseInt(coords[3]);
			
			var rects:Hash<Rectangle> = new Hash<Rectangle>();
			
			rects.set("top.left", new Rectangle(0, 0, x1, y1));
			rects.set("top", new Rectangle(x1, 0, x2 - x1, y1));
			rects.set("top.right", new Rectangle(x2, 0, w - x2, y1));
			
			rects.set("left", new Rectangle(0, y1, x1, y2 - y1));
			rects.set("middle", new Rectangle(x1, y1, x2 - x1, y2 - y1));
			rects.set("right", new Rectangle(x2, y1, w - x2, y2 - y1));
			
			rects.set("bottom.left", new Rectangle(0, y2, x1, h - y2));
			rects.set("bottom", new Rectangle(x1, y2, x2 - x1, h - y2));
			rects.set("bottom.right", new Rectangle(x2, y2, w - x2, h - y2));
			
			paintCompoundBitmap(g, resourceId, resourceRect, rects, rc);
		}
	}
	
	public static function paintIcon(g:Graphics, resourceId:String, pt:Point, srcData:BitmapData = null):Void {
		if (srcData == null) {
			srcData = ResourceManager.getBitmapData(resourceId);
		}
		var mat:Matrix = new Matrix();
		g.beginBitmapFill(srcData, mat);
        g.drawRect(pt.x, pt.y, srcData.width, srcData.height);
        g.endFill();
	}
}