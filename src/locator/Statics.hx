package locator;

import haxe.SysTools;

/**
	Common static functions.
**/
class Statics {
	/**
		Quotes `s` if needed, depending on the current system (either Windows or other).
	**/
	public static final quote = switch Sys.systemName() {
			case "Windows": (s: String) -> SysTools.quoteWinArg(s, true);
			default: SysTools.quoteUnixArg;
		};

	/**
		Quotes `s` if needed, depending on the current system (either Windows or other).
		On windows, also replaces `/` by `\`.
	**/
	public static final quotePath = switch Sys.systemName() {
			case "Windows": (s: String) -> SysTools.quoteWinArg(s.replace("/", "\\"), true);
			default: SysTools.quoteUnixArg;
		};

	/**
		Absolutizes `path` and replaces backslash with slash.
	**/
	@:noUsing
	public static extern inline function normalize(path: String): String
		return normalizeSlash(FileSystem.absolutePath(path));

	/**
		Replaces backslash with slash.
	**/
	@:noUsing
	public static extern inline function normalizeSlash(path: String): String
		return path.replace("\\", "/");
}
