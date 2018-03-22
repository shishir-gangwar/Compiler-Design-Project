%{
    #include <bits/stdc++.h>
    #include "symbol.cpp"
    using namespace std;
    int yylex(void);
	void yyerror(char *);
	void trim(string& s)
  	{	size_t p = s.find_first_not_of(" \t");
  		s.erase(0, p);
  	    p = s.find_last_not_of(" \t");
    	if (string::npos != p)
        s.erase(p+1);
   	}
   	int first,chc,lno;string typ,dtyp;
	string filename;
	extern string fname;
	extern vector<string>fargs;
	extern int charcount;
	extern string str;
	extern string func;
    extern int lineno;
    int ff=0,fflag=0,dd=0;
%}

%union{
	char *s;
}
%token NUM INT LONG VOID ID
%token STR STORAGE QUALIFIER TYPE
%token FLOAT DOUBLE BOOL CHAR
%token IF ELSE WHILE RETURN SCANF
%token GE ">=" LE "<=" EE "==" NE "!=" LO "||" LA "&&" PP "++" MM "--"
%token PE "+=" MI "-=" ME "*=" DE "/=" LS "<<" RS ">>" 
%token PRINTF GOTO CONTINUE DEFAULT BREAK ENUM DO
%token CASE SWITCH FOR SIZEOF STRUCT UNION

%right '='
%right "+=" "-=" "*=" "/="
%left "||"
%left "&&"
%left '|'
%left '&'
%left "==" "!="
%left '<' ">=" '>' "<="
%left "<<" ">>"
%left '+' '-'
%left '*' '/' '%'
%right '!'
%left '(' ')' '[' ']' "++" "--"

%%
start:            function {temp = head; func = "";} start 
|                 declaration {temp = head;} start 
|                
;

	function:        TYPE ID '(' { insVar("function",$<s>1,$<s>2,lineno,charcount,true);lno=lineno;func = $<s>2;chc=charcount;typ=$<s>2;dtyp=$<s>1;} declordef  
						{if(fflag) search(head,"function",typ,dtyp,chc);ff=0;fflag=0;}
	;
		declordef:		paramdecls ')' compstmt {temp->func_def_flag=0;}
		|				fparamdecls ')' ';'	{temp->func_def_flag=1;}
		|				paramdecls ')' ';'	{temp->func_def_flag=1;}
		;
		paramdecls:		paramdecl 		 
		|					
		;
			paramdecl:       param ',' paramdecl
			|                param
			;

				param:       TYPE ID         { if(temp->func_def_flag==0)insVar("argument",$<s>1,$<s>2,lineno,charcount);
												else{
													if(!fflag && ff<temp->token.size() && temp->datatype[ff]==$<s>1){
														temp->type[ff] = $<s>2;temp->position[ff]=charcount;++ff;
													}
													else{
														fflag=1;
													}
												}
											}
				;

		fparamdecls:		fparamdecl			
		;
			fparamdecl:      fparam ',' fparamdecl
			|                fparam
			|				 fparam ',' paramdecl
			|				 param ',' fparamdecl
			;
				fparam:    TYPE 	{ insVar("argument",$<s>1,"---",lineno,charcount);}
				;

	declaration:     declstmt ';'
	|                expr ';'
	|                functcall ';'
	;
		
	
		declstmt:        TYPE decllist	
		;

			decllist:        ID assign { insVar("variable",str,$<s>1,lineno,charcount);} ',' decllist 
			|                ID assign { insVar("variable",str,$<s>1,lineno,charcount);}
			|                ID arraydecl ',' decllist	{ insVar("variable",str,$<s>1,lineno,charcount);checkDim();cout << dd << "sf";fargs.clear();dd=0;}
			|                ID arraydecl 	{ insVar("variable",str,$<s>1,lineno,charcount);checkDim();cout << dd << "sf";fargs.clear();dd=0;}
			|                ID arraydecl'=' '{' arrassign '}' { insVar("variable",str,$<s>1,lineno,charcount);checkDim();fargs.clear();dd=0;}
			;
				arraydecl:      '[' const ']' {++dd;} arraydecl		
				|				'[' const ']' 				{++dd;}
				;
				arrassign:		NUM ',' arrassign
				|               NUM 
				;
				assign:         '=' expr
				|                
				;

stmt:            compstmt
|                forstmt        
|                whilestmt
|                dowhilestmt
|                ifstmt
|                returnstmt
|                declaration
|                ';'
;    

	compstmt:        '{' { if(temp!=head && temp->first!=1) insVar("_block_","null","	null",lineno,charcount,true); else if(temp!=head) ++temp->first;} stmtlist '}' {if(temp!=head)temp = temp->parent;}	
	;

		stmtlist:        stmt stmtlist
		|                
		;

	forstmt:        FOR '(' fexp ';' fexp ';' fexp ')' stmt
	;

		fexp:            expr
		|                
		;

	whilestmt:        WHILE '(' expr ')' stmt
	;


	dowhilestmt:     DO compstmt WHILE '(' expr ')' ';'
	;

	ifstmt:            IF '(' expr ')' stmt 
	;

	returnstmt:      RETURN ';' 	{checkReturn(1);}
	|                RETURN expr ';'{checkReturn(0);}
	;

	

functcall:       ID  '(' argdecls ')'   {fname=$<s>1;paramcheck();}
;

	argdecls:		argdecl 	
	|
	;
		argdecl:		const ',' argdecl
		|				const	
		;
			const:			NUM  {fargs.push_back($<s>1);}
			| 				ID   {fargs.push_back($<s>1);}
			;


expr :            '(' expr ')'
|                ID "+=" expr  	{scope(temp,$<s>1,charcount);}| ID "+=" error 
|                ID "-=" expr  	{scope(temp,$<s>1,charcount);}| ID "-=" error
|                ID "*=" expr  	{scope(temp,$<s>1,charcount);}| ID "*=" error
|                ID "/=" expr  	{scope(temp,$<s>1,charcount);}| ID "/=" error
|                ID '=' expr   	{scope(temp,$<s>1,charcount);}| ID '=' error
|                expr '+' expr 	{}| expr '+' error
|                expr '-' expr 	{}| expr '-' error
|                expr '*' expr 	{}| expr '*' error
|                expr '/' expr 	{}| expr '/' error
|                expr '<' expr 	{}| expr '<' error
|                expr '>' expr 	{}| expr '>' error
|                "++" ID		{scope(temp,$<s>1,charcount);}|	"++" error
|				 "--" ID  		{scope(temp,$<s>1,charcount);}|	"--" error
|                expr "<<" expr {}| expr "<<" error
|                expr ">>" expr {}| expr ">>" error
|                expr "==" expr {}| expr "==" error
|                expr "!=" expr {}| expr "!=" error
|                expr ">=" expr {}| expr ">=" error
|                expr "<=" expr {}| expr "<=" error
|                expr "||" expr {}| expr "||" error
|                expr "&&" expr {}| expr "&&" error
|                ID '=' functcall {scope(temp,$<s>1,charcount);}
|                '-' expr  %prec '!' 	{}| '-' error
|                ID "++" {scope(temp,$<s>1,charcount);}
|				 ID "--" {scope(temp,$<s>1,charcount);}
|                '!' expr  {}
|                ID  {scope(temp,$<s>1,charcount);}
|                NUM {}
|				 STR {}
;


%%
#include"lex.yy.c"
int count=0;
int main(int argc, char *argv[])
{
   yyin = fopen(argv[1], "r");
   filename = argv[1];
   ifstream myfile(argv[1]);
   string line;
   int cc = 0;
   cout << "\n______________________________________________\n";
    if (myfile.is_open()) {
        while (getline (myfile, line)) {
          trim(line); 
          cout << "|" << ++cc << "|	" << line << endl;
          lines.push_back(line);
        }
        myfile.close();
    }
   cout << "|_|___________________________________________\n\n";
   if(!yyparse())
        cout << "\nParsing complete\n";
    else
        cout << "\nParsing failed\n";
    print(head);
    printformat(head);
    fclose(yyin);
    return 0;
}
         
void yyerror(char *s) {
    printf("Line %d : %s before '%s'\n", lineno, s, yytext);
}



