package haxe.ui.toolkit.core.interfaces;

class InvalidationFlag {
	public static inline var LAYOUT:Int = 0x00000001;
	public static inline var DISPLAY:Int = 0x0000010;
	public static inline var SIZE:Int = 0x0000100;
	public static inline var STATE:Int = 0x0001000;
	public static inline var DATA:Int = 0x0010000;
	
	public static inline var ALL:Int = LAYOUT | DISPLAY | SIZE | STATE | DATA;
}
