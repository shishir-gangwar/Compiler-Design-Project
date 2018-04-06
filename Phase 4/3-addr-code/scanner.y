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
    val *fornode;
%}

%union{
	char *s;
	val *t;
	int i;
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
		declordef:		paramdecls ')' {tac_func(func);}compstmt {temp->func_def_flag=0;tac_func(func,0);}
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
	|                expr ';'	{bfs($<t>1);tac_exp();}
	;
		
	
		declstmt:        TYPE decllist	
		;

			decllist:        ID assign { 	insVar("variable",str,$<s>1,lineno,charcount);
											val *x1 = mknode(NULL,$<s>1,NULL);if($<t>2)$<t>$ = mknode(x1,"=",$<t>2);else $<t>$ = NULL;
											bfs($<t>$);tac_exp();
										} ',' decllist 
			|                ID assign { 	insVar("variable",str,$<s>1,lineno,charcount);
											val *x1 = mknode(NULL,$<s>1,NULL);if($<t>2)$<t>$ = mknode(x1,"=",$<t>2);else $<t>$ = NULL;
											bfs($<t>$);tac_exp();
										}
			|                ID arraydecl ',' decllist	{ insVar("variable",str,$<s>1,lineno,charcount);checkDim();fargs.clear();dd=0;}
			|                ID arraydecl 	{ insVar("variable",str,$<s>1,lineno,charcount);checkDim();fargs.clear();dd=0;}
			|                ID arraydecl'=' '{' arrassign '}' { insVar("variable",str,$<s>1,lineno,charcount);checkDim();fargs.clear();dd=0;}
			;
				arraydecl:      '[' const ']' {++dd;} arraydecl		
				|				'[' const ']' 				{++dd;}
				;
				arrassign:		NUM ',' arrassign
				|               NUM 
				;
				assign:         '=' expr {$<t>$ = $<t>2;}
				|                {$<t>$ = NULL;}
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

	forstmt:        FOR   {$<i>1=tac_while(1);} '(' fexp ';' fexp ';' {tac_while(2);} fexpt ')' stmt {bfs(fornode);tac_exp();tac_while(3,$<i>1);}
	;

		fexp:            expt	
		|                
		;
		fexpt:            expr	 {fornode = $<t>1;}
		|                {fornode = NULL;}
		;

	whilestmt:        WHILE {$<i>1=tac_while(1);}'(' expt ')' {tac_while(2);} stmt {tac_while(3,$<i>1);} 
	;


	dowhilestmt:     DO {$<i>1=tac_while(1);} compstmt WHILE '(' expt ')' {tac_while(2);tac_while(3,$<i>1);} ';'
	;

	ifstmt:           IF '(' expt ')'  {$<i>1=tac_if(1);} stmt {tac_if(0,$<i>1);}
	;

	returnstmt:      RETURN {checkReturn(1);} ';' 	
	|                RETURN expr ';' {checkReturn(0);bfs($<t>2);tac_ret();}
	;

	expt:		 expr {bfs($<t>1);tac_exp();}
	;

functcall:       ID  '(' argdecls ')'   {fname=$<s>1;int f1 =paramcheck();tac_call(fname,0,f1);}
;

	argdecls:		argdecl 	
	|
	;
		argdecl:		const  ',' argdecl
		|				const 
		;
			const:			NUM  {tac_call($<s>1);fargs.push_back($<s>1);}
			| 				ID   {tac_call($<s>1);fargs.push_back($<s>1);}
			;


expr :            '(' expr ')'	{   $<t>$ = $<t>2;}
|                ID '=' expr   	{	scope(temp,$<s>1,charcount);
									$<t>1 = mknode(NULL,$<s>1,NULL);
									$<t>$ = mknode($<t>1,$<s>2,$<t>3);
								}
| 				 ID '=' error
|                ID "+=" expr  	{	scope(temp,$<s>1,charcount);
									val *x1 = mknode(NULL,$<s>1,NULL);
									val *x2 = mknode(x1,"+",$<t>3);
									val *x3 = mknode(NULL,$<s>1,NULL);
									$<t>$ = mknode(x3,"=",x2);
								}	
| 				 ID "+=" error 
|                ID "-=" expr  	{	scope(temp,$<s>1,charcount);
									val *x1 = mknode(NULL,$<s>1,NULL);
									val *x2 = mknode(x1,"+",$<t>3);
									val *x3 = mknode(NULL,$<s>1,NULL);
									$<t>$ = mknode(x3,"=",x2);
									}
| 				 ID "-=" error
|                ID "*=" expr  	{	scope(temp,$<s>1,charcount);
									val *x1 = mknode(NULL,$<s>1,NULL);
									val *x2 = mknode(x1,"+",$<t>3);
									val *x3 = mknode(NULL,$<s>1,NULL);
									$<t>$ = mknode(x3,"=",x2);
								}
| 				 ID "*=" error
|                ID "/=" expr  	{	scope(temp,$<s>1,charcount);
									val *x1 = mknode(NULL,$<s>1,NULL);
									val *x2 = mknode(x1,"+",$<t>3);
									val *x3 = mknode(NULL,$<s>1,NULL);
									$<t>$ = mknode(x3,"=",x2);
								}
| 				 ID "/=" error
|                expr '+' expr 	{	$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr '+' error
|                expr '-' expr 	{	$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr '-' error
|                expr '*' expr 	{	$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr '*' error
|                expr '/' expr 	{	$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr '/' error
|                expr '<' expr 	{	$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr '<' error
|                expr '>' expr 	{	$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr '>' error
|                "++" ID		{	scope(temp,$<s>2,charcount);
									val *x1 = mknode(NULL,$<s>2,NULL);val *x2 = mknode(NULL,"1",NULL);
									val *x3 = mknode(x1,"+",x2);val *x4 = mknode(NULL,$<s>2,NULL);
									$<t>$ = mknode(x1,"=",x3);
								}
|				 "++" error
|				 "--" ID  		{	scope(temp,$<s>2,charcount);
									val *x1 = mknode(NULL,$<s>2,NULL);val *x2 = mknode(NULL,"1",NULL);
									val *x3 = mknode(x1,"-",x2);val *x4 = mknode(NULL,$<s>2,NULL);
									$<t>$ = mknode(x1,"=",x3);
								}
|				 "--" error
|                ID "++" 		{	scope(temp,$<s>1,charcount);
									val *x1 = mknode(NULL,$<s>2,NULL);val *x2 = mknode(NULL,"1",NULL);
									val *x3 = mknode(x1,"+",x2);val *x4 = mknode(NULL,$<s>2,NULL);
									$<t>$ = mknode(x1,"=",x3);
								}
|				 ID "--" 		{	scope(temp,$<s>1,charcount);
									val *x1 = mknode(NULL,$<s>2,NULL);val *x2 = mknode(NULL,"1",NULL);
									val *x3 = mknode(x1,"-",x2);val *x4 = mknode(NULL,$<s>2,NULL);
									$<t>$ = mknode(x1,"=",x3);
								}
|                expr "<<" expr {$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr "<<" error
|                expr ">>" expr {$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr ">>" error
|                expr "==" expr {$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr "==" error
|                expr "!=" expr {$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr "!=" error
|                expr ">=" expr {val *x1 = mknode($<t>1,">",$<t>3);val *x2 = mknode($<t>1,"==",$<t>3);$<t>$ = mknode(x1,"||",x2);}| expr ">=" error
|                expr "<=" expr {val *x1 = mknode($<t>1,"<",$<t>3);val *x2 = mknode($<t>1,"==",$<t>3);$<t>$ = mknode(x1,"||",x2);}| expr "<=" error
|                expr "||" expr {$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr "||" error
|                expr "&&" expr {$<t>$ = mknode($<t>1,$<s>2,$<t>3);}| expr "&&" error
|                functcall {$<t>$ = mknode(NULL,"_ra",NULL);}
|                '-' expr  %prec '!' 	{$<t>1 = mknode(NULL,"-1",NULL);$<t>$ = mknode($<t>1,"*",$<t>2);}|				 '-' error
|                ID  {scope(temp,$<s>1,charcount);$<t>$ = mknode(NULL,$<s>1,NULL);}
|                NUM {$<t>$ = mknode(NULL,$<s>1,NULL);}
|				 STR {$<t>$ = mknode(NULL,$<s>1,NULL);}
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
   cout << "\n____________________________________________";
   cout << "\n___________S_O_U_R_C_E___C_O_D_E____________\n";
    if (myfile.is_open()) {
        while (getline (myfile, line)) {
          trim(line); 
          cout << "|" << ++cc << "|	" << line << endl;
          lines.push_back(line);
        }
        myfile.close();
    }
   cout << "|_|___________________________________________\n\n";
   if(!yyparse()){
        cout << "\nParsing complete\n";
   		print_tac();	
   }
    else
        cout << "\nParsing failed\n";
//    print(head);
//    printformat(head);
//  	print_tac();
    fclose(yyin);
    return 0;
}
         
void yyerror(char *s) {
    printf("Line %d : %s before '%s'\n", lineno, s, yytext);
}



