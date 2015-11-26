package haxe.ui.toolkit.util;

class Types {

	/**
	 * @param className name of the class to resolve
	 * @return the corresponding class instance
	 * @throws an exception in case the class could not be found
	 */
	public static function resolveClass(className): Class<Dynamic> {
		var clazz = Type.resolveClass(className);
		if (clazz == null) throw 'Cannot find class with name [$className]';
		return clazz;
	}
}
