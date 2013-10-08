package haxe.ui.toolkit.style;

class DefaultStyles extends Styles {
	public function new() {
		super();
		
		addStyle("Text", { fontSize: 13, fontName: "_sans" } );
		addStyle("VBox, HBox, Grid, ListView", { spacingX: 5, spacingY: 5, backgroundColor: 0xFFFFFF } );
		addStyle("Button, AccordionButton, List, Date, CalendarDay", { backgroundColor: 0x888888, color: 0xFFFFFF, cornerRadius: 3, borderColor: 0x000000, paddingLeft: 10, paddingRight: 10, paddingTop: 2, paddingBottom: 2 } );
		addStyle("Button:over, AccordionButton:over, List:over, Date:over, CalendarDay:over", { backgroundColor: 0xAAAAAA} );
		addStyle("Button:down, AccordionButton:down, List:down, Date:down, CalendarDay:down", { backgroundColor: 0x888888 } );
		addStyle("VScroll", { width: 17, height: 100, hasButtons: false} );
		addStyle("HScroll", { width: 100, height: 17, hasButtons: false } );
		addStyle("ListView #even", { backgroundColor: 0xEEEEEE } );
		addStyle("TabBar, MenuBar", { height: 45 } );
		addStyle("TabBar Button", { height: 30, iconPosition: "left" } );
		addStyle("Popup", { width:300, backgroundColor: 0xCCCCCC, color: 0xFFFFFF, cornerRadius: 3, borderColor: 0x000000 } );
	}
}