package locator;

import greeter.Cli;

/**
	Normalized absolute directory path based on `PathString`.
	The actual directory does not have to exist.
**/
@:notNull
@:forward(
	length,
	exists,
	getMode,
	toRelative,
	isAvailableInCli,
	quote,
	toPathObject,
	toString
)
abstract DirectoryPath(PathString) to String {
	/**
		Callback function for `DirectoryPath.from()`.
	**/
	public static final createCallback = (s: PathString) -> DirectoryPath.from(s);

	/**
		Callback function for `FilePath.from(s: String)`.
	**/
	public static final fromStringCallback = (s: String) -> DirectoryPath.from(s);

	/**
		Creates a new `DirectoryPath` value.
	**/
	@:from public static extern inline function from(pathString: PathString): DirectoryPath {
		return new DirectoryPath(pathString.addTrailingDelimiter());
	}

	/**
		Creates a new `DirectoryPath` value.
		@param s Any directory path, either absolute or relative from the current working directory.
	**/
	@:from public static extern inline function fromString(s: String): DirectoryPath
		return from(s);

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
		Tries to remove the leading `./` (if DOS `.\` as well).
	**/
	static inline function relativeCurrent(s: String, dos: Bool): Maybe<String> {
		return if (s.startsWith("./") || (dos && s.startsWith(".\\")))
			Maybe.from(s.substr(2)) else Maybe.none();
	}

	/**
		Tries to remove the leading `../` (if DOS `..\` as well).
	**/
	static inline function relativeParent(s: String, dos: Bool): Maybe<String> {
		return if (s.startsWith("../") || (dos && s.startsWith("..\\")))
			Maybe.from(s.substr(3)) else Maybe.none();
	}

	/**
		@return The name of the directory specified by `this` path.
	**/
	@:access(locator.DirectoryPath)
	public inline function getName(): String {
		final length = this.length;
		final delimiter = this.getMode().delimiter;
		final pos = this.lastIndexOf(delimiter, length - 2) + 1;
		return if (pos == 0) this else this.substring(pos, length - 1);
	}

	/**
		@return Path of the parent directory of `this`.
		`Maybe.none()` if `this` path indicates the root directory.
	**/
	@:access(locator.DirectoryPath)
	public inline function getParentPath(): Maybe<DirectoryPath> {
		final newLength = this.getLastIndexOf(
			this.getMode().delimiter,
			this.length - 2
		).int()
			+ 1;
		return if (newLength == 0) Maybe.none() else Maybe.from(new DirectoryPath(this.substr(
			0,
			newLength
		)));
	}

	/**
		Concats `this` and `relPath`, and creates a new `DirectoryPath` value.
		@param relPath Relative path of a directory from `this` directory path.
	**/
	public extern inline function concat(relPath: String): DirectoryPath
		return DirectoryPath.from(concatPath(relPath));

	/**
		Concats `this` and `relPath`, and creates a new `FilePath` value.
		@param relPath Relative path of a file from `this` directory path.
	**/
	public extern inline function makeFilePath(relPath: String): FilePath
		return FilePath.from(concatPath(relPath));

	/**
		Finds the actual directory.
	**/
	public extern inline function find(): DirectoryRef
		return DirectoryRef.from(this);

	/**
		Tries to find the actual directory.
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
		Finds the actual directory. Creates it if not found.
	**/
	public extern inline function findOrCreate(): DirectoryRef {
		final dir = tryFind();
		return if (dir.isSome()) dir.unwrap() else createDirectory();
	}

	/**
		@return `this` if it exists. Otherwise `defaultPath`.
	**/
	public extern inline function or(defaultPath: DirectoryPath): DirectoryPath
		return coalesce(new DirectoryPath(this), defaultPath);

	/**
		Checks if `cli` matches the mode in which `this` was created. If not, throws an error.
		@return `this`
	**/
	public inline function validate(cli: Cli): DirectoryPath {
		return new DirectoryPath(this.validate(cli));
	}

	/**
		Creates a new `PathString` by concatenating `this` and `relPathStr`.
		@param relPathStr Relative path of a file/directory from `this` directory path.
	**/
	function concatPath(relPathStr: String): PathString {
		final mode = this.getMode();
		#if !locator_validation_disable
		if (Path.isAbsolute(relPathStr))
			throw "Cannot concat absolute path: " + relPathStr;
		if (mode != PathString.mode)
			throw 'Cannot concat ${mode.cli.name} path and ${PathString.mode.cli.name} path.';
		#end

		final dos = mode.cliType == Dos;
		var relPath = relPathStr;
		var refDirPath = new DirectoryPath(this);
		var nextRelPath = relativeCurrent(relPath, dos);

		if (nextRelPath.isSome())
			return DirectoryPath.from(refDirPath + nextRelPath.unwrap());

		nextRelPath = relativeParent(relPath, dos);
		while (nextRelPath.isSome()) {
			relPath = nextRelPath.unwrap();
			final nextRef = refDirPath.getParentPath();
			if (nextRef.isNone())
				throw 'Cannot concatenate:\n  Reference dir: $this\n  Relative path: $relPathStr';
			refDirPath = nextRef.unwrap();
			nextRelPath = relativeParent(relPath, dos);
		}

		return PathString.from(refDirPath + relPath);
	}

	/**
		For internal use.
		Creates `DirectoryPath` without appending delimiter.
	**/
	extern inline function new(path: PathString)
		this = path;
}
