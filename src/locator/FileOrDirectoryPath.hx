package locator;

import greeter.Cli;

/**
	A path that specifies either a file or a directory.
**/
@:notNull
abstract FileOrDirectoryPath(Data) from Data to Data {
	/**
		Callback function for `FileOrDirectoryPath.fromFilePath()`.
	**/
	public static final fromFilePathCallback = (path: FilePath) -> fromFilePath(path);

	/**
		Callback function for `FileOrDirectoryPath.fromDirectoryPath()`.
	**/
	public static final fromDirectoryPathCallback = (
		path: DirectoryPath
	) -> fromDirectoryPath(path);

	/**
		Callback function for `FileOrDirectoryPath.toDirectoryPath()`.
	**/
	public static final toDirectoryPathCallback = (
		path: FileOrDirectoryPath
	) -> path.toDirectoryPath();

	/**
		Converts `path` to `FileOrDirectoryPath`.
	**/
	@:from public static extern inline function fromFilePath(
		path: FilePath
	): FileOrDirectoryPath
		return File(path);

	/**
		Converts `path` to `FileOrDirectoryPath`.
	**/
	@:from public static extern inline function fromDirectoryPath(
		path: DirectoryPath
	): FileOrDirectoryPath
		return Directory(path);

	/**
		@return `String` representation of `this`.
	**/
	@:to public inline function toString(): String {
		return switch this {
			case File(path): path.toString();
			case Directory(path): path.toString();
		}
	}

	/**
		@return The name of the file/directory specified by `this` path.
	**/
	public extern inline function getName(): String {
		return switch this {
			case File(path): path.getName();
			case Directory(path): path.getName();
		}
	}

	/**
		Unifies `this` to a file path.
		@param defaultRelativePath Used if `this` is `Directory`.
	**/
	public extern inline function toFilePath(defaultRelativePath: String): FilePath {
		return switch this {
			case File(path): path;
			case Directory(path): path.makeFilePath(defaultRelativePath);
		}
	}

	/**
		Unifies `this` to a directory path.
		If `this` is `File`, the returning path is that of the parent directory.
	**/
	@:to public extern inline function toDirectoryPath(): DirectoryPath {
		return switch this {
			case File(path): path.getParentPath();
			case Directory(path): path;
		}
	}

	/**
		@return Enum representation of `this`.
	**/
	public extern inline function toEnum(): Data
		return this;

	/**
		Creates a relative path string of this from reference.
		@see `FilePath.toRelative()`
		@see `DirectoryPath.toRelative()`
		@param reference If not provided, the current working directory is used.
	**/
	public inline function toRelative(?reference: DirectoryPath, maxDepth = 2): String {
		return switch this {
			case File(path): path.toRelative(reference, maxDepth);
			case Directory(path): path.toRelative(reference, maxDepth);
		}
	}

	/**
		Returns a `String` that can be used as a single command line argument.

		@param targetCli If provided, checks if `this` matches the target CLI and throws error if not.
	**/
	public inline function quote(?targetCli: Cli): String {
		return switch this {
			case File(path): path.quote(targetCli);
			case Directory(path): path.quote(targetCli);
		}
	}
}

private enum Data {
	File(path: FilePath);
	Directory(path: DirectoryPath);
}
