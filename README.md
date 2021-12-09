# Golang/Goyacc Hello World Compiler

Reads a _helloworld_ file, parses it using [**goyacc**](https://pkg.go.dev/modernc.org/goyacc) and compiles it to a binary.

## Syntax

There are just two productions (this is meant to be simple):

* `helloworld ;`, which will generate a "Hello, World!"
* `helloworld "some string";`, which will generate a "Hello, some string!"

The scanner discards whitespaces. Used the Go [**text/scanner**](https://pkg.go.dev/text/scanner) for its simplicity. The parsed content is then transpiled to C++ and compiled into a binary using `g++` (must be installed).

## Build the compiler

```
$ goyacc hwcompile.y && go build
```

## Compiling helloworld programs

```
$ cat prog.hw;

helloworld;
helloworld "Bonzo";
helloworld "Robert Plant";
helloworld "James Patrick Page";
helloworld "John Richard Paul Jones Baldwin";
helloworld "helloworld";

$ ./hwcompile prog.hw

$ ls -l prog.out

-rwxr-xr-x 1 rap rap 17240 Dec  9 02:57 prog.out

$ ./prog.out

Hello, World!
Hello, Bonzo!
Hello, Robert Plant!
Hello, James Patrick Page!
Hello, John Richard Paul Jones Baldwin!
Hello, helloworld!
```
