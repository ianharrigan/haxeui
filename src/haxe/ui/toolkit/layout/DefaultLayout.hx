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
		for (child in container.children) {
			if (child.percentWidth > -1) {
				child.width = (ucx * child.percentWidth) / 100; 
			}
			
			if (child.percentHeight > -1) {
				child.height = (ucy * child.percentHeight) / 100; 
			}
		}
	}
	
	private override function repositionChildren():Void {
		super.repositionChildren();
		var xpos:Float = padding.left;
		var ypos:Float = padding.top;
		for (child in container.children) {
			child.x = xpos;
			child.y = ypos;
		}
	}
}