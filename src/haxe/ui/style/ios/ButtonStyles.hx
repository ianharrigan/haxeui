package haxe.ui.style.ios;

import haxe.ui.style.Styles;

class ButtonStyles {
	public function new(styles:Styles) {
		styles.addStyle("Button", {
			paddingLeft: 12,
			paddingTop: 12,
			paddingBottom: 12,
			paddingRight: 12,
			backgroundImage: "skins/ios/button/button_up2.png",
			backgroundImageScale9: "5,5,139,43",
			color: 0xffffff,
			//iconPosition: "left",
			textPosition: "center",
		});
		
		styles.addStyle("Button:over", {
			backgroundImage: "skins/ios/button/button_up2.png",
			backgroundImageScale9: "5,5,139,43",
		});
		
		styles.addStyle("Button:down", {
			backgroundImage: "skins/ios/button/button_down2.png",
			backgroundImageScale9: "5,5,139,43",
		});
	}
	
}