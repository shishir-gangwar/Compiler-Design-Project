#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>
int size=1000;
int i;
int key=0,sym=0;
struct token{
   char name[100],type[100];
   int line;
   char attribute[100];
};
                               
struct token* hash[1000];
struct token* symbol[1000]; 
struct token* item;

void insert(char data[], char type[], int line) {
   struct token *item = (struct token*) malloc(sizeof(struct token));
   strcpy(item->name,data); 
   strcpy(item->type,type); 
   item->line = line;
   hash[key++] = item;
}
void display(){
   printf("\t\tToken-Name\t\t\t\tToken-Type\t\tLine no\n");
   printf("\t--------------------------------------------------------------------------------\n");
   for(i=0;i<key;++i){
      if(hash[i] != NULL)
         printf("%30s\t\t%30s\t\t%d\n",hash[i]->name,hash[i]->type,hash[i]->line);
   }
}
int searchS(char *data){
   for(i=0;i<sym;++i){
      if(strcmp(symbol[i]->name,data)==0){
         return 1;
      }
   }
   return 0;
}
void insertS(char data[], char type[], int line, char attribute[]){
   if(searchS(data)==1) return;
   struct token *item = (struct token*) malloc(sizeof(struct token));
   strcpy(item->name,data); 
   strcpy(item->type,type);
   strcpy(item->attribute,attribute);
   item->line = line; 
   symbol[sym++] = item;   
}
void displayS(){
   printf("\n\n\t\t\t\t\tSYMBOL TABLE\n\n");
   printf("\t\tToken-Name\t\t\t\tToken-Type\t\t\t\tDatatype\t\tLine no\n");
   printf("\t---------------------------------------------------------------------------------------------------------------------------\n");
   for(i=0;i<sym;++i){
      if(symbol[i] != NULL)
         printf("%30s\t\t%30s\t\t%30s\t\t%d\n",symbol[i]->name,symbol[i]->type,symbol[i]->attribute,symbol[i]->line);
   }
}
