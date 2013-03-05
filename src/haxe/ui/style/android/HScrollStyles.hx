package haxe.ui.style.android;
import haxe.ui.style.Styles;

class HScrollStyles {
	public function new(styles:Styles) {
		styles.addStyle("HScroll", {
			width: 100,
			height: 5,
			paddingLeft: 0,
			paddingTop: 0,
			paddingBottom: 0,
			paddingRight: 0,
			spacingX: 0,
			hasButtons: false,
		});
		
		styles.addStyle("HScroll.thumb", {
			backgroundImage: "skins/android/hscroll/hscroll_thumb_up.png",
			backgroundImageScale9: "2,1,14,2",
		});
		
		styles.addStyle("HScroll.thumb:over", {
			backgroundImage: "skins/android/hscroll/hscroll_thumb_up.png",
			backgroundImageScale9: "2,1,14,2",
		});

		styles.addStyle("HScroll.thumb:down", {
			backgroundImage: "skins/android/hscroll/hscroll_thumb_up.png",
			backgroundImageScale9: "2,1,14,2",
		});
	}
}