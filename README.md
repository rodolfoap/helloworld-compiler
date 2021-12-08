# Go Hello World Compiler

Reads a _helloworld_ file, parses it using (_**goyacc**_)[https://pkg.go.dev/modernc.org/goyacc] and compiles it to a binary.

## Syntax

There are just two productions (this is meant to be simple):

* `helloworld ;`, which will generate a "Hello, World!"
* `helloworld "some string";`, which will generate a "Hello, some string!"

The scanner discards whitespaces. Used the Go [**text/scanner**](https://pkg.go.dev/text/scanner) for its simplicity. The parsed content is then transpiled to C++ and compiled into a binary using `gcc` (must be installed).

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
