package locator;

private typedef Data = Array<FileOrDirectoryRef>;

/**
	Array of `FileOrDirectoryRef`.
**/
@:notNull @:forward
abstract FileOrDirectoryList(Data) from Data to Data {
	/**
		Casts `Array<FileOrDirectoryRef>` to `FileOrDirectoryList` explicitly.
	**/
	public static extern inline function from(array: Data): FileOrDirectoryList
		return array;

	@:from static extern inline function fromStdArray(
		array: std.Array<FileOrDirectoryRef>
	): FileOrDirectoryList
		return from(array);

	/**
		Casts `this` to `Array<FileOrDirectoryRef>` explicitly.
	**/
	public extern inline function array(): Data
		return this;

	/**
		@return New list of file/directory names.
	**/
	public inline function getNames(): Array<String>
		return this.map(ref -> ref.getName());

	/**
		@return Files contained in `this` list.
	**/
	public inline function filerFiles(): FileList {
		var array: Array<FileRef> = [];
		for (i in 0...this.length) {
			switch this[i].toEnum() {
				case File(ref): array.push(ref);
				default:
			}
		}
		return array;
	}

	/**
		@return Directories contained in `this` list.
	**/
	public inline function filerDirectories() {
		var array: Array<DirectoryRef> = [];
		for (i in 0...this.length) {
			switch this[i].toEnum() {
				case Directory(ref): array.push(ref);
				default:
			}
		}
		return array;
	}

	/**
		@return Files and directories partitioned from `this` list.
	**/
	public inline function filesAndDirectories(): FilesAndDirectories {
		var files: Array<FileRef> = [];
		var directories: Array<DirectoryRef> = [];
		for (i in 0...this.length) {
			switch this[i].toEnum() {
				case File(ref): files.push(ref);
				case Directory(ref): directories.push(ref);
			}
		}
		return {
			files: files,
			directories: directories
		};
	}

	/**
		Copies all contents in `this` list to `destination` with the same names (recursively).
		Overwrites destination files if they already exist.
		@return New list of files/directories after copied.
	**/
	public inline function copyTo(destinationPath: DirectoryPath): FileOrDirectoryList {
		final newRefs: FileOrDirectoryList = [];
		for (i in 0...this.length)
			newRefs.push(this[i].copyTo(destinationPath));

		return newRefs;
	}
}

#if eval
private typedef FilesAndDirectories = {
	final files: FileList;
	final directories: DirectoryList;
};

#else
@:structInit
private class FilesAndDirectories {
	public final files: FileList;
	public final directories: DirectoryList;

	public function new(files: FileList, directories: DirectoryList) {
		this.files = files;
		this.directories = directories;
	}
}
#end
