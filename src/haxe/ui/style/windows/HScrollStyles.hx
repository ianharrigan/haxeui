package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class HScrollStyles {
	public function new(styles:Styles) {
		styles.addStyle("HScroll", {
			backgroundImage: "skins/windows/hscroll/hscroll_bg.png",
			backgroundImageScale9: "5,5,10,10",
			width: 100,
			height: 17,
			paddingLeft: 1,
			paddingTop: 1,
			paddingBottom: 1,
			paddingRight: 1,
			spacingX: 1,
			hasButtons: true,
		});
		
		styles.addStyle("HScroll.thumb", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_up.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/hscroll/hscroll_thumb_gripper_up.png",
		});
		
		styles.addStyle("HScroll.thumb:over", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_over.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/hscroll/hscroll_thumb_gripper_over.png",
		});

		styles.addStyle("HScroll.thumb:down", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_down.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/hscroll/hscroll_thumb_gripper_down.png",
		});
		
		styles.addStyle("HScroll.leftButton", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_up.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/hscroll/hscroll_left_arrow.png",
		});
		
		styles.addStyle("HScroll.leftButton:over", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_over.png",
			backgroundImageScale9: "5,5,10,10",
		});

		styles.addStyle("HScroll.leftButton:down", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_down.png",
			backgroundImageScale9: "5,5,10,10",
		});

		styles.addStyle("HScroll.rightButton", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_up.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/hscroll/hscroll_right_arrow.png",
		});
		
		styles.addStyle("HScroll.rightButton:over", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_over.png",
			backgroundImageScale9: "5,5,10,10",
		});

		styles.addStyle("HScroll.rightButton:down", {
			backgroundImage: "skins/windows/hscroll/hscroll_button_down.png",
			backgroundImageScale9: "5,5,10,10",
		});
	}
}