package haxe.ui.style.android;
import haxe.ui.style.Styles;

class VScrollStyles {
	public function new(styles:Styles) {
		styles.addStyle("VScroll", {
			width: 5,
			height: 100,
			paddingLeft: 0,
			paddingTop: 0,
			paddingBottom: 0,
			paddingRight: 0,
			spacingY: 0,
			hasButtons: false,
		});
		
		styles.addStyle("VScroll.thumb", {
					backgroundImage: "skins/android/vscroll/vscroll_thumb_up.png",
					backgroundImageScale9: "1,2,2,14",
		});
		
		styles.addStyle("VScroll.thumb:over", {
					backgroundImage: "skins/android/vscroll/vscroll_thumb_up.png",
					backgroundImageScale9: "1,2,2,14",
		});

		styles.addStyle("VScroll.thumb:down", {
					backgroundImage: "skins/android/vscroll/vscroll_thumb_up.png",
					backgroundImageScale9: "1,2,2,14",
		});
	}
}