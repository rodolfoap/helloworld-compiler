# Hello World Compiler

* Lexer : text/scanner
* Parser: goyacc
* Transpile: C++
* Compiler: gcc

Reads a _helloworld_ file, parses it and compiles it.

## Usage

```
$ goyacc hwcompile.y && go build

$ cat input.hw;

helloworld;
helloworld "Bonzo";
helloworld "Robert Plant";
helloworld "James Patrick Page";
helloworld "John Richard Paul Jones Baldwin";
helloworld "helloworld";

$ ./hwcompile input.hw

$ ls -l hello.bin

-rwxr-xr-x 1 rap rap 17240 Dec  8 06:17 hello.bin

$ ./hello.bin

Hello, World!
Hello, Bonzo!
Hello, Robert Plant!
Hello, James Patrick Page!
Hello, John Richard Paul Jones Baldwin!
Hello, helloworld!
```
