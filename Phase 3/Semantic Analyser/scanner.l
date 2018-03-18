%{
	#include<bits/stdc++.h>
	vector<string>lines;
	using namespace std;
	int charcount=0;
	string str;
	string func;
	string fname;
	vector<string>fargs;
    int lineno=1;
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
space         " "
tab			\t
next_line    \n 
s_operator     "["|"]"|","|":"|"{"|"}"|"("|")"|"="|[-+*%/<>&|^!]

%x mlcomment 
%x slcomment
%%
"/*"                {charcount+=yyleng;BEGIN(mlcomment);}
<mlcomment>[^*\n]*   {              charcount+=yyleng;;}
<mlcomment>\n         {     charcount=0;++lineno;}
<mlcomment>"*"+[^/]   {             charcount+=yyleng;;}
<mlcomment>"*"+"/"   { charcount+=yyleng;BEGIN(INITIAL);}

"//"                {charcount+=yyleng;BEGIN(slcomment);}
<slcomment>[^\n]*    {charcount+=yyleng;            ;}
<slcomment>\n        {charcount+=yyleng; BEGIN(INITIAL);}

{tab}					{charcount+=1;}
{space}                 {charcount+=1;}
{next_line}             {charcount=0;lineno++;}
{header}                {charcount+=yyleng;;}
{type}                  {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);str = yytext;return TYPE;}
{storage}               {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return STORAGE;}
{qualifier}             {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return QUALIFIER;}
printf                  {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return PRINTF;}
scanf                   {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return SCANF;}
while                   {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return WHILE;}
if                      {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return IF;}
else                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return ELSE;}
return                  {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return RETURN;}
do                      {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return DO;}
continue                {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return CONTINUE;}
break                   {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return BREAK;}
goto                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return GOTO;}
default                 {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return DEFAULT;}
enum                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return ENUM;}
case                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return CASE;}
switch                  {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return SWITCH;}
for                     {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return FOR;}
sizeof                  {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return SIZEOF;}
struct                  {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return STRUCT;}
union                   {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return UNION;}
{decimal}               {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return NUM;}
{float}                 {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return NUM;}
{double}                {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return NUM;}
{llint}                 {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return NUM;}
{lint}                  {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return NUM;}
{scientific}            {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return NUM;}
{scientificf}           {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return NUM;}
{character}             {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return STR;}
{str_literal}           {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return STR;}
{identifier}            {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return ID;}
"+="                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return PE;}
"-="                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return MI;}
"*="                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return ME;}
"/="                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return DE;}
">>"                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return RS;}
"<<"                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return LS;}
"++"                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return PP;}
"--"                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return MM;}
"=="                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return EE;}
"!="                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return NE;}
">="                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return GE;}
"<="                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return LE;}
"||"                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return LO;}
"&&"                    {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return LA;}                       
{s_operator}            {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return yytext[0];}
";"                     {charcount+=yyleng;yylval.s = (char*)malloc(sizeof(yytext));strcpy(yylval.s,yytext);return yytext[0];}
.                       {charcount+=yyleng;printf("error at line no %d",lineno,"NA");}
%%
int yywrap(){return 1;}
