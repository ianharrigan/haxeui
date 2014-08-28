package haxe.ui.toolkit.style;

import haxe.ui.toolkit.core.Macros;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.InterpolationMethod;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import haxe.ds.StringMap;
import haxe.ui.toolkit.resources.ResourceManager;
#if svg
import format.SVG;
#end

class StyleHelper {
	private static var sectionCache:StringMap<BitmapData>;

	public static function clearCache():Void {
		sectionCache = new StringMap<BitmapData>();
	}
	
	public static function paintStyle(g:Graphics, style:Style, rc:Rectangle):Void {
		Macros.beginProfile();
		g.clear();
		if (style == null || rc.width == 0 || rc.height == 0) {
			Macros.endProfile();
			return;
		}
		
		if (style.backgroundColor != -1 || style.borderColor != -1) {
			if (style.borderColor != -1) {
				var borderSize:Int = 1;
				if (style.borderSize != -1) {
					borderSize = style.borderSize;
				}
				if (borderSize > 0) {
					g.lineStyle(borderSize, style.borderColor);
					rc.inflate( -(borderSize / 2), -(borderSize / 2));
					#if html5
						rc.x = Std.int(rc.x);
						rc.y = Std.int(rc.y);
					#end
				}
			}
			
			if (style.backgroundColor != -1) {
				if (style.backgroundColorGradientEnd != -1) {
					var w:Int = Std.int(rc.width);
					var h:Int = Std.int(rc.height);
					var colors:Array<UInt> = [style.backgroundColor, style.backgroundColorGradientEnd];
					var alphas:Array<Int> = [1, 1];
					var ratios:Array<Int> = [0, 255];
					var matrix:Matrix = new Matrix();
					
					var gradientType:String = "vertical";
					if (style.gradientType != null) {
						gradientType = style.gradientType;
					}
					
					if (gradientType == "vertical") {
						matrix.createGradientBox(w - 2, h - 2, Math.PI / 2, 0, 0);				
					} else if (gradientType == "horizontal") {
						matrix.createGradientBox(w - 2, h - 2, 0, 0, 0);				
					}
									
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
			
			if (style.cornerRadiusTopLeft != -1 || style.cornerRadiusTopRight != -1 || style.cornerRadiusBottomLeft != -1 || style.cornerRadiusBottomRight != -1) {
				var radiusTopLeft:Float = style.cornerRadiusTopLeft;
				var radiusTopRight:Float = style.cornerRadiusTopRight;
				var radiusBottomLeft:Float = style.cornerRadiusBottomLeft;
				var radiusBottomRight:Float = style.cornerRadiusBottomRight;
				
				#if !(cpp || neko || html5)
					g.drawRoundRectComplex(rc.left, rc.top, rc.width, rc.height, radiusTopLeft, radiusTopRight, radiusBottomLeft, radiusBottomRight);
				//#elseif (android)
					//g.drawRect(rc.left, rc.top, rc.width, rc.height);
				#else
					if (Std.int(radiusTopLeft) & Std.int(radiusTopRight) & Std.int(radiusBottomLeft) & Std.int(radiusBottomRight) == radiusTopLeft) {
						// this line will kill andriod 2.x based apps!
						g.drawRoundRect(rc.left, rc.top, rc.width, rc.height, radiusTopLeft + 2, radiusTopLeft + 2);
						//g.drawRect(rc.left, rc.top, rc.width, rc.height);
					} else {
						g.drawRect(rc.left, rc.top, rc.width, rc.height);
					}
				#end
			} else {
				g.drawRect(rc.left, rc.top, rc.width, rc.height);
			}
			
			g.endFill();
		}

		if (style.backgroundImage != null) {
            var backgroundImageRect:Rectangle = null;
            if (style.backgroundImageRect != null) {
                backgroundImageRect = style.backgroundImageRect;
            }
            if (style.backgroundImage.substr(-3).toLowerCase() != "svg") {
                // assume that if it is not svg, it is an image file
                if (style.backgroundImageScale9 != null) {
                    paintScale9(g, style.backgroundImage, backgroundImageRect, style.backgroundImageScale9, rc);
                } else {
                    var rects:StringMap<Rectangle> = new StringMap<Rectangle>();
                    var bitmapData:BitmapData = getBitmapSection(style.backgroundImage, backgroundImageRect);
                    if (bitmapData != null) {
                        rects.set("middle", new Rectangle(0, 0, bitmapData.width, bitmapData.height));
                        paintCompoundBitmap(g, style.backgroundImage, backgroundImageRect, rects, rc);
                    }
                }
            } else {
                // svg image!
				#if svg
                var svg:SVG = ResourceManager.instance.getSVG(style.backgroundImage);
                svg.render(g, rc.left, rc.top, cast rc.width, cast rc.height);
				#end
            }
		}
		Macros.endProfile();
	}

	public static function paintScale9(g:Graphics, resourceId:String, resourceRect:Rectangle, scale9:Rectangle, rc:Rectangle):Void {
		if (scale9 != null) { // create parts
			var resource:BitmapData = getBitmapSection(resourceId, resourceRect);
			if (resource == null) {
				return;
			}
			
			var w:Int = resource.width;
			var h:Int = resource.height;
			var x1:Int = Std.int(scale9.left);
			var y1:Int = Std.int(scale9.top);
			var x2:Int = Std.int(scale9.right);
			var y2:Int = Std.int(scale9.bottom);
			
			var rects:StringMap<Rectangle> = new StringMap<Rectangle>();
			
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
	
	public static function paintCompoundBitmap(g:Graphics, resourceId:String, resourceRect:Rectangle, sourceRects:StringMap<Rectangle>, targetRect:Rectangle):Void {
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
		
		if (src.width <= 0 || src.height <= 0 || dst.width <= 0 || dst.height <= 0) {
			return;
		}
		
		if (resourceRect == null) {
			resourceRect = new Rectangle(0, 0, srcData.width, srcData.height);
		}
		
		var cacheId:String = resourceId + "_" + resourceRect.left + "_" + resourceRect.top + "_" + resourceRect.width + "_" + resourceRect.height + "___" + src.left + "_" + src.top + "_" + src.width + "_" + src.height;
		var section:BitmapData = sectionCache.get(cacheId);
		if (section == null) {
			var fillcolor = 0x00FFFFFF;
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
		if (resourceId == null || resourceId.length == 0) {
			return null;
		}
		
		if (sectionCache == null) {
			sectionCache = new StringMap<BitmapData>();
		}
		
		if (rc == null) {
			var resource:BitmapData = ResourceManager.instance.getBitmapData(resourceId);
			if (resource != null) {
				rc = new Rectangle(0, 0, resource.width, resource.height);
			}
		}

		var cacheId:String = resourceId + "_" + rc.left + "_" + rc.top + "_" + rc.width + "_" + rc.height;
		var section:BitmapData = sectionCache.get(cacheId);
		
		if (section == null) {
			var resource:BitmapData = ResourceManager.instance.getBitmapData(resourceId);
			if (resource != null) {
				var fillcolor = 0x00FFFFFF;
				section = new BitmapData(Std.int(rc.width), Std.int(rc.height), true, fillcolor);
				section.copyPixels(resource, rc, new Point(0, 0));
				sectionCache.set(cacheId, section);
			}
		}
		
		return section;
	}
}