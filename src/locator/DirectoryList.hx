package locator;

private typedef Data = Array<DirectoryRef>;

/**
	Array of `DirectoryRef`.
**/
@:notNull @:forward
abstract DirectoryList(Data) from Data to Data {
	/**
		Casts `Array<DirectoryRef>` to `DirectoryList` explicitly.
	**/
	public static extern inline function from(array: Data): DirectoryList
		return array;

	@:from static extern inline function fromStdArray(array: std.Array<DirectoryRef>): DirectoryList
		return from(array);

	/**
		Casts `this` to `Array<DirectoryRef>` explicitly.
	**/
	public extern inline function array(): Data
		return this;

	/**
		@return New list of directory names.
	**/
	public inline function getNames(): Array<String>
		return this.map(directory -> directory.getName());

	/**
		Copies all directories in `this` list to `destination` with the same directory names,
		with all of their contents (recursively).
		Overwrites destination files if they already exist.
		@return New list of directories after copied.
	**/
	public inline function copyTo(destinationPath: DirectoryPath): DirectoryList {
		final newDirectories: DirectoryList = [];
		for (i in 0...this.length)
			newDirectories.push(this[i].copyTo(destinationPath));

		return newDirectories;
	}

	/**
		Tries to find a file specified by `relativePath`.
		@param relativePath Typically just a file name.
	**/
	public inline function tryFindFile(relativePath: String): Maybe<FileRef> {
		var found: Maybe<FileRef> = Maybe.none();

		for (i in 0...this.length) {
			final current = this[i].tryFindFile(relativePath);
			if (current.isSome()) {
				found = current;
				break;
			}
		}

		return found;
	}

	/**
		Tries to find a directory specified by `relativePath`.
		@param relativePath Typically just a directory name.
	**/
	public inline function tryFindDirectory(relativePath: String): Maybe<DirectoryRef> {
		var found: Maybe<DirectoryRef> = Maybe.none();

		for (i in 0...this.length) {
			final current = this[i].tryFindDirectory(relativePath);
			if (current.isSome()) {
				found = current;
				break;
			}
		}

		return found;
	}
}
