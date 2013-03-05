package haxe.ui.style.ios;

import haxe.ui.style.Styles;

class RatingsStyles {
	public function new(styles:Styles) {
		styles.addStyle("RatingControl", {
			paddingLeft: 0,
			paddingTop: 0,
			paddingBottom: 0,
			paddingRight: 0,
			spacingX: 2,
		});

		styles.addStyle("RatingControl.value", {
			width: 32,
			height: 32,
		});
		
		styles.addStyle("RatingControl.value.unselected", {
			backgroundImage: "skins/ios/ratings/nostar.png",
		});

		/*
		styles.addStyle("RatingControl.value.unselected:over", {
			backgroundImage: "skins/windows/ratings/star.png",
		});

		styles.addStyle("RatingControl.value.unselected:down", {
			backgroundImage: "skins/windows/ratings/star.png",
		})
		;
		*/
		
		styles.addStyle("RatingControl.value.selected", {
			backgroundImage: "skins/ios/ratings/star.png",
		});
	}
	
}