%{
package main
import("os"; "os/exec"; "io"; "text/scanner"; "fmt"; "strings"; "regexp")
var program string
var errstate bool=false
const COMPILER="/bin/g++"
%}
%union {
	value string
}
%type  <value> top;
%type  <value> list;
%type  <value> command;
%token <value> STRING;
%token HWCOMMAND;
%token EOF;
%%
top	: list
	{ program=fmt.Sprintf("#include<iostream>\nint main(){%v\n}", $1); }
	;

list	: /* empty */
	{ $$=""; }
	| list command
	{ $$=fmt.Sprintf("%v\n\t%v", $1, $2); }
	;

command : HWCOMMAND ';'
	{ $$=fmt.Sprintf("std::cout<<\"Hello, World!\"<<std::endl;"); }
	| HWCOMMAND STRING ';'
	{ $$=fmt.Sprintf("std::cout<<\"Hello, %v!\"<<std::endl;", $2); }
	;
%%
type MainLex struct{ scanner.Scanner }
func (x *MainLex) Error(s string){fmt.Printf("ERROR: Parse: %s.\n", s); errstate=true}
func(l *MainLex)Lex(lval *yySymType)int{
	token, lit := l.Scan(), l.TokenText()
	//fmt.Printf("\tToken: %-10v\tliteral: %-15s\n", scanner.TokenString(token), lit)
	switch int(token){
		case scanner.Ident: if(lit=="helloworld") { return HWCOMMAND; }
		case scanner.String: lval.value=strings.Trim(lit, `"`); return STRING;
		case scanner.EOF: return 0;
	}
	return int(token)
}
func yyCompile(){
	if(errstate){return};
	app:=regexp.MustCompile(`(.*)(\.hw)$`).ReplaceAllString(os.Args[1], `$1.out`)
	gcc:=exec.Command(COMPILER, "-o", app, "-x", "c++", "-")
	stdin, _:=gcc.StdinPipe()
	go func(){defer stdin.Close(); io.WriteString(stdin, program)}()
	_, err:=gcc.CombinedOutput()
	if err!=nil{fmt.Printf("ERROR: %s\n", err)}
}

func main() {
	if len(os.Args)==1{fmt.Println("Usage:", os.Args[0], "[FILE.hw]"); return}

	file, err:=os.Open(os.Args[1])
	if err!=nil{fmt.Printf("Input file not found.\n")}
	defer file.Close()

	lx:=new(MainLex)
	lx.Init(file)
	yyParse(lx)
	yyCompile()
}
