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
### `delete`
Delete files or directories.
#### Attributes

| Attribute name | Description                                                                              | Required |
|----------------|------------------------------------------------------------------------------------------|:--------:|
| dir            | The directory to delete, including all its files and subdirectories. **DO NOT SET `.`**. |    Y     |

#### Examples 

```xml
<delete dir="target"/>
```
### `echo`
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
### `javac`
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
### `mkdir`
Create a directory, including parents if they don't exist.
#### Attributes

| Name | Description              | Required |
|------|--------------------------|:--------:|
| dir  | The directory to create. |    Y     |

#### Examples

```xml
<mkdir dir="target"/>
```
## Java sample
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project name="Generator" default="build">
    <property name="verbose" value=""/>
    <target name="print_ant_info" if="verbose">
        <echo message="${ant.home}"/>
    </target>
    <target name="build"></target>
</project>
```