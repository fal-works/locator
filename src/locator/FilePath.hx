package locator;

/**
	Normalized absolute file path based on `String`.
	The actual file does not have to exist.
**/
@:notNull @:forward
abstract FilePath(PathString) to PathString {
	/**
		Callback function for `FilePath.from()`.
	**/
	public static final createCallback = (s: PathString) -> FilePath.from(s);

	/**
		Creates a new `FilePath` value.
		Throws error if `pathString` ends with any file path delimiter.
		@param pathString Either absolute or relative from the current working directory.
	**/
	@:access(locator.PathString)
	@:from public static extern inline function from(pathString: PathString) {
		#if !locator_validation_disable
		if (pathString.endsWithDelimiter()) throw "Not a file path: " + pathString;
		#end
		return new FilePath(pathString);
	}

	/**
		@return `a` if it exists. Otherwise `b`.
	**/
	public static extern inline function coalesce(a: FilePath, b: FilePath): FilePath
		return if (a.exists()) a else b;

	/**
		Finds the actual file.
	**/
	public extern inline function find(): FileRef
		return FileRef.fromPath(this);

	/**
		Tries to find the actual file.
	**/
	@:access(locator.FileRef)
	public extern inline function tryFind(): Maybe<FileRef>
		return if (this.exists()) Maybe.from(new FileRef(this)) else Maybe.none();

	/**
		@return `this` if it exists. Otherwise `defaultPath`.
	**/
	public extern inline function or(defaultPath: FilePath): FilePath
		return coalesce(new FilePath(this), defaultPath);

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
		@return The file name without directory and extension.
	**/
	public extern inline function getNameWithoutExtension(): String
		return getName().sliceBeforeLastDot();

	/**
		@param ext Extension without dot, e.g. `txt`.
		@return New `FilePath` value with the given extension.
	**/
	@:access(locator.PathString)
	public extern inline function setExtension(ext: String): FilePath {
		return new FilePath(new PathString('${this.sliceBeforeLastDot()}.$ext'));
	}

	/**
		Saves `content` at `this` file path.
		Be careful to use.
	**/
	public extern inline function saveContent(content: String): Void
		return File.saveContent(this, content);

	/**
		For internal use.
		Creates `FilePath` without checking the trailing delimiter.
	**/
	extern inline function new(path: PathString)
		this = path;
}
