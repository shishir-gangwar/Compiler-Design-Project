#include<bits/stdc++.h>
using namespace std;
extern vector<string>lines,fargs;
extern string filename,fname;
extern string func;
string last;
extern int lineno;
extern int first,lno;
extern int charcount;
extern int fflag,dd;

template <typename T>
string to_string(T val)
{
    stringstream stream;
    stream << val;
    return stream.str();
}
struct val{
	string data;
	val *left,*right;
};

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
node *temp2;
node *head = new node();
node *temp = head;
vector<string>ans;
vector<string>commands;
void bfs(val *x){
	if(x==NULL) return;
	bfs(x->left);
	bfs(x->right);
	cout << x->data;
	ans.push_back(x->data);
}
string arr_op[] = {"+","-","*","/","||","&&",">=","<=","<<",">>","!=","==",">","<","="};
bool is_operator(string a){
	for(int i=0;i<15;++i){
		if(a==arr_op[i])
			return true;
	}
	return false;
}
int j=0;
int ifk=0;
void tac_if(int x){
	if(x){
		string label = "_L"+to_string(ifk);
		string cc = "IfZ "+last+" Goto "+ label+";";
		commands.push_back(cc);
	}
	else{
		string label = "_L"+to_string(ifk);
		string cc =  "Goto "+label+";";
	//	commands.push_back(cc);
		label = "_L"+to_string(ifk-1);
		cc =  label+":";
		commands.push_back(cc);
	}
	++ifk;
}
void tac_ret(){
	vector<string>a;
	
	for(int i=0;i<ans.size();++i){
		a.push_back(ans[i]);
		if(is_operator(a.back())){
			if(a.back()=="="){
				string op = a.back();a.pop_back();
		  		string x = a.back();a.pop_back();
		  		string y = a.back();a.pop_back();	
				string cc = y +" "+ op +" "+ x +";";
				a.push_back(y);
				commands.push_back(cc);
				continue;
			}
			// cout << a.back() << " ";
		 	string op = a.back();a.pop_back();
		  	string x = a.back();a.pop_back();
		  	string y = a.back();a.pop_back();
		  	if((x[0]=='_' && y[0]!='_')||(x[0]!='_' && y[0]=='_')){
		  		if(x[0]!='_'){
		  			string t = "_t" + to_string(j);
		//  			cout << t << " ";
		  			string cc = t + " = " + x +";"; 
		  			commands.push_back(cc);
		  			x = t;
		  			++j;
		  		}
		  		if(y[0]!='_'){
		  			string t = "_t" + to_string(j);
		//  			cout << t << " ";
		  			string cc = t + " = " + y +";"; 
		  			commands.push_back(cc);
		  			y = t;
		  			++j;
		  		}	
		  	}
		  	string t = "_t" + to_string(j);
	//	  	cout << t << " ";
		  	a.push_back(t);
		 	string cc = t + " = " + y +" "+ op +" "+ x +";"; 
		  	commands.push_back(cc);
		  	last = t;
		  	++j;
		}
	}
	if(a.size()){
		string cc = a.back();
		cc = "_ra = " + cc +";"; 
		commands.push_back(cc);
	}
	ans.clear();
	cout << endl;
}
void tac_call(string s,int x=1,int fl=0){
	if(x){
		string t = "_t" + to_string(j);
		string cc = t + " = " + s + ";";
		commands.push_back(cc);
		cc = "PushParam "+t+";";
		commands.push_back(cc);
		++j;
	}
	else{
		string cc = "LCall " + s+";";
		commands.push_back(cc);
		int k1=j-1;
		if(fl){
			for(int i=0;(i<temp2->token.size() && temp2->token[i]=="argument");++i){
				cc = "PopParam _t" + to_string(k1)+";";
				commands.push_back(cc);
				k1--;
			}
		}
	}
}
int tac_while(int x,int val=0){
	if(x==1){
		string label = "_L"+to_string(ifk);
		string cc = label+":";
		commands.push_back(cc);
		++ifk;
		return (ifk-1);
	}
	else if(x==2){
		string label = "_L"+to_string(ifk);
		string cc = "IfZ "+last+" Goto "+ label+";";
		commands.push_back(cc);
		++ifk;
	}
	else{
		string label = "_L"+to_string(val);
		string cc =  "Goto "+label+";";
		commands.push_back(cc);
		label = "_L"+to_string(ifk-1);
		cc =  label+":";
		commands.push_back(cc);
	}
}
void tac_func(string func,int beg=1){
	if(beg){
		string cc = func + ":";
		commands.push_back(cc);
		cc = "beginFunc ;";
		commands.push_back(cc);
	}
	else{
		string cc = "endFunc ;";
		commands.push_back(cc);	
	}
}
void tac_exp(){
	vector<string>a;
	
	for(int i=0;i<ans.size();++i){
		a.push_back(ans[i]);
		if(is_operator(a.back())){
			if(a.back()=="="){
				string op = a.back();a.pop_back();
		  		string x = a.back();a.pop_back();
		  		string y = a.back();a.pop_back();	
				string cc = y +" "+ op +" "+ x +";";
				a.push_back(y);
				commands.push_back(cc);
				continue;
			}
			// cout << a.back() << " ";
		 	string op = a.back();a.pop_back();
		  	string x = a.back();a.pop_back();
		  	string y = a.back();a.pop_back();
		  	if((x[0]=='_' && y[0]!='_')||(x[0]!='_' && y[0]=='_')){
		  		if(x[0]!='_'){
		  			string t = "_t" + to_string(j);
		//  			cout << t << " ";
		  			string cc = t + " = " + x +";"; 
		  			commands.push_back(cc);
		  			x = t;
		  			++j;
		  		}
		  		if(y[0]!='_'){
		  			string t = "_t" + to_string(j);
		//  			cout << t << " ";
		  			string cc = t + " = " + y +";"; 
		  			commands.push_back(cc);
		  			y = t;
		  			++j;
		  		}	
		  	}
		  	string t = "_t" + to_string(j);
	//	  	cout << t << " ";
		  	a.push_back(t);
		 	string cc = t + " = " + y +" "+ op +" "+ x +";"; 
		  	commands.push_back(cc);
		  	last = t;
		  	++j;
		}
	}
	ans.clear();
	cout << endl;
}
void print_tac(){
	cout << "\n___________________________________________";
	cout << "\n_____T_H_R_E_E__A_D_D_R_E_S_S__C_O_D_E_____\n";
	for(int i=0;i<commands.size();++i){
		reverse(commands[i].begin(),commands[i].end());
		char tt1 = *commands[i].begin();
		reverse(commands[i].begin(),commands[i].end());
		if(tt1==':')
			cout << commands[i] << endl;
		else
			cout << "\t" << commands[i] << endl;
	}
	cout << "_____________________________________________\n\n";
//	commands.clear();
}
val *mknode(val *l,string parent,val *r){
	val *p = new val();
	p->data = parent;
	p->left = l;
	p->right = r;
	return p;
}
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
int paramcheck(){
	int k=0;
	temp2 = head;
	for(int i=0;i<head->token.size();++i){
		if(head->token[i]=="function"){
			temp2 = head->next[k++];
			if(head->type[i]==fname){
				break;
			}
		}
	}
	--k;
	if(!temp){
		cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: undefined reference to '"<< fname << "'\n";return 0;
	}
	int i;

	for(i=0;i<temp2->token.size();++i){
		if(temp2->token[i]=="argument"){
			cout << temp2->type[i] <<"arg\n";
			if(i==fargs.size()){
				cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: too few arguments to function '"<< fname << "'\n " << lines[lineno-1] << endl;
				fargs.clear();
				return 0;
			}
		}
		else
			break;
	}
	if(i==fargs.size()){	fargs.clear();return 1;}
	
	cout << filename << ":" << lineno  << ":" << charcount << ":" << "error: too many arguments to function '"<< fname << "'\n " << lines[lineno-1] << endl;
	fargs.clear();
	return 0;
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
		//	cout << filename << ":" << (i+1) << ":" << temp->position[i] << ":" << "note: previous definition of '"<< temp->type[i] << "' was here\n " << lines[i+2] << endl;
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
	for(int i=0;i<head->token.size();++i){
		if(head->type[i]==type && head->token[i]=="variable"){
			return;
		}
		if(head->type[i]==type && head->token[i]=="argument"){
			return;
		}
	}
	for(int i=0;i<temp->token.size();++i){
		if(temp->type[i]==type && temp->token[i]=="variable"){
			return;
		}
		if(temp->type[i]==type && temp->token[i]=="argument"){
			return;
		}
	}
	scope(temp->parent,type,position);
}
