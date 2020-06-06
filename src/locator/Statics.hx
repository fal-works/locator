package locator;

import haxe.SysTools;

/**
	Common static functions.
**/
class Statics {
	/**
		Path delimiter used for internal representation of locator types.
	**/
	public static final pathDelimiter = "/";

	/**
		@return String that can be used as a single command line argument on the current OS.
	**/
	public static extern inline function quote(s: String): String {
		#if locator_windows
		return SysTools.quoteWinArg(s.replace("/", "\\"), true);
		#else
		return SysTools.quoteUnixArg(s);
		#end
	}

	/**
		Replaces `/` by `\`.
	**/
	public static extern inline function normalizePathDelimiter(s: String): String
		return s.replace("\\", "/");

	/**
		Normalizes slash/backslash and also absolutizes the path.
	**/
	public static extern inline function normalizePathString(path: String): String
		return normalizePathDelimiter(FileSystem.absolutePath(path));
}
