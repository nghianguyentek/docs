# Apache Ant
*Apache Ant is a Java library and command-line tool for building applications, especially those written in Java, C, and C++.*

## Build-file
*An Ant build-files is an `.xml` file, often named `build.xml`, and must have one and only one [`project`](#project-element) element. A [`project`](#project-element) may have one or more [`property`](#property-element) or [`path`](#path-element) but must have at least one [`target`](#target-element) (i.e., the `default` target). Each [`target`](#target-element) has zero and more tasks, which are either [built-in](#built-in-tasks) or user-defined.*
### `project` element
#### Attributes
| Name    | Description                                                         | Required |
|:--------|---------------------------------------------------------------------|:--------:|
| name    | Project name. Should be provided.                                   |    N     |
| default | Default target to run.  Should be provided                          |    N     |
| basedir | If not provided, the directory that contains the build-file is used |    N     |
### `property` element
#### Attributes

| Name        | Description                                                    | Required |
|:------------|----------------------------------------------------------------|:--------:|
| name        | Property name. Case-sensitive.                                 |   Y(N)   |
| value       | Property value.                                                |   Y(N)   |
| environment | Specify a prefix that is used to access environment variables. |   N(Y)   |

#### Examples
```xml
<project>
    <property name="verbose" value=""/>
    <property environment="env"/>
    <property name="deployment.dir" value="${env.DEPLOYMENT_DIR}"/>
</project>
```
### `path` element
#### Attributes

| Name        | Description    | Required |
|:------------|----------------|:--------:|
| id          | Referenced id. |    Y     |
| path        | Path location. |    N     |

#### Examples
```xml
<path id="classpath" path="lib" />
```

*`path` can contain [path structure elements](ant.md#path-structure-elements).*

### `target` element
#### Attributes

| Name    | Description                                                                                                                                                                                     | Required |
|:--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| name    | Target name. Often is used as a value of `project.default` or `target.depends` attribute                                                                                                        |    Y     |
| depends | A comma-separated list of other targets that the current one depends on (i.e., must run before). Depended targets run sequentially from left to right, and **_doesn't stop if having errors_**. |    N     |
| if      | Run the current target only if the specified attribute exists                                                                                                                                   |    N     |
| unless  | Run the current target only if the specified attribute does not exist                                                                                                                           |    N     |
#### Examples
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project name="Kihon backend" default="show_all_messages">
    <!-- toggle the below comment to see the difference -->
<!--    <property name="no_warning" value=""/>--> 
    <property name="welcome_message" value="Welcome to Ant world!"/>
    <property name="my_message" value="This is my first Ant build-file."/>
    <target name="show_all_messages" depends="show_warning, show_welcome">
        <echo message="${my_message}"/> <!-- echo is a built-in task -->
    </target>
    <target name="show_warning" unless="no_warning">
        <echo message="You should check the Ant's version before further readings"/>
    </target>
    <target name="show_welcome" if="welcome_message">
        <echo message="${welcome_message}"/>
    </target>
</project>
```
## Built-in tasks
### `chmod` task
Change permissions of a file or all files in specific directories.
#### Attributes
| Name | Description                                 | Required |
|------|---------------------------------------------|:--------:|
| file | File to change permissions.                 |   Y(N)   |
| dir  | Files in a directory to change permissions. |   N(Y)   |
| perm | Permissions to set.                         |    Y     |
#### Examples
- Copy a specific file `src_file` to `dest_dir` directory.
```xml
<chmod file="file" perm="ugo+x"/>
```
### `copy` task
Copy files and directories to a destination directory.

*It's common to use [`fileset`](ant.md#fileset-element) in `copy`.*
#### Attributes
| Name  | Description                                | Required |
|-------|--------------------------------------------|:--------:|
| todir | Destination directory. **DO NOT SET `.`**. |    Y     |
| file  | File to copy                               |    N     |
#### Examples
- Copy a specific file `src_file` to `dest_dir` directory.
```xml
<copy file="src_file" todir="dest_dir"/>
```
- Copy files and subdirectories of `src_dir` directory to `dest_dir` directory. 
```xml
<copy todir="dest_dir">
    <fileset dir="src_dir"/>
</copy>
```
### `delete` task
Delete files or directories.
#### Attributes
| Name | Description                                                                                                                                                                                  | Required |
|------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| dir  | The directory to delete, including all its files and subdirectories. **DO NOT SET `.`**. In the case for deleting specified files, we need to use [fileset](ant.md#fileset-element) instead. |   Y(N)   |
#### Examples
- Delete all files and subdirectories in a specific directory.
```xml
<delete dir="target"/>
```
- Delete specific files.
```xml
<delete>
    <fileset dir="target_dir" includes="*.log"/>
</delete>
```
### `echo` task
Display messages to a file descriptor; default value is the standard output.
#### Attributes
| Name    | Description                                                  | Required |
|---------|--------------------------------------------------------------|:--------:|
| message |                                                              |    N     |
| level   | `error` > `warning` (default) > `info` > `verbose` > `debug` |    N     |
#### Examples
```xml
<echo message="Welcome to Ant world" />
```
### `exec` task
Display messages to a file descriptor; default value is the standard output. The arguments and environment variables if any are specified by [arg](ant.md#arg-element) and [env](ant.md#env-element) elements respectively.
#### Attributes
| Name       | Description                                                                             | Required |
|------------|-----------------------------------------------------------------------------------------|:--------:|
| executable | The name of the executable file                                                         |    Y     |
| dir        | The directory where to execute the file. Default value is the current working directory |    N     |
#### `arg` element
##### Attributes
| Name | Description        | Required |
|------|--------------------|:--------:|
| line | The arguments line |    Y     |
#### `env` element
##### Attributes
| Name  | Description    | Required |
|-------|----------------|:--------:|
| key   | Variable name  |    Y     |
| value | Variable value |    Y     |
#### Examples
```xml
<exec dir="${executable-file.dir}" executable="./run-test.sh">
    <env key="HOST" value="d67"/>
    <arg line="--cases 1-4"/>
</exec>
```
### `javac` task
Compile Java sources.
#### Attributes
| Name       | Description                                                                                                                | Required |
|------------|----------------------------------------------------------------------------------------------------------------------------|:--------:|
| srcdir     | Source directory. Location of `.java` files.                                                                               |   Y(N)   |
| destdir    | Destination directory. Location to store `.class` files.                                                                   |    N     |
| debug      | Indicate source codes will be compiled with debug information. If set to `true`, must set the `debuglevel` attribute also. |    N     |
| debuglevel | source                                                                                                                     |    N     |
#### Examples
```xml
<javac debug="true" debuglevel="source" srcdir="src" distdir="target" />
```
### `mkdir` task
Create a directory, including parents if they don't exist.
#### Attributes

| Name | Description              | Required |
|------|--------------------------|:--------:|
| dir  | The directory to create. |    Y     |

#### Examples
```xml
<mkdir dir="target"/>
```
## Path structure elements
### `fileset` element
#### Attributes
| Name     | Description                                                                                                 | Required |
|----------|-------------------------------------------------------------------------------------------------------------|:--------:|
| dir      | Root directory of this file set.                                                                            |    Y     |
| includes | A comma-separated or space-separated file-patterns list to be included. If not set, all files are included. |    N     |
| excludes | A comma-separated or space-separated file-patterns list to be excluded.                                     |    N     |
#### Examples
- Delete exactly some specific files.
```xml
<fileset dir="lib" includes="ant.jar internal/*.jar/>
```
- Delete all files except some specified files.
```xml
<fileset dir="lib" excludes="ant.jar tmp/*.jar"/>
```
## Java sample
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project name="Generator" default="build">
    <property name="verbose" value=""/>
    <target name="print_ant_info" if="verbose">
        <echo message="${ant.home}"/>
    </target>
    <target name="build"/>
</project>
```