package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class CheckBoxStyles {
	public function new(styles:Styles) {
		styles.addStyle("CheckBox", {
			xxxxbackgroundColor: 0xFF00FF,
			color: 0x000000,
			paddingLeft: 3,
			paddingRight: 3,
			paddingBottom: 3,
			paddingTop: 3,
		});

		styles.addStyle("CheckBox:over", {
			xxxbackgroundColor: 0x880088,
			xxxcolor: 0xFFFFFF,
		});
		
		styles.addStyle("CheckBox.value", {
			xxxxbackgroundColor: 0xFFFFFF,
			paddingLeft: 3,
			paddingRight: 3,
			paddingBottom: 3,
			paddingTop: 3,
			width: 13,
			height: 13,
		});

		styles.addStyle("CheckBox.value.unselected", {
			backgroundImage: "skins/windows/checkbox/checkbox_unchecked_up.png",
		});

		styles.addStyle("CheckBox.value.unselected:over", {
			backgroundImage: "skins/windows/checkbox/checkbox_unchecked_over.png",
		});

		styles.addStyle("CheckBox.value.unselected:down", {
			backgroundImage: "skins/windows/checkbox/checkbox_unchecked_over.png",
		});

		styles.addStyle("CheckBox.value.selected", {
			backgroundImage: "skins/windows/checkbox/checkbox_checked_up.png",
		});
		
		styles.addStyle("CheckBox.value.selected:over", {
			backgroundImage: "skins/windows/checkbox/checkbox_checked_over.png",
		});
		
		styles.addStyle("CheckBox.value.selected:down", {
			backgroundImage: "skins/windows/checkbox/checkbox_checked_over.png",
		});
	}
	
}