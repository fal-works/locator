package locator;

/**
	Normalized absolute directory path based on `String`.
	The actual directory does not have to exist.
**/
@:notNull
abstract DirectoryPath(String) to String {
	/**
		Callback function for `DirectoryPath.from()`.
	**/
	public static final createCallback = (s: String) -> DirectoryPath.from(s);

	/**
		Creates a new `DirectoryPath` value.
		@param pathString Either absolute or relative from the current working directory.
		If not provided, returns the current working directory.
	**/
	@:from public static extern inline function from(pathString: String) {
		pathString = normalizePathString(pathString);
		if (!pathString.endsWith(pathDelimiter)) pathString += pathDelimiter;
		return new DirectoryPath(pathString);
	}

	/**
		@return New `DirectoryPath` value from the current working directory.
	**/
	public static extern inline function current() {
		return new DirectoryPath(normalizePathDelimiter(Sys.getCwd()));
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
		Concats `this` and `relPathString`, and creates a new `DirectoryPath` value.

		(`#if locator_debug`) Throws error if an absolute path is passed.

		(java) Not available on Java.
		@param relPathString Relative path of a directory from `this` directory path.
	**/
	public extern inline function concat(relPathString: String): DirectoryPath {
		#if locator_debug
		if (Path.isAbsolute(relPathString))
			throw "Cannot concat absolute path: " + relPathString;
		#end
		final cwd = Sys.getCwd();
		Sys.setCwd(this);
		final newPath = DirectoryPath.from(relPathString);
		Sys.setCwd(cwd);
		return newPath;
	}

	/**
		Concats `this` and `relPathString`, and creates a new `FilePath` value.

		(`#if locator_debug`) Throws error if an absolute path is passed.

		(java) Not available on Java.
		@param relPathString Relative path of a file from `this` directory path.
	**/
	public extern inline function makeFilePath(relPathString: String): FilePath {
		#if locator_debug
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
		@return `true` if `this` directory exists.
	**/
	public extern inline function exists(): Bool
		return FileSystem.exists(this);

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
		@return Quoted path.
	**/
	public extern inline function quote(): String
		return Statics.quote(this);

	/**
		For internal use.
		Creates `DirectoryPath` without normalizing.
	**/
	extern inline function new(path: String)
		this = path;
}
