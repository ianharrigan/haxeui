package haxe.ui.style.ios;
import haxe.ui.style.Styles;

class CheckBoxStyles {
	public function new(styles:Styles) {
		styles.addStyle("CheckBox", {
		});

		styles.addStyle("CheckBox:over", {
		});
		
		styles.addStyle("CheckBox.value", {
			width: 30,
			height: 30,
		});

		styles.addStyle("CheckBox.value.unselected", {
			backgroundImage: "skins/ios/checkbox/checkbox_unchecked_up.png",
		});

		styles.addStyle("CheckBox.value.unselected:over", {
			backgroundImage: "skins/ios/checkbox/checkbox_unchecked_up.png",
		});

		styles.addStyle("CheckBox.value.unselected:down", {
			backgroundImage: "skins/ios/checkbox/checkbox_unchecked_up.png",
		});

		styles.addStyle("CheckBox.value.selected", {
			backgroundImage: "skins/ios/checkbox/checkbox_checked_up.png",
		});
		
		styles.addStyle("CheckBox.value.selected:over", {
			backgroundImage: "skins/ios/checkbox/checkbox_checked_up.png",
		});
		
		styles.addStyle("CheckBox.value.selected:down", {
			backgroundImage: "skins/ios/checkbox/checkbox_checked_up.png",
		});
	}
}