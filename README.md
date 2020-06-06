# locator

File system utility for Haxe.

Requires **Haxe 4**. Only for `sys` targets.

(Tested with: Haxe 4.1.1, `eval`/`hl`. Some methods are not available on `java`).

## Types

- `PathString`: Path of file/directory. Underlying type of `FilePath` and `DirectoryPath`.
- `FilePath`: File path. The actual file does not necessarily have to exist.
- `FileRef`: Represents a file that actually exists.
- `FileList`: Array of `FileRef`s.
- `DirectoryPath`: Directory path. The actual directory does not necessarily have to exist.
- `DirectoryRef`: Represents a directory that actually exists.

Internally:

- All of these (except `FileList`) are just abstract based on `String`.
- The path is automatically converted to absolute when creating any value of the types above.


## Compilation flags

|flag|description|
|---|---|
|locator_windows|Uses backslash for path delimiter. Automatically set on Windows.|
|locator_validation_disable|Skips validation of file/directory paths.|


## Dependencies

- [sinker](https://github.com/fal-works/sinker) v0.2.0 or compatible

See also:
[FAL Haxe libraries](https://github.com/fal-works/fal-haxe-libraries)
