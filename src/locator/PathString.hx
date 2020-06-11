package locator;

import haxe.SysTools;
import greeter.CommandLineInterface as CLI;
import greeter.CommandLineInterfaceSet as CLIs;

/**
	String that represents a path to any file or directory.
	Always absolute.
	Depending on `mode`, the path delimiter characters may be unified.
**/
@:forward
abstract PathString(String) to String {
	/**
		Current mode (either `Unix` or `Dos`) for interpreting an arbitrary string as a path.

		At default this is set according to the current system on which the program is running.

		When interpreting a `String` value:
		- If `Unix`: `/` is interpreted as delimiter and `\` is treated as just a character with no special meaning.
		- If `Dos`: Both `/` and `\` are interpreted as delimiter and then unified to `\`.
	**/
	public static var mode(default, set): PathStringMode = CLI.current.type;

	/**
		Path delimiter used for internal representation of `PathString`.
		Automatically set according to `mode`.
	**/
	static var delimiter: String = switch mode {
			case Unix: Char.slash;
			case Dos: Char.backslash;
		};

	/**
		Character code of `delimiter`.
		Automatically set according to `mode`.
	**/
	static var delimiterCode: Int = switch mode {
			case Unix: Char.slashCode;
			case Dos: Char.backslashCode;
		};

	/**
		The CLI that corresponts to the current `mode`.
		Automatically set according to `mode`.
	**/
	static var cli: CLI = CLI.current;

	/**
		Converts `s` to `PathString`.
	**/
	@:from public static inline function from(s: String): PathString {
		s = s.trim();
		final lastCharCode = s.charCodeAt(s.length - 1);
		var hasLastDelimiter = lastCharCode == Char.slashCode; // First check slash here
		var absolutePath = FileSystem.absolutePath(s); // This may drop the trailing delimiter

		if (mode == Dos) {
			hasLastDelimiter = hasLastDelimiter || lastCharCode == Char.backslashCode;
			absolutePath = absolutePath.replace(Char.slash, Char.backslash);
		}

		if (hasLastDelimiter && !stringEndsWithDelimiter(absolutePath))
			absolutePath += delimiter;

		return new PathString(absolutePath);
	}

	/**
		Sets `PathString.mode` and other depending variables.
	**/
	static inline function set_mode(mode: PathStringMode): PathStringMode {
		switch mode {
			case Unix:
				cli = CLIs.unix;
				delimiter = Char.slash;
				delimiterCode = "/".code;
			case Dos:
				cli = CLIs.dos;
				delimiter = Char.backslash;
				delimiterCode = "\\".code;
		}
		return PathString.mode = mode;
	}

	/**
		Converts `s` to `PathString`, assuming `s` is an absolute path.
	**/
	static inline function fromAbsolute(s: String): PathString {
		if (mode == Dos) s = s.replace(Char.slash, Char.backslash);
		return new PathString(s);
	}

	/**
		@return `true` if `s` ends with a path delimiter.
	**/
	static extern inline function stringEndsWithDelimiter(s: String): Bool
		return s.charCodeAt(s.length - 1) == delimiterCode;

	/**
		@return `true` if `this` file or directory exists.
	**/
	public extern inline function exists(): Bool
		return FileSystem.exists(this);

	/**
		@return Path of the parent directory of `this`.
	**/
	@:access(locator.DirectoryPath)
	public inline function getParentPath(): DirectoryPath {
		return new DirectoryPath(this.substr(
			0,
			this.getLastIndexOf(delimiter).unwrap() + 1
		));
	}

	/**
		@return String that can be used as a single command line argument on the current OS.
	**/
	public inline function quote(): String {
		return switch mode {
			case Unix: SysTools.quoteUnixArg(this);
			case Dos: SysTools.quoteWinArg(
					this.replace(Char.slash, Char.backslash),
					true
				);
		}
	}

	/**
		Creates a new `haxe.io.Path` instance.
	**/
	@:to public extern inline function toPathObject(): Path
		return new Path(this);

	/**
		@return `true` if `this` ends with a path delimiter.
	**/
	extern inline function endsWithDelimiter(): Bool
		return stringEndsWithDelimiter(this);

	/**
		@return `this` if it has already a trailing delimiter.
		Otherwise a new `PathString` with trailing delimiter appended.
	**/
	extern inline function addTrailingDelimiter(): PathString {
		return if (endsWithDelimiter()) this else new PathString(this + PathString.delimiter);
	}

	/**
		@return Sub-string after the last occurrence of `delimiter`.
	**/
	extern inline function sliceAfterLastDelimiter(): String
		return this.substr(this.getLastIndexOf(delimiter).int() + 1);

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
