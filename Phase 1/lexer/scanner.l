%{
	#include"scanner.h"
	#include"hashtable.c"
	int line_no=1;
	int prev=0;
	char ptext[100]="NULL",ptype[100]="NULL";
%}

identifier	 [a-zA-Z][_a-zA-Z0-9]*
header		 "#include"[ ]*["<""/""]{identifier}".h"?[">""/""]
keyword		 "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"
digits		 [0-9]+
decimal      0|[1-9][0-9]*
lint		 {decimal}"L"
llint		 {decimal}"LL"
double 		 {decimal}?"."{digits}
float 		 {double}"f"
scientific   {double}"e"{decimal}
scientificf  {scientific}"f"
str_literal  [a-zA-Z_]?\"(\\.|[^\\"])*"\""
character    "'"."'"
p_operator	 "->"|"/="|"%="|">>="|"="|"+="|"-="|"*="
a_operator	 "<<"|">>"|"=="|"<="|">="|"<<="|"&="|"^="|"|="|[-+*%/<>&|^]
b_operator   "&&"|"||"|"!="
i_operator   "++"|"--"
space	     [ \t]
next_line    \n
array		 "["|"]"
comma		 ","
colon		 ":"
semicolon	 ";"
o_brace		 "{"
c_brace		 "}"
o_paren      "("
c_paren		 ")"
%x mlcomment 
%x slcomment
%%
"/*"				BEGIN(mlcomment);
<mlcomment>[^*\n]* 				;
<mlcomment>\n     				;
<mlcomment>"*"+[^/]				;
<mlcomment>"*"+"/"	BEGIN(INITIAL);

"//"				BEGIN(slcomment);
<slcomment>[^\n]*				;
<slcomment>\n 		BEGIN(INITIAL);

{header}				return HEADER;
{keyword}				return KEYWORD;
{character}				return CHAR;
{decimal} 				return DECIMAL;
{lint}					return LONG_INT;
{double} 				return DOUBLE;
{llint}					return LONG_LONG_INT;
{float}					return FLOAT;
{scientific}			return SCIENTIFIC;
{scientificf}			return SCIENTIFIC_F;
{str_literal} 			return STR_LITERAL;
{identifier}		 	return IDENTIFIER;
{p_operator} 			return P_OPERATOR;
{a_operator} 			return A_OPERATOR;
{b_operator} 			return B_OPERATOR;
{i_operator} 			return I_OPERATOR;
{array}		  			return ARRAY;
{comma}		  			return COMMA;
{colon}		  			return COLON;
{o_brace}				return O_BRACE;
{c_brace}				return C_BRACE;
{o_paren}				return O_PAREN;
{c_paren}				return C_PAREN;
{semicolon}	  			return SEMICOLON;
{next_line}				++line_no;
{space} 				;
.						{if(prev!=line_no){printf("%s:Invalid character at line %d\n",yytext,line_no);prev=line_no;}}
%%
int main(void){
	int ntoken=0;
	yyin = fopen("abc.txt","r");
	ntoken=yylex();
	char type[100];
	while(ntoken){	
		switch(ntoken){
			case CHAR 		:	strcpy(type,"CHARACTER");
								break;	
			case HEADER 	:	strcpy(type,"HEADER");
								break;
			case KEYWORD 	: 	strcpy(type,"KEYWORD");
						  		break;
			case STR_LITERAL:	strcpy(type,"STRING");
								break;
			case IDENTIFIER :	strcpy(type,"IDENTIFIER");
								break;
			case P_OPERATOR :	strcpy(type,"PRIMARY_EXP_OPERATOR");
								break;
			case A_OPERATOR :	strcpy(type,"ASSIGNMENT_OPERATOR");
								break;
			case B_OPERATOR :	strcpy(type,"BINARY_OPERATOR");
								break;
			case I_OPERATOR :	strcpy(type,"INCREMENT_OPERATOR");
								break;
			case ARRAY 		:	strcpy(type,"ARRAY-SUBSCRIPT OPERATOR");
								break;
			case COMMA 		:	strcpy(type,"COMMA");
								break;
			case COLON 		: 	strcpy(type,"PUNCTUATOR");
								break;
			case O_BRACE    :	strcpy(type,"OPENIN'BRACE");
								break;
			case C_BRACE 	:	strcpy(type,"CLOSIN'BRACE");
								break;
			case O_PAREN    :	strcpy(type,"OPENIN'PARENTHESES");
								break;
			case C_PAREN	:	strcpy(type,"CLOSIN'PARENTHESES");
								break;
			case DECIMAL   	:	strcpy(type,"DECIMAL");
								break;
			case LONG_INT   :   strcpy(type,"LONG INT");
								break;
			case LONG_LONG_INT: strcpy(type,"LONG LONG INT");
								break;
			case FLOAT      :   strcpy(type,"FLOAT");
								break;					
			case DOUBLE   	:	strcpy(type,"DOUBLE");
								break;
			case SCIENTIFIC :   strcpy(type,"SCIENTIFIC");
								break;
			case SCIENTIFIC_F:  strcpy(type,"SCIENTIFIC_F");
								break;
			case SEMICOLON  : 	strcpy(type,"SEMICOLON");
								break;
		}
		char pptext[100]="NULL";
		strcpy(pptext,ptext);
		insert(yytext,type,line_no);
		strcpy(ptext,yytext);
		strcpy(ptype,type);
		ntoken = yylex();
		if(!strcmp(yytext,"(")){
			if(!strcmp(ptype,"IDENTIFIER")){
				insertS(ptext,"function",line_no);
			}
		}
		else{
			if(!strcmp(ptype,"IDENTIFIER")){
				insertS(ptext,"identifier",line_no);
			}
		}
	}
	printf("\n");
	display();
	displayS();
	return 0;
}
int yywrap(){
	return 1;
}
