package haxe.ui.style.android;
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
			backgroundImage: "skins/android/checkbox/checkbox_unchecked_up.png",
		});

		styles.addStyle("CheckBox.value.unselected:over", {
			backgroundImage: "skins/android/checkbox/checkbox_unchecked_up.png",
		});

		styles.addStyle("CheckBox.value.unselected:down", {
			backgroundImage: "skins/android/checkbox/checkbox_unchecked_up.png",
		});

		styles.addStyle("CheckBox.value.selected", {
			backgroundImage: "skins/android/checkbox/checkbox_checked_up.png",
		});
		
		styles.addStyle("CheckBox.value.selected:over", {
			backgroundImage: "skins/android/checkbox/checkbox_checked_up.png",
		});
		
		styles.addStyle("CheckBox.value.selected:down", {
			backgroundImage: "skins/android/checkbox/checkbox_checked_up.png",
		});
	}
}