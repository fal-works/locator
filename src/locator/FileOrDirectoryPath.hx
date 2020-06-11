package locator;

/**
	A path that specifies either a file or a directory.
**/
abstract FileOrDirectoryPath(Data) from Data {
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
}

private enum Data {
	File(path: FilePath);
	Directory(path: DirectoryPath);
}
