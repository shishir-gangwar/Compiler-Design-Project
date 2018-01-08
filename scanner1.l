%{
	#include"scanner1.h"
	#include<stdio.h>
%}
%%
"\""						return DOUBLE_QUOTES;
:							return COLON;
;							return SEMICOLON;
"int"                   	return INT;
"float"                 	return FLOAT;
"double"                	return DOUBLE;
"char"                  	return CHAR;
"bool"                  	return BOOL;
"long"[ ]+"int"        		return LONG_INT;
"long"[ ]+"long"[ ]+"int"   return LONG_LONG_INT;
"long"[ ]+"double"          return LONG_DOUBLE;
0|[1-9][0-9]*				return INT_LITERAL;
["main"|"return"]			return KEYWORD;
[a-zA-Z][_a-zA-Z0-9]*		return IDENTIFIER;
[ \n\t]						;
[{}()]		return BRACE;
[-+*%/=<>&]	return OPERATOR;
%%
int main(){
	int vtoken,ntoken=0;
	yyin = fopen("abc.txt","r");
	printf("begin:\n");
	ntoken=yylex();
	int i=1;
	while(ntoken){
		printf("%d) \"%s\" is a ",i,yytext);
		++i;
		switch(ntoken){
			case DOUBLE_QUOTES: printf("")
			case SEMICOLON: printf("semicolon\n");
							break;
			case KEYWORD: printf("keyword\n");
						  break;
			case CHAR:	printf("character\n");
						break;
			case BOOL:  printf("boolean\n");
						break;
			case INT:	printf("integer\n");
						break;
			case LONG_INT:	printf("long int\n");
							break;
			case LONG_LONG_INT:	printf("long long int\n");
								break;
			case IDENTIFIER:	printf("identifier\n");
								break;
			case INT_LITERAL:	printf("literal\n");
								break;
			case DOUBLE:		printf("double\n");
								break;
			case LONG_DOUBLE:	printf("long double\n");
								break;
			case BRACE:			printf("a brace\n");
								break;
			case OPERATOR:		printf("a operator\n");
								break;
			default:			printf("invalid string\n");
		}
		ntoken = yylex();
	}
	printf(":end\n");
	return 0;
}
int yywrap(){
	return 1;
}