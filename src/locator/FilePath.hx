package locator;

/**
	Normalized absolute file path based on `String`.
	The actual file does not have to exist.
**/
@:notNull
abstract FilePath(String) to String {
	/**
		Callback function for `FilePath.from()`.
	**/
	public static final createCallback = (s: String) -> FilePath.from(s);

	#if locator_debug
	/**
		Regular expression for any string ending with `/` or `\`.
	**/
	static final endsWithSlashLike = ~/[\.\/\\]$/i;
	#end

	/**
		Creates a new `FilePath` value.
		Throws error if `pathString` ends with any file path delimiter.
		@param pathString Either absolute or relative from the current working directory.
	**/
	@:from public static extern inline function from(pathString: String) {
		pathString = pathString.trim();
		#if locator_debug
		if (endsWithSlashLike.match(pathString)) throw "Not a file: " + pathString;
		#end
		return new FilePath(normalize(pathString));
	}

	/**
		@return `a` if it exists. Otherwise `b`.
	**/
	public static extern inline function coalesce(a: FilePath, b: FilePath): FilePath
		return if (a.exists()) a else b;

	/**
		Creates a new `haxe.io.Path` instance.
	**/
	@:to public extern inline function toPathObject(): Path
		return new Path(this);

	/**
		Finds the actual file.
	**/
	public extern inline function find(): FileRef
		return FileRef.from(this);

	/**
		@return `true` if `this` directory exists.
	**/
	public extern inline function exists(): Bool
		return FileSystem.exists(this);

	/**
		@return `this` if it exists. Otherwise `defaultPath`.
	**/
	public extern inline function or(defaultPath: FilePath): FilePath
		return coalesce(new FilePath(this), defaultPath);

	/**
		@return The directory path where `this` file is located.
	**/
	@:access(locator.DirectoryPath)
	public extern inline function getDirectoryPath(): DirectoryPath {
		return new DirectoryPath(this.substr(
			0,
			this.getLastIndexOfSlash().unwrap() + 1
		));
	}

	/**
		@return The file name without directory.
	**/
	public extern inline function getName(): String
		return this.sliceAfterLastSlash();

	/**
		@return The extension of `this` file path (if exists).
	**/
	public extern inline function getExtension(): Maybe<String> {
		final lastDot = this.getLastIndexOfDot();
		return if (lastDot.isNone()) Maybe.none() else {
			Maybe.from(this.substr(lastDot.unwrap() + 1));
		};
	}

	/**
		@return Quoted path.
	**/
	public extern inline function quote(): String
		return this.quotePath();

	/**
		For internal use.
		Creates `FilePath` without normalizing.
	**/
	extern inline function new(path: String)
		this = path;
}
