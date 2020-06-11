package locator;

import greeter.Cli;
import locator.implementation.PathStringModeInstances;

/**
	String that represents a path to any file or directory.
	Always absolute.
	Depending on `mode`, the path delimiter characters may be unified.
**/
@:forward
abstract PathString(String) to String {
	/**
		Current mode (either Unix or DOS) for interpreting an arbitrary string as a path.

		At default this is set according to the current system on which the program is running.

		When interpreting a `String` value:
		- If `unix`: `/` is interpreted as delimiter and `\` is treated as just a character with no special meaning.
		- If `dos`: Both `/` and `\` are interpreted as delimiter and then unified to `\`.
	**/
	public static var mode: PathStringMode = PathStringModeInstances.get(Cli.current.type);

	/**
		Converts `s` to `PathString`.
	**/
	@:from public static inline function from(s: String): PathString {
		s = s.trim();
		final lastCharCode = s.charCodeAt(s.length - 1);
		var hasLastDelimiter = lastCharCode == Char.slashCode; // First check slash here
		var absolutePath = FileSystem.absolutePath(s); // This may drop the trailing delimiter

		if (mode.cliType == Dos) {
			hasLastDelimiter = hasLastDelimiter || lastCharCode == Char.backslashCode;
			absolutePath = formatAbsoluteDos(absolutePath);
		}

		if (hasLastDelimiter && absolutePath.lastCharCode() != mode.delimiterCode)
			absolutePath += mode.delimiter;

		return new PathString(absolutePath);
	}

	/**
		Converts `s` to `PathString`, assuming `s` is an absolute path.
	**/
	public static inline function fromAbsolute(s: String): PathString {
		if (mode.cliType == Dos) s = formatAbsoluteDos(s);
		return new PathString(s);
	}

	/**
		Formats `s` assuming that it is an absolute path on DOS.
		@return `s` with delimiters unified to backslash and first character changed to upper case.
	**/
	static inline function formatAbsoluteDos(s: String): String {
		s = s.replace(Char.slash, Char.backslash);
		return s.charAt(0).toUpperCase() + s.substr(1);
	}

	/**
		@return `true` if `this` file or directory exists.
	**/
	public extern inline function exists(): Bool
		return FileSystem.exists(this);

	/**
		Tells in which mode `this` path was created.
		`Unix` if the first character is a slash, otherwise `Dos`.
	**/
	public inline function getMode(): PathStringMode
		return if (this.charCodeAt(0) == Char.slashCode) PathStringMode.unix else
			PathStringMode.dos;

	/**
		Tells if `cli` matches the mode in which `this` was created.

		If `false` returned, `this` path cannot be used in `cli` even if the path is quoted with `this.quoteForCli()`.
	**/
	public inline function isAvailableInCli(cli: Cli): Bool
		return getMode().cliType == cli.type;

	/**
		Returns a `String` that can be used as a single command line argument
		on the CLI that corresponds to the `PathStringMode` in which `this` was created.

		@param targetCli If provided, checks if `this` matches the target CLI and throws error if not.
		For avoiding error, manually check with `isAvailableInCli()` before quoting.
	**/
	public inline function quoteForCli(?targetCli: Cli): String {
		final mode = getMode();
		if (targetCli != null && mode.cliType != targetCli.type)
			throw 'Path ${this} cannot be used in ${targetCli.name}';
		return mode.cli.quoteArgument(this);
	}

	/**
		Creates a new `haxe.io.Path` instance.
	**/
	@:to public extern inline function toPathObject(): Path
		return new Path(this);

	/**
		@return `true` if `this` ends with a path delimiter.
	**/
	public extern inline function endsWithDelimiter(): Bool
		return this.lastCharCode() == getMode().delimiterCode;

	/**
		@return `this` if it has already a trailing delimiter.
		Otherwise a new `PathString` with trailing delimiter appended.
	**/
	public extern inline function addTrailingDelimiter(): PathString {
		final mode = getMode();
		return if (this.lastCharCode() == mode.delimiterCode) this else {
			new PathString(this + mode.delimiter);
		};
	}

	/**
		@return Sub-string after the last occurrence of `delimiter`.
	**/
	public extern inline function sliceAfterLastDelimiter(): String
		return this.substr(this.getLastIndexOf(getMode().delimiter).int() + 1);

	/**
		Casts `this` to `String`.
	**/
	public extern inline function toString()
		return this;

	/**
		For internal use.
		Creates a `PathString` value without normalizing.
	**/
	extern inline function new(s: String)
		this = s;
}

private class Char {
	public static inline final slash = "/";
	public static inline final slashCode = "/".code;
	public static inline final backslash = "\\";
	public static inline final backslashCode = "\\".code;
}
