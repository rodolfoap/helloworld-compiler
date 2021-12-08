%{
package main
import("os"; "os/exec"; "text/scanner"; "fmt"; "strings")
var names []string
var errstate bool=false
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
	{ n:=fmt.Sprintf("Hello, World!"); names=append(names, n); }
	| HWCOMMAND STRING ';'
	{ n:=fmt.Sprintf("Hello, %v!", $2); names=append(names, n); }
	;
%%
type MainLex struct{ scanner.Scanner }
func(l *MainLex)Lex(lval *yySymType)int{
	token, lit := l.Scan(), l.TokenText()
	// fmt.Printf("\tToken: %-10v\tliteral: %-15s\n", scanner.TokenString(token), lit)

	switch int(token){
	case scanner.Ident:
		if(lit=="helloworld") { return HWCOMMAND; }
	case scanner.String:
		lval.value=strings.Trim(lit, `"`);
		return STRING;
	}
	return int(token)
}

func (x *MainLex) Error(s string){fmt.Printf("ERROR: Parse: %s.\n", s); errstate=true}

func yyCompile(){
	if(errstate){return};
	s:="";
	for _, n:=range names{s=strings.Join([]string{s, `std::cout<<\"`, n, `\"<<std::endl;`}, "");}
	cmd:=strings.Join([]string{`echo -e "#include<iostream>\nint main(){`, s, `}"|g++ -o hello.bin -x c++ -`}, "");
	_, err:=exec.Command("bash", "-c", cmd).Output()
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
