%{
    int lineno=1;
    char *tempid;
    #include"hashtable.c"
    #include<ctype.h>
    #include<string.h>
    char types[100];
%}
identifier     [a-zA-Z][_a-zA-Z0-9]*
header         "#include"[ ]*["<""/""]{identifier}".h"?[">""/""]
type         "const"|"short"|"signed"|"unsigned"|"int"|"float"|"long"|"double"|"char"|"void"
storage         "auto"|"extern"|"register"|"static"|"typedef"
qualifier     "const"|"volatile"
digits         [0-9]+
decimal      0|[1-9][0-9]*
lint         {decimal}"L"
llint         {decimal}"LL"
double          {decimal}?"."{digits}
float          {double}"f"
scientific   {double}"e"{decimal}
scientificf  {scientific}"f"
str_literal  [a-zA-Z_]?\"(\\.|[^\\"])*"\""
character    "'"."'"
space         [ \t]
next_line    \n 
s_operator     "["|"]"|","|":"|"{"|"}"|"("|")"|"="|[-+*%/<>&|^]

%x mlcomment 
%x slcomment
%%
"/*"                BEGIN(mlcomment);
<mlcomment>[^*\n]*                 ;
<mlcomment>\n                     ;
<mlcomment>"*"+[^/]                ;
<mlcomment>"*"+"/"    BEGIN(INITIAL);

"//"                BEGIN(slcomment);
<slcomment>[^\n]*                ;
<slcomment>\n         BEGIN(INITIAL);

{header}                ;
{type}                    {strcpy(types,yytext);insertS(yytext,"datatype",lineno,"NA");return TYPE;}
{storage}                {insertS(yytext,"storage class",lineno,"NA");return STORAGE;}
{qualifier}                {insertS(yytext,"qualifier",lineno,"NA");;return QUALIFIER;}
printf                  {insertS(yytext,"identifier",lineno,"NA");;return PRINTF;}
scanf                   {insertS(yytext,"identifier",lineno,"NA");;return SCANF;}
while                     {insertS(yytext,"keyword",lineno,"NA");;return WHILE;}
if                         {insertS(yytext,"keyword",lineno,"NA");;return IF;}
else                     {insertS(yytext,"keyword",lineno,"NA");;return ELSE;}
return                     {insertS(yytext,"keyword",lineno,"NA");;return RETURN;}
do                         {insertS(yytext,"keyword",lineno,"NA");;return DO;}
continue                {insertS(yytext,"keyword",lineno,"NA");;return CONTINUE;}
break                    {insertS(yytext,"keyword",lineno,"NA");;return BREAK;}
goto                    {insertS(yytext,"keyword",lineno,"NA");;return GOTO;}
default                    {insertS(yytext,"keyword",lineno,"NA");;return DEFAULT;}
enum                    {insertS(yytext,"keyword",lineno,"NA");return ENUM;}
case                    {insertS(yytext,"keyword",lineno,"NA");return CASE;}
switch                    {insertS(yytext,"keyword",lineno,"NA");return SWITCH;}
for                        {insertS(yytext,"keyword",lineno,"NA");return FOR;}
sizeof                    {insertS(yytext,"keyword",lineno,"NA");return SIZEOF;}
struct                    {insertS(yytext,"keyword",lineno,"NA");return STRUCT;}
union                    {insertS(yytext,"keyword",lineno,"NA");return UNION;}
{decimal}                {insertS(yytext,"decimal",lineno,"NA");return NUM;}
{float}                    {insertS(yytext,"float",lineno,"NA");return NUM;}
{double}                {insertS(yytext,"double",lineno,"NA");return NUM;}
{llint}                    {insertS(yytext,"longlongint",lineno,"NA");return NUM;}
{lint}                    {insertS(yytext,"longint",lineno,"NA");return NUM;}
{scientific}            {insertS(yytext,"scientific",lineno,"NA");return NUM;}
{scientificf}            {insertS(yytext,"scientificf",lineno,"NA");return NUM;}
{character}                {insertS(yytext,"string",lineno,"NA");return STR_LITERAL;}
{str_literal}             {insertS(yytext,"string",lineno,"NA");return STR_LITERAL;}
{identifier}             {insertS(yytext,"identifier",lineno,types);return ID;}
"+="                    {insertS("+=","operator",lineno,"NA");return PE;}
"-="                    {insertS("-=","operator",lineno,"NA");return MI;}
"*="                    {insertS("*=","operator",lineno,"NA");return ME;}
"/="                    {insertS("/=","operator",lineno,"NA");return DE;}
">>"                    {insertS(">>","operator",lineno,"NA");return RS;}
"<<"                    {insertS("<<","operator",lineno,"NA");return LS;}
"++"                     {insertS("++","operator",lineno,"NA");return II;}
"--"                    {insertS("--","operator",lineno,"NA");return II;}
"=="                    {insertS("==","operator",lineno,"NA");return EE;}
"!="                    {insertS("!=","operator",lineno,"NA");return NE;}
">="                    {insertS(">=","operator",lineno,"NA");return GE;}
"<="                    {insertS("<=","operator",lineno,"NA");return LE;}
"||"                    {insertS("||","operator",lineno,"NA");return LO;}
"&&"                    {insertS("&&","operator",lineno,"NA");return LA;}
"!"                        {insertS("!","operator",lineno,"NA");return NA;}
{s_operator}            {insertS(yytext,"operator",lineno,"NA");return yytext[0];}
{space}                 ;
{next_line}                {lineno++;}
";"                        {strcpy(types,"NA");return yytext[0];}
.                        {printf("error at line no %d",yylineno,"NA");}
%%
int yywrap(){return 1;}
