%{
    #include <stdio.h>
    #include <stdlib.h>
    extern FILE *fp;
    extern struct token* hash[1000];
    extern int lineno;
%}

%token NUM INT LONG VOID ID
%token STR_LITERAL STORAGE QUALIFIER TYPE
%token FLOAT DOUBLE BOOL CHAR
%token IF ELSE WHILE RETURN SCANF
%token GE LE EE NE LO LA II SH NA
%token PRINTF PE MI ME DE LS RS DO
%token GOTO CONTINUE DEFAULT BREAK ENUM
%token CASE SWITCH FOR SIZEOF STRUCT UNION

%right '=' PE MI ME DE
%left LO
%left LA
%left '|'
%left '&'
%left EE NE
%left '<' GE '>' LE
%left LS RS
%left '+' '-'
%left '*' '/' '%'
%right NA
%left '(' ')' '[' ']' II

%%
start:            function start
|                 declaration start
|                %empty
;

structure:        STRUCT ID '{' start '}'
;

function:        TYPE ID '(' argdecls ')' compstmt
;

declaration:     declstmt ';'
|                  expr ';'
|                structure ';'
|                  functcall ';'
|                error ';'
|                error '}' 
|                error ')'
;

stmt:            compstmt
|                forstmt        
|                whilestmt
|                dowhilestmt
|                ifstmt
|                returnstmt
|                declaration
|                print
|                scan
|                ';'
;    

compstmt:        '{'    stmtlist '}'
;

stmtlist:        stmt stmtlist
|                %empty
;

declstmt:        TYPE decllist
;

decllist:        ID assign ',' decllist 
|                ID assign
|                arraydecl ',' decllist
|                arraydecl
|                arraydecl '=' '{' arrassign
;

dowhilestmt:     DO compstmt WHILE '(' rexp ')' ';'
;

returnstmt:        RETURN ';' 
|                RETURN rexp ';'
;

forstmt:        FOR '(' fexp ';' fexp ';' fexp ')' stmt
;

fexp:            rexp
|                %empty;

whilestmt:        WHILE '(' rexp ')' stmt
;

ifstmt:            IF '(' rexp ')' stmt 
;

arrassign:        NUM ',' arrassign
|                NUM '}'

assign:            '=' rexp
|                %empty
;

functcall:        ID '(' mul ')'     
|                ID '(' ')'            
;
const:            NUM | ID;
mul:            const ',' mul
|                const
;
arraydecl:        ID '[' expr ']'
;

print      :         PRINTF '(' STR_LITERAL ')' ';'
|                   PRINTF '(' STR_LITERAL numlist')' ';'
;

scan      :         SCANF '(' STR_LITERAL snumlist')' ';'
;

argdecls:         TYPE ID argassign',' argdecls
|                TYPE ID argassign
|                %empty
;

argassign:        '=' NUM
|                %empty
;

snumlist:        ',' '&' ID snumlist
|                ',' '&' ID
;

numlist:        ',' ID numlist
|                ',' ID
;

rexp :            expr
|                NA rexp
|                rexp EE rexp
|                rexp NE rexp
|                rexp GE rexp
|                rexp LE rexp
|                rexp LO rexp
|                rexp LA rexp
;
expr :            '(' rexp ')'
|                expr '+' expr
|                expr '-' expr
|                expr '*' expr
|                expr '/' expr
|                ID '=' expr
|                expr '<' expr
|                expr '>' expr
|                ID PE expr
|                ID MI expr
|                ID ME expr
|                ID DE expr
|                ID LS expr
|                ID RS expr
|                ID '=' functcall
|                '-' expr             %prec NA
|                II expr
|                expr II
|                ID
|                NUM
;


%%
#include"lex.yy.c"
#include<ctype.h>
int count=0;

int main(int argc, char *argv[])
{
    yyin = fopen(argv[1], "r");
    
   if(!yyparse())
        printf("\nParsing complete\n");
    else
        printf("\nParsing failed\n");
    
    displayS();
    fclose(yyin);
    return 0;
}
         
yyerror(char *s) {
    printf("Line %d : %s before '%s'\n", lineno, s, yytext);
}



