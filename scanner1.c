#include"scanner.h"
#include<stdio.h>

extern int yylex();
extern int yylineno;
extern char* yytext;

int main(){
	int vtoken,newtoken = yylex();
	while(ntoken){
		printf("%d\n",ntoken);
		if(yylex()!=COLON){
			return 1;
		}
		vtoken = yylex();
		switch(ntoken){
			case INT:
		}
	}
}