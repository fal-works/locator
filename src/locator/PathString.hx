package locator;

import haxe.SysTools;

/**
	String that represents a path to any file or directory.
	Always absolute. On Windows, the path delimiter is unified to slash `/`.
**/
@:forward
abstract PathString(String) to String {
	/**
		Path delimiter used for internal representation of `PathString`.
	**/
	public static final delimiter = "/";

	/**
		Character code of `delimiter`.
	**/
	static extern inline final delimiterCode = "/".code;

	#if locator_windows
	static final backslash = "\\";
	static final backslashCode = "\\".code;
	#end

	/**
		Converts `s` to `PathString`.
	**/
	@:from public static extern inline function from(s: String): PathString {
		final lastCharCode = s.charCodeAt(s.length - 1);
		final hasLastDelimiter = lastCharCode == delimiterCode #if locator_windows || lastCharCode == backslashCode #end;

		var absolutePath = FileSystem.absolutePath(s.trim()); // This may drop the trailing delimiter
		#if locator_windows
		absolutePath = absolutePath.replace(backslash, delimiter);
		#end
		if (hasLastDelimiter && !stringEndsWithDelimiter(absolutePath))
			absolutePath += delimiter;

		return new PathString(absolutePath);
	}

	/**
		Converts `s` to `PathString`, assuming `s` is an absolute path.
	**/
	static extern inline function fromAbsolute(s: String): PathString {
		#if locator_windows
		s = s.replace(backslash, delimiter);
		#end
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
	public extern inline function getParentPath(): DirectoryPath {
		return new DirectoryPath(this.substr(
			0,
			this.getLastIndexOfSlash().unwrap() + 1
		));
	}

	/**
		@return String that can be used as a single command line argument on the current OS.
	**/
	public extern inline function quote(): String {
		#if locator_windows
		return SysTools.quoteWinArg(this.replace(delimiter, backslash), true);
		#else
		return SysTools.quoteUnixArg(this);
		#end
	}

	/**
		Creates a new `haxe.io.Path` instance.
	**/
	@:to public extern inline function toPathObject(): Path
		return new Path(this);

	/**
		Adds `s` to `this` without checking delimiters.
	**/
	extern inline function add(s: String): PathString {
		return new PathString(this + s);
	}

	/**
		@return `true` if `this` ends with a path delimiter.
	**/
	extern inline function endsWithDelimiter(): Bool
		return stringEndsWithDelimiter(this);

	/**
		For internal use.
		Creates a `PathString` value without normalizing.
	**/
	extern inline function new(s: String)
		this = s;
}
