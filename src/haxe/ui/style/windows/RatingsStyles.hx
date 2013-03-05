package haxe.ui.style.windows;
import haxe.ui.style.Styles;

class RatingsStyles {

	public function new(styles:Styles) {
		styles.addStyle("RatingControl", {
			paddingLeft: 5,
			paddingTop: 5,
			paddingBottom: 5,
			paddingRight: 5,
			backgroundImage: "skins/windows/textinput/textinput_normal.png",
			backgroundImageScale9: "5,5,10,10",
			spacingX: 5,
		});

		styles.addStyle("RatingControl.value", {
			width: 16,
			height: 16,
		});
		
		styles.addStyle("RatingControl.value.unselected", {
			backgroundImage: "skins/windows/ratings/star-empty.png",
		});

		styles.addStyle("RatingControl.value.unselected:over", {
			backgroundImage: "skins/windows/ratings/star.png",
		});

		styles.addStyle("RatingControl.value.unselected:down", {
			backgroundImage: "skins/windows/ratings/star.png",
		});
		
		styles.addStyle("RatingControl.value.selected", {
			backgroundImage: "skins/windows/ratings/star.png",
		});
	}
	
}