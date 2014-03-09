package haxe.ui.toolkit.layout;

class DefaultLayout extends Layout {
	public function new() {
		super();
	}
	
	//******************************************************************************************
	// ILayout
	//******************************************************************************************
	private override function resizeChildren():Void {
		super.resizeChildren();
		var ucx:Float = usableWidth;
		var ucy:Float = usableHeight;
		var totalWidth:Float = 0;
		var totalHeight:Float = 0;
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			if (child.percentWidth > -1) {
				child.width = (ucx * child.percentWidth) / 100; 
			}
			
			if (child.percentHeight > -1) {
				child.height = (ucy * child.percentHeight) / 100; 
			}
			
			if (child.width > totalWidth) {
				totalWidth = child.width;
			}
			if (child.height > totalHeight) {
				totalHeight = child.height;
			}
		}
		
		if (container.autoSize) {
			if (totalWidth > 0  && totalWidth != innerWidth && container.percentWidth == -1) {
				container.width = totalWidth + (padding.left + padding.right);
			}
			if (totalHeight > 0 && totalHeight != innerHeight && container.percentHeight == -1) {
				container.height = totalHeight + (padding.top + padding.bottom);
			}
		}
	}
	
	private override function repositionChildren():Void {
		super.repositionChildren();
		var xpos:Float = padding.left;
		var ypos:Float = padding.top;
		for (child in container.children) {
			
			if (child.visible == false) {
				continue; // ignore invisible.
			}
			
			child.x = xpos;
			child.y = ypos;
		}
	}
}