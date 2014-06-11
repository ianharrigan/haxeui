package haxe.ui.toolkit.util;

import openfl.utils.ByteArray;
import haxe.io.Bytes;

class ByteConverter {
	public static function fromHaxeBytes(bytes:Bytes):ByteArray {
		var ba:ByteArray = new ByteArray();
		for (a in 0...bytes.length) {
			ba.writeByte(Bytes.fastGet(bytes.getData(), a));
		}
		return ba;
	}
}