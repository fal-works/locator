package locator;

/**
	Normalized absolute directory path based on `PathString`.
	The actual directory does not have to exist.
**/
@:notNull
@:forward(length, exists, getMode, toRelative, isAvailableInCli, quote, toPathObject, toString)
abstract DirectoryPath(PathString) to String {
	/**
		Callback function for `DirectoryPath.from()`.
	**/
	public static final createCallback = (s: PathString) -> DirectoryPath.from(s);

	/**
		Callback function for `FilePath.from(s: String)`.
	**/
	public static final fromStringCallback = (s: String) -> FilePath.from(s);

	/**
		Creates a new `DirectoryPath` value.
		@param pathString If not provided, returns the current working directory.
	**/
	@:from public static extern inline function from(pathString: PathString) {
		return new DirectoryPath(pathString.addTrailingDelimiter());
	}

	/**
		@return New `DirectoryPath` value from the current working directory.
	**/
	public static extern inline function current() {
		return new DirectoryPath(PathString.fromAbsolute(Sys.getCwd()));
	}

	/**
		@return `a` if it exists. Otherwise `b`.
	**/
	public static extern inline function coalesce(
		a: DirectoryPath,
		b: DirectoryPath
	): DirectoryPath
		return if (a.exists()) a else b;

	/**
		Concats `this` and `relPathString`, and creates a new `DirectoryPath` value.
		Throws error if an absolute path is passed.

		(java) Not available on Java.
		@param relPathString Relative path of a directory from `this` directory path.
	**/
	public extern inline function concat(relPathString: String): DirectoryPath {
		#if !locator_validation_disable
		if (Path.isAbsolute(relPathString))
			throw "Cannot concat absolute path: " + relPathString;
		#end
		final cwd = Sys.getCwd();
		Sys.setCwd(this);
		final newPath = DirectoryPath.from(relPathString);
		Sys.setCwd(cwd);
		return newPath;
	}

	@:access(locator.DirectoryPath)
	public inline function getName(): String {
		final length = this.length;
		final newStartPos = this.getLastIndexOf(this.getMode().delimiter, length - 2).int() + 1;
		return if (newStartPos == 0) this else this.substring(newStartPos, length - 1);
	}

	/**
		@return Path of the parent directory of `this`.
		`Maybe.none()` if `this` path indicates the root directory.
	**/
	@:access(locator.DirectoryPath)
	public inline function getParentPath(): Maybe<DirectoryPath> {
		final newLength = this.getLastIndexOf(this.getMode().delimiter, this.length - 2).int() + 1;
		return if (newLength == 0) Maybe.none() else Maybe.from(new DirectoryPath(this.substr(0, newLength)));
	}

	/**
		Concats `this` and `relPathString`, and creates a new `FilePath` value.
		Throws error if an absolute path is passed.

		(java) Not available on Java.
		@param relPathString Relative path of a file from `this` directory path.
	**/
	public extern inline function makeFilePath(relPathString: String): FilePath {
		#if !locator_validation_disable
		if (Path.isAbsolute(relPathString))
			throw "Cannot concat absolute path: " + relPathString;
		#end
		final cwd = Sys.getCwd();
		Sys.setCwd(this);
		final newPath = FilePath.from(relPathString);
		Sys.setCwd(cwd);
		return newPath;
	}

	/**
		Finds the actual directory.
	**/
	public extern inline function find(): DirectoryRef
		return DirectoryRef.from(this);

	/**
		Tries to find the actual file.
	**/
	@:access(locator.DirectoryRef)
	public extern inline function tryFind(): Maybe<DirectoryRef>
		return if (this.exists()) Maybe.from(new DirectoryRef(this)) else Maybe.none();

	/**
		Creates the actual directory.
	**/
	@:access(locator.DirectoryRef)
	public extern inline function createDirectory(): DirectoryRef {
		FileSystem.createDirectory(this);
		return new DirectoryRef(this);
	}

	/**
		@return `this` if it exists. Otherwise `defaultPath`.
	**/
	public extern inline function or(defaultPath: DirectoryPath): DirectoryPath
		return coalesce(new DirectoryPath(this), defaultPath);

	/**
		For internal use.
		Creates `DirectoryPath` without appending delimiter.
	**/
	extern inline function new(path: PathString)
		this = path;
}
