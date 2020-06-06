package locator;

/**
	Value referring to an existing directory.
**/
@:notNull
@:forward(getParentPath, concat, makeFilePath)
abstract DirectoryRef(DirectoryPath) {
	/**
		Callback function for `DirectoryRef.from(path: DirectoryPath)`.
	**/
	public static final createCallback = (
		path: DirectoryPath
	) -> DirectoryRef.fromPath(path);

	/**
		Callback function for `DirectoryRef.from(s: String)`.
	**/
	public static final fromStringCallback = (s: String) -> DirectoryRef.from(s);

	/**
		Creates a `DirectoryRef` value.

		(`#if locator_debug`) Throws error if the directory does not exist.
	**/
	@:from public static extern inline function fromPath(path: DirectoryPath) {
		#if locator_debug
		if (!FileSystem.exists(path)) throw "Directory not found: " + path;
		if (!FileSystem.isDirectory(path)) throw "Directory not accessible: " + path;
		#end
		return new DirectoryRef(path);
	}

	/**
		Creates a `DirectoryRef` value from a string.

		(`#if locator_debug`) Throws error if the directory does not exist.
	**/
	public static extern inline function from(s: String)
		return fromPath(DirectoryPath.from(s));

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
		@return The parent directory of `this`.
	**/
	@:access(locator.DirectoryRef)
	public extern inline function getParent(): DirectoryRef {
		return new DirectoryRef(this.getParentPath());
	}

	/**
		Tries to find a file specified by `relativePath`.
	**/
	public extern inline function tryFindFile(relativePath: String): Maybe<FileRef>
		return this.makeFilePath(relativePath).tryFind();

	/**
		Finds a file specified by `relativePath`.
		Throws error if not found.
	**/
	public extern inline function findFile(relativePath: String): FileRef {
		final path = this.makeFilePath(relativePath);
		final maybeFile = path.tryFind();
		if (maybeFile.isNone()) throw 'File not found: $path';
		return maybeFile.unwrap();
	}

	/**
		Tries to find a directory specified by `relativePath`.
	**/
	public extern inline function tryFindDirectory(relativePath: String): Maybe<DirectoryRef>
		return this.concat(relativePath).tryFind();

	/**
		Finds a directory specified by `relativePath`.
		Throws error if not found.
	**/
	public extern inline function findDirectory(relativePath: String): DirectoryRef {
		final path = this.concat(relativePath);
		final maybeDir = path.tryFind();
		if (maybeDir.isNone()) throw 'Directory not found: $path';
		return maybeDir.unwrap();
	}

	/**
		Sets `this` as current working directory.

		(java) Not available on Java.
	**/
	public extern inline function setAsCurrent(): Void
		Sys.setCwd(this);

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
