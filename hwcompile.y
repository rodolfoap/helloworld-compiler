%{
package main
import("os"; "os/exec"; "io"; "text/scanner"; "fmt"; "strings"; "regexp")
var names []string
var errstate bool=false
const COMPILER="/bin/g++"
%}
%union {
	value string
}
%token <value> STRING;
%token HWCOMMAND;
%%
list	: /* empty */
	| list command
	;
command : HWCOMMAND ';'
	{ names=append(names, fmt.Sprintf("Hello, World!")); }
	| HWCOMMAND STRING ';'
	{ names=append(names, fmt.Sprintf("Hello, %v!", $2)); }
	;
%%
type MainLex struct{ scanner.Scanner }
func (x *MainLex) Error(s string){fmt.Printf("ERROR: Parse: %s.\n", s); errstate=true}
func(l *MainLex)Lex(lval *yySymType)int{
	token, lit := l.Scan(), l.TokenText()
	// fmt.Printf("\tToken: %-10v\tliteral: %-15s\n", scanner.TokenString(token), lit)

	switch int(token){
		case scanner.Ident: if(lit=="helloworld") { return HWCOMMAND; }
		case scanner.String: lval.value=strings.Trim(lit, `"`); return STRING;
	}
	return int(token)
}
func yyCompile(){
	if(errstate){return};
	s:="";
	for _, n:=range names{s=strings.Join([]string{s, `std::cout<<"`, n, `"<<std::endl;`}, "");}
	prg:=strings.Join([]string{"#include<iostream>\nint main(){", s, "}"}, "");
	app:=regexp.MustCompile(`(.*)(\.hw)$`).ReplaceAllString(os.Args[1], `$1.out`)
	gcc:=exec.Command(COMPILER, "-o", app, "-x", "c++", "-")
	stdin, _:=gcc.StdinPipe()
	go func(){defer stdin.Close(); io.WriteString(stdin, prg)}()
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
