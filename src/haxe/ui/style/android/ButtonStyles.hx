package haxe.ui.style.android;

import haxe.ui.style.Styles;

class ButtonStyles {
	public function new(styles:Styles) {
		styles.addStyle("Button", {
			paddingLeft: 12,
			paddingTop: 12,
			paddingBottom: 12,
			paddingRight: 12,
			backgroundImage: "skins/android/button/button_up.png",
			backgroundImageScale9: "5,5,146,38",
			color: 0x000000,
			iconPosition: "left",
			textPosition: "center",
		});
		
		styles.addStyle("Button:over", {
			backgroundImage: "skins/android/button/button_up.png",
			backgroundImageScale9: "5,5,146,38",
		});
		
		styles.addStyle("Button:down", {
			backgroundImage: "skins/android/button/button_down.png",
			backgroundImageScale9: "5,5,146,38",
		});
	}
	
}