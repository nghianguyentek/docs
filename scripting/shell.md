# Shell script
## Built-in commands
### `echo` command
Displays a line of text.
####Examples
- Displays `Hello Kitty`
```shell
echo Hello Kitty
```
### `cd` command
Changes the current directory to a specific directory.
#### Syntax
`cd dir_path`
####Examples
- Change to $HOME if $HOME is set
```shell
cd
```
- Change to `Documents` directory of the current user (assuming it exists) 
```shell
cd ~/Documents
```
- Go upper to the parent of the current directory if it has
```shell
cd ..
```
### `export` command
Export variables to the environment for later use.
#### Attributes
| Syntax | Description                                   |
|--------|-----------------------------------------------|
| -p     | List all exported variables.                  |
| -n     | Remove a exported variable                    |
| -a     | Calculate files also (default directory only) |
#### Examples
- Display all exported variables
```shell
export -p
```
- Set a new environment variable and update it
```shell
export MY_NAME=nghia.nguyen
echo $MY_NAME
export MY_NAME=nghianguyen.tek
echo $MY_NAME
```
### `du` command
Display disk usage of files and directories.
#### Attributes
| Syntax | Description                                                                   |
|--------|-------------------------------------------------------------------------------|
| -d N   | Scan to maximum N deep                                                        |
| -h     | Human-readable units (e.g., K for Kilobytes, M for Megabytes, G for Gigabytes |
| -a     | Calculate files also (default directory only)                                 |
#### Examples
- Display disk usage of a directory and its subdirectories (maximum-depth is 1)
```shell
du -hd 1 /views
```
- Display disk usages in descending order
```shell
du -ad 1 / 2>/dev/null | sort -nrk 1
```
## `sort` command
Sort lines of text files.
#### Attributes
| Syntax | Description         |
|--------|---------------------|
| -n     | numeric sorting     |
| -r     | reverse the result  |
| -k N   | based on column Nth |
#### Examples
- Sorting disk usages in descending order
```shell
du -ad 1 / 2>/dev/null | sort -nrk 1
```


