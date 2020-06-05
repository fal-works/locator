# locator

File system utility for Haxe.

Requires **Haxe 4** (tested with 4.1.1).
Only for `sys` targets (tested with `eval` and `hl`).


## Types

- `FilePath`: File path. The actual file does not necessarily have to exist.
- `FileRef`: Represents a file that actually exists.
- `DirectoryPath`: Directory path. The actual directory does not necessarily have to exist.
- `DirectoryRef`: Represents a directory that actually exists.


## Compilation flags

|flag|description|
|---|---|
|locator_debug|Enables validation of file/directory path. Automatically set if `--debug`.|


## Dependencies

- [sinker](https://github.com/fal-works/sinker)

See also:
[FAL Haxe libraries](https://github.com/fal-works/fal-haxe-libraries)
