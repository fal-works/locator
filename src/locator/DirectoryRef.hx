package locator;

/**
	Value referring to an existing directory.
**/
@:notNull
abstract DirectoryRef(DirectoryPath) {
	/**
		Callback function for `DirectoryRef.from(path: DirectoryPath)`.
	**/
	public static final createCallback = (path: DirectoryPath) -> DirectoryRef.from(path);

	/**
		Callback function for `DirectoryRef.from(s: String)`.
	**/
	public static final fromStringCallback = (s: String) -> DirectoryRef.from(s);

	/**
		Creates a `DirectoryRef` value.

		(`#if locator_debug`) Throws error if the directory does not exist.
	**/
	@:from public static extern inline function from(path: DirectoryPath) {
		#if locator_debug
		if (!FileSystem.exists(path)) throw "Directory not found: " + path;
		if (!FileSystem.isDirectory(path)) throw "Directory not accessible: " + path;
		#end
		return new DirectoryRef(path);
	}

	/**
		@return New `DirectoryRef` value for the current working directory.
	**/
	public static extern inline function current(): DirectoryRef {
		return new DirectoryRef(DirectoryPath.current());
	}

	/**
		The path of `this` directory.
	**/
	public var path(get, never): DirectoryPath;

	/**
		@return The path of `this` directory as `String`.
	**/
	public extern inline function toString(): String
		return this;

	/**
		For internal use.
		Creates `DirectoryRef` without checking existence.
	**/
	extern inline function new(path: DirectoryPath)
		this = path;

	extern inline function get_path(): DirectoryPath
		return this;
}
