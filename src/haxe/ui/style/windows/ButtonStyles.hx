package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class ButtonStyles {
	public function new(styles:Styles) {
		
		styles.addStyle("Button", {
			paddingLeft: 5,
			paddingTop: 2,
			paddingBottom: 2,
			paddingRight: 5,
			backgroundImage: "skins/windows/button/button_up.png",
			backgroundImageScale9: "5,5,15,15",
			iconPosition: "left",
			textPosition: "center",
		});
		
		styles.addStyle("Button:over", {
			backgroundImage: "skins/windows/button/button_over.png",
			backgroundImageScale9: "5,5,15,15",
		});
		
		styles.addStyle("Button:down", {
			backgroundImage: "skins/windows/button/button_down.png",
			backgroundImageScale9: "5,5,15,15",
		});
	}
}