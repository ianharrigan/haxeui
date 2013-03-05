package haxe.ui.style.android;
import haxe.ui.style.Styles;

class ProgressBarStyles {
	public function new(styles:Styles) {
		styles.addStyle("ProgressBar", {
			width: 100,
			height: 27,
			paddingLeft: 1,
			paddingTop: 1,
			paddingBottom: 1,
			paddingRight: 1,
			backgroundImage: "skins/android/progress/progress_background.png",
			backgroundImageScale9: "3,3,97,24",
		});

		styles.addStyle("ProgressBar.value", {
			backgroundImage: "skins/android/progress/progress_value.png",
			backgroundImageScale9: "2,2,3,23",
		});
	}
}