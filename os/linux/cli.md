# Command line
## `cd`
Changes the current directory.
### Syntax
`cd dest_dir`

**Examples**
- Change to HOME: `cd`
- Change to `Documents` directory: `cd Documents`
## `cp`
Copies files and directories.
### Syntax
- `cp src_path dest_path`
- `cp src_path dest_dir`
- `cp src_path_1 src_path_2 dest_dir`

*`src_path` can be either a file path or a directory path.*
### Options
- `-R`: copies subdirectories recursively.
- `-T`: - `-T`: copies children of the source directory to the target directory only.

**Examples**
- Copies a file 
```shell
  echo Hello, Kitty! > hello.out
  cp hello.out hello01.out
 ```
- 
## `echo`
Displays a line of text.

**Examples**
- Displays `Hello Kitty`: `echo Hello Kitty`
## `ls`
Lists directory contents.
### Options
- `-l`: using long format.
- `-t`: sorted by newest modification time first.
- `-r`: reveres sorting order.
- `-R`: lists subdirectories recursively.

**Examples**
- Lists `Documents` directory using long format: `ls -l Documents`
- Lists `Documents` directory using long format and newest first sorting: `ls -lt Documents`
- Lists `Documents` directory using long format and oldest first sorting: `ls -ltr Documents`
- Lists `Documents` directory and its subdirectories: `ls -lR Documents`
- Lists `Documents` and `Downloads` directories directory using long format and newest first sorting: `ls -lt Documents Downloads`
## File descriptor
### Standard file descriptors
When running a process, there are three opened standard file descriptors, standard in (aka stdin), standard out (aka stdout), and standard error (stderr).

| File   | File descriptor |
|--------|-----------------|
| stdin  | 0               |
| stdout | 1               |
| stderr | 2               |

## I/O redirection
### Output redirection
#### `>` operator
Redirects output to a file (overwrite or create new).

**Examples**
- `echo Hello Kitty! > hello.out`
- `ls -lR Documents > documents_dir.out`
#### `>>` operator
Redirects output to a file (append or create new).

**Examples**
- `echo Hello, Kitty! >> hello.out`
### Input redirection
#### '<' operator
**Examples**
- `grep H < hello.out`
### `/dev/null`