#include<bits/stdc++.h>
using namespace std;
extern vector<string>lines,fargs;
extern string filename,fname;
extern string func;
extern int lineno;
extern int first,lno;
extern int charcount;
extern int fflag,dd;
struct node{
	vector<string>type, datatype, token;
	vector<int>lineno;
	vector<int>dim;
	vector<int>position;
	vector<node*>next;
	node *parent;
	string name;
	int no_of__block_s;
	int first;
	int func_def_flag;
};
node *head = new node();
node *temp = head;
void checkReturn(int flag){
	int i=0;
	while(head->next[i]){
		if(head->next[i]->name==temp->name)
			break;
		++i;
	}
	if(head->datatype[i]=="void"){
		if(flag) return;
		cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: return type mismatch\n";
	}
	else{
		if(!flag) return;
		cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: return type mismatch\n";
	}	
}
void checkDim(){
	for(int i=0;i<fargs.size();++i){
		if(fargs[i][0]=='-'){
			cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: size of array is negative \n";
			cout << lines[lineno-1]; 
		}
	}
}
void prtformat(node *temp,int level){
  	for(int i=0;i<temp->token.size();++i){
    	string fff="-";
    	if(temp->token[i]=="function")
    		fff = "1";
    	if(temp->token[i]=="_block_")
    		fff = "null";
    	if(temp->token[i]=="_block_")
    		cout <<"\t" << temp->token[i] << "\t\t" << temp->type[i] << "\t\t" <<  temp->datatype[i] << "\t\t" << temp->dim[i]  << "\t\t" << fff << "\t\t" << level << endl;
  		else
  			cout <<"\t" << temp->token[i] << "\t" << temp->type[i] << "\t\t" <<  temp->datatype[i] << "\t\t" << temp->dim[i]  << "\t\t" << fff << "\t\t" << level << endl;

  	}
	int j=0;
	for(int i=0;i<temp->token.size();++i){
    	if(temp->token[i]=="function" || temp->token[i]=="_block_"){
    		prtformat(temp->next[j++],level+1);
    	}
    }
}
void printformat(node *temp){
	cout << "\n\n\t\tGLOBAL\n\n";
	cout << "\t------------------------------------------------------------------------------------------\n";
   	cout << "\tType\t        Name  		Datatype   	Dimension	flag 	nesting level\n";
   	cout << "\t------------------------------------------------------------------------------------------\n";
	prtformat(temp,0);
}

void prt(node *temp){
	cout << "\t---------------------------------------------\n";
   	cout << "\tToken\t        Type  	Datatype   line\n";
   	cout << "\t---------------------------------------------\n";
  	for(int i=0;i<temp->token.size();++i){
    	cout << "\t" << temp->token[i] << "\t" << temp->type[i] << "\t" << setw(5) << temp->datatype[i] << "\t" << setw(5) << temp->lineno[i] << endl;
  	}
  	cout << "\t---------------------------------------------\n";
	
	int j=0;
	for(int i=0;i<temp->token.size();++i){
    	if(temp->token[i]=="function" || temp->token[i]=="_block_"){
    		cout << "\n\n\t\t" << temp->type[i]<< "\n\n";
    		prt(temp->next[j++]);
    	}
    }
}
void print(node *temp){
	cout << "\n\n\t\tGLOBAL\n\n";
	prt(temp);
}
void paramcheck(){
	int k=0;
	node *temp = head;
	for(int i=0;i<head->token.size();++i){
		if(head->token[i]=="function"){
			temp = head->next[k++];
			if(head->type[i]==fname){
				break;
			}
		}
	}
	--k;
	if(!temp){
		cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: undefined reference to '"<< fname << "'\n";return;
	}
	int i;

	for(i=0;i<temp->token.size();++i){
		if(temp->token[i]=="argument"){
			cout << temp->type[i] <<"arg\n";
			if(i==fargs.size()){
				cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: too few arguments to function '"<< fname << "'\n " << lines[lineno-1] << endl;
				fargs.clear();
				return;
			}
		}
		else
			break;
	}
	if(i==fargs.size()){	fargs.clear();return;}
	
	cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: too many arguments to function '"<< fname << "'\n " << lines[lineno-1] << endl;
	fargs.clear();
}
void placePoint(int position){
	for(int i=1;i<position;++i){
		cout << " ";
	}
	cout << "^" << endl;
}

bool search(node *temp, string token, string type, string datatype,int position){
	int flag=0;
	for(int i=0;i<temp->token.size();++i){
		if(fflag && temp->type[i]==type && temp->token[i]==token){
			cout << filename << "::" << lineno  << ":" << (position-1) << ":" << "error: conflicting types for '"<< temp->type[i] << "'\n " << lines[lno-1] << endl;
			cout << filename << "::" << temp->lineno[i]  << ":" << temp->position[i] << ":" << "note: previous definition of '" << temp->type[i] << "' was here\n " << lines[i+1] << endl;
			flag=1;
			return true;
		}
		if(temp->type[i]==type && temp->token[i]==token && temp->datatype[i]!=datatype){
			cout << filename << ":" << lineno  << ":" << (position-1) << ":" << "error: conflicting types for '"<< temp->type[i] << "'\n " << lines[lineno-1] << endl;
			cout << filename << ":" << (i+1)  << ":" << temp->position[i] << ":" << "note: previous definition of '" << temp->type[i] << "' was here\n " << lines[i+2] << endl;
			flag=1;
		}
		if(temp->type[i]==type && temp->token[i]==token && temp->datatype[i]==datatype){
			if(token=="function"){
				int k=0;
				node *temp2 = head->next[k++];
				while(temp2->name!=type){temp2=head->next[k++];}
				if(temp2->func_def_flag==1){
					::temp = temp2;
				}
				return true;
			}
			cout << filename << ":" << lineno  << ":" << (position-1) << ":" << "error: redeclaration of '"<< temp->type[i] << "' with no linkage\n " << lines[lineno-1] << endl;
			cout << filename << ":" << (i+1)  << ":" << temp->position[i] << ":" << "note: previous declaration of '" << temp->type[i] << "' was here\n " << lines[i+2] << endl;
			flag=1;
		}
		if(temp->type[i]==type && temp->token[i]!=token){
			cout << filename << ":" << lineno << ":" << (position-1) << ":" << "error: '" << temp->type[i] << "' redeclared as different kind of symbol\n " << lines[lineno-1] << endl;
			cout << filename << ":" << (i+1) << ":" << temp->position[i] << ":" << "note: previous definition of '"<< temp->type[i] << "' was here\n " << lines[i+2] << endl;
			flag=1;
		}
		if(flag) return true;
	}
	return false;
}
void insVar(string token, string datatype, string type, int lineno, int position, bool isfunc=false){
	if(isfunc==true){
		if(token=="_block_"){
			stringstream ss;
			temp->no_of__block_s++;
			ss << temp->no_of__block_s;
			string str = ss.str();
			node *ptr = new node();
			temp->next.push_back(new node());
			temp->token.push_back(token);
			temp->dim.push_back(-1);
			temp->lineno.push_back(lineno);
			temp->type.push_back(temp->name + "." + str);
			temp->position.push_back(position);
			temp->datatype.push_back(datatype);
			temp->next.back()->parent = temp;
			temp = temp->next.back();
			temp->no_of__block_s=0;
			temp->name = temp->parent->name + "." + str;	
			temp->first=2;
			return;
		}
		if(search(head,token,type,datatype,position))
			return;

		node *ptr = new node();
		head->next.push_back(new node());
		head->token.push_back(token);
		temp->dim.push_back(-1);
		head->lineno.push_back(lineno);
		head->type.push_back(type);
		head->no_of__block_s=0;
		head->position.push_back(position);
		head->datatype.push_back(datatype);
		head->next.back()->parent = head;
		temp = head->next.back();
		temp->name = type;
		temp->first=1;
	}
	else{
		if(search(temp,token,type,datatype,position))
			return;
		temp->token.push_back(token);
		temp->type.push_back(type);
		temp->dim.push_back(dd);
		temp->lineno.push_back(lineno);
		temp->position.push_back(position);
		temp->datatype.push_back(datatype);
	}	
}
void scope(node *temp,string type, int position){
	if(temp==NULL){
		if(func!=""){
			cout << filename << ": In function '" << func << "' :\n";  
			cout << filename << ":" << lineno  << ":" << (position-1) << ":" << "error: '" << type << "' undeclared (first use of this function)\n " << lines[lineno-1] << endl;
			placePoint(position);
			cout << filename << ":" << lineno  << ":" << (position-1) << ":" << "note: each undeclared identifier is reported only once for each function it appears in\n";
			insVar("    NULL","NULL",type,lineno,position);
		}
		else{
			cout << filename << ":" << lineno  << ":" << (position-1) << ":" << "warning: data definition has no type or storage class \n " << lines[lineno-1] << endl;
			placePoint(position);
			insVar("    NULL","NULL",type,lineno,position);
		}
		return;
	}
	for(int i=0;i<temp->token.size();++i){
		if(temp->type[i]==type && temp->token[i]=="variable"){
			return;
		}
	}
	scope(temp->parent,type,position);
}
