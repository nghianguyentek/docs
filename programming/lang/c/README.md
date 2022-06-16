# C Programming Language
## Prerequisites
### Skills
- Reading English.
- Using computer:
  - Working with command-line and shell scripting.
  - Plaintext file manipulation: creating, editing, and saving (with a specific extension).
  - Installing software.
### Software
- A text editor or IDE to compose source codes.
  - Linux and macOS: `vim`
  - Windows: [Visual Studio Community](https://visualstudio.microsoft.com/vs/community/).
- A C compiler to compile our source code to runnable/executable objects (i.e, `.o` or `.exe` files).
  - Linux and macOS: you can use the built-in `gcc`.
  - Windows: you should install [Visual Studio Community](https://visualstudio.microsoft.com/vs/community/)
    and use `cl`.
#### Install Visual Studio Community in Windows
*I used the Visual Studio Community 2022.*
- Select `Desktop development with C++` workload.
## Composing source
A C source file is `.c` plaintext file. Using your installed editor or IDE to create a new `.c` file, for example, `01.c`.
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
Since we imported the `stdio` library, we can call the `printf()` or `puts()` function to print a message out to the standard output 
stream.
#### A simple printf() calling
```c
printf("Welcome to C world!\n");
```
As you see, our message is encapsulated by double quotes and ends with an `\n`, a new line symbol.
#### A simple puts() calling
```c
puts("Welcome to C world!");
```
It will produce the same output as the upper `printf()`. It means `puts()` function automatically adds the new line feed (i.e., `\n`) for us.
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
    puts("We call printf() and puts() of the stdio library.");
    return 0;
}
```
## Compiling
- Linux and macOS: opening Terminal, go to the source directory where you place your `.c` files and type the command
```shell
gcc 01.c -o 01.o
```
- Windows: in Visual Studio, in `View` menu, selecting `Terminal`. This will open the `Developer PowerShell` terminal and let you type commands. 
```shell
cl .\01.c
```
## Running
- Linux and macOS
```shell
./01.o
```
- Windows
```shell
.\01.exe
```
