package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class VScrollStyles {
	public function new(styles:Styles) {
		styles.addStyle("VScroll", {
			backgroundImage: "skins/windows/vscroll/vscroll_bg.png",
			backgroundImageScale9: "5,5,10,10",
			width: 17,
			height: 100,
			paddingLeft: 1,
			paddingTop: 1,
			paddingBottom: 1,
			paddingRight: 1,
			spacingY: 1,
			hasButtons: true,
		});
		
		styles.addStyle("VScroll.thumb", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_up.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/vscroll/vscroll_thumb_gripper_up.png",
		});
		
		styles.addStyle("VScroll.thumb:over", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_over.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/vscroll/vscroll_thumb_gripper_over.png",
		});

		styles.addStyle("VScroll.thumb:down", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_down.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/vscroll/vscroll_thumb_gripper_down.png",
		});

		styles.addStyle("VScroll.upButton", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_up.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/vscroll/vscroll_up_arrow.png",
		});
		
		styles.addStyle("VScroll.upButton:over", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_over.png",
			backgroundImageScale9: "5,5,10,10",
		});

		styles.addStyle("VScroll.upButton:down", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_down.png",
			backgroundImageScale9: "5,5,10,10",
		});

		styles.addStyle("VScroll.downButton", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_up.png",
			backgroundImageScale9: "5,5,10,10",
			icon: "skins/windows/vscroll/vscroll_down_arrow.png",
		});
		
		styles.addStyle("VScroll.downButton:over", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_over.png",
			backgroundImageScale9: "5,5,10,10",
		});

		styles.addStyle("VScroll.downButton:down", {
			backgroundImage: "skins/windows/vscroll/vscroll_button_down.png",
			backgroundImageScale9: "5,5,10,10",
		});
	}
}