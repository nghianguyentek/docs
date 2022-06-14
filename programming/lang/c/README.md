# C Programming Language
## Prerequisites
### Skills
- Reading English.
- Using computer:
  - Working with command-line and shell scripting.
  - Plaintext file manipulation: creating, editing, and saving (with a specific extension).
  - Installing software.
### Software
- A C compiler
  - Linux and macOS: you can use the built-in `gcc`.
  - Windows: you should install [Visual Studio Community](https://visualstudio.microsoft.com/vs/community/)
and use `cl`.
- A text editor or IDE
  - Linux and macOS: `vim`
  - Windows: [Visual Studio Community](https://visualstudio.microsoft.com/vs/community/).
## Composing source
A C source file is `.c` plaintext file.  
### main() function
Our application can have many `.c` files, however, we need a source file that contains a [main() function](#main-function) 
to indicate the entry point of our application (i.e., where our application start its execution). We will discover about 
[function](function.md) (and also revisit it) later. So, at here, you don't need to worry about it.
```c
int main() {
    return 0;
}
```
In the upper codes, `return 0;` means the program ends normally (i.e., no errors).
### Importing codes from other sources
To access codes from other files, we place the `include` directive at the beginning of our source file.
```c
#include<stdio.h>
```
In this case, we imported codes of the `stdio` (standard input output) library.
### Calling functions in imported libraries
Since we imported the `stdio` library, we can call the `printf()` function to print a message out to the standard output 
stream.
```c
printf("Welcome to C world\n");
```
As you see, our message is encapsulated by double quotes and ends with an `\n`, a new line symbol.
### Examples
- A silent program.
```c
int main() {
    return 0;
}
```
- Display a welcome message
```c
#include<stdio.h>

int main() {
    printf("Welcome to C world!\n");
    return 0;
}
```
## Compiling
- Linux and macOS
```shell
gcc 01.c -o 01.o
```
- Windows
```shell
cl 01.c
```
## Running
- Linux and macOS
```shell
./01.o
```
- Windows
```shell
01.exe
```
