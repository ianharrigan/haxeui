package haxe.ui.toolkit.console;

import pgr.dconsole.DCThemes.Theme;

class HaxeUIConsoleTheme {
	static public var HAXEUI_THEME:Theme = {
		CON_C 		: 0x353535, 
		CON_TXT_C 	: 0xFFFFFF,
		CON_A		: .7,
		CON_TXT_A	: 1,
		
		PRM_C		: 0x111111,
		PRM_TXT_C	: 0xFFFFFF,
		
		MON_C		: 0x000000,
		MON_TXT_C	: 0xFFFFFF,
		MON_A		: .7,			
		MON_TXT_A	: .7,
		
		LOG_WAR	: 0xFFFF00, // Warning messages color;
		LOG_ERR	: 0xFF0000, // Error message color;
		LOG_INF	: 0x00FFFF, // Info messages color;
		LOG_CON	: 0x00FF00, // Confirmation messages color;
	}
}
