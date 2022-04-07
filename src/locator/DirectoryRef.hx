package locator;

/**
	Value referring to an existing directory.
**/
@:notNull
@:forward(toString, getParentPath, getName, concat, makeFilePath)
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
		Throws error if the directory does not exist.
	**/
	@:from public static extern inline function fromPath(path: DirectoryPath) {
		#if !locator_validation_disable
		if (!FileSystem.exists(path)) throw "Directory not found: " + path;
		if (!FileSystem.isDirectory(path)) throw "Directory not accessible: " + path;
		#end
		return new DirectoryRef(path);
	}

	/**
		Creates a `DirectoryRef` value without checking if the directory exists and is accessible.
	**/
	public static extern inline function fromPathUnsafe(path: DirectoryPath)
		return new DirectoryRef(path);

	/**
		Creates a `DirectoryRef` value from a string.
		Throws error if the directory does not exist.
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
		@return The parent directory of `this`. `Maybe.none()` if `this` is the root directory.
	**/
	@:access(locator.DirectoryRef)
	public extern inline function getParent(): Maybe<DirectoryRef> {
		final path = this.getParentPath();
		return if (path.isSome()) {
			Maybe.from(new DirectoryRef(path.unwrap()));
		} else Maybe.none();
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
	public extern inline function tryFindDirectory(
		relativePath: String
	): Maybe<DirectoryRef>
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
		@return All files and directories in `this`.
	**/
	public inline function getContents(): FileOrDirectoryList {
		return FileSystem.readDirectory(this)
			.map(name -> FileOrDirectoryRef.fromPathUnsafe(this + name));
	}

	/**
		Copies `this` directory to `destinationPath` with all of its contents (recursively).
		Overwrites the destination files if it already exist.
		@param destinationPath The destination path.
		Note that this is NOT the directory which should contain the copied directory (unlike `copyTo()`),
		but the directory itself after copied.
		@return New `DirectoryRef` value for the destination directory.
	**/
	public inline function copy(destinationPath: DirectoryPath): DirectoryRef {
		if (!destinationPath.exists()) destinationPath.createDirectory();

		for (element in getContents()) switch element.toEnum() {
			case File(ref): ref.copyTo(destinationPath, false);
			case Directory(ref): ref.copy(destinationPath.concat(ref.getName()));
		}
		return new DirectoryRef(destinationPath);
	}

	/**
		Copies `this` directory to `destinationPath` with the same directory name and
		with all of its contents (recursively).
		Overwrites the destination files if it already exist.
		@param destinationPath The destination path.
		Unlike `copy()`, this is the directory which should contain the copied directory.
		@return New `DirectoryRef` value for the destination directory.
	**/
	public inline function copyTo(destinationPath: DirectoryPath): DirectoryRef {
		return copy(destinationPath.concat(this.getName()));
	}

	/**
		For internal use.
		Creates `DirectoryRef` without checking existence.
	**/
	extern inline function new(path: DirectoryPath)
		this = path;

	extern inline function get_path(): DirectoryPath
		return this;
}
