%{
#include <iostream>
#include <map>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;  
  
int token;
int linha = 1, coluna_atual = 1, coluna_anterior = 0;

void A();
void E();
void T();
void F();
void T_linha();
void E_linha();
void casa( int );

enum { tk_id = 256, tk_num, tk_float, tk_string, tk_print, tk_func};

vector<string> func;

map<int,string> nome_tokens = {
  { tk_id, "nome de identificador" },
  { tk_num, "constante inteira" },
  { tk_float, "número real" },
  { tk_string, "string" },
  { tk_print, "função print" },
  { tk_func, "funcão qualquer" }
};

int tk( int token );

%}

DIGITO	[0-9]
LETRA	[A-Za-z_]

NUM	{DIGITO}+
ID	{LETRA}({LETRA}|{DIGITO})*
FLOAT 	{NUM}(\.{NUM})?([Ee][+\-]?{NUM})?

STRING ["]([^\\"\n]|[\\]["]|["]["]|[\\][^"])*["]


%%

" "  		{ coluna_anterior = coluna_atual++; }
"\t"		{ coluna_anterior = coluna_atual; 
                  coluna_atual += 2; }
"\n"            { linha++; 
                  coluna_anterior = coluna_atual;
                  coluna_atual = 1; }
{NUM} 		{ return tk( tk_num ); }
{FLOAT}	{ return tk( tk_float ); }
{STRING} 	{ return tk( tk_string ); }
"print"	{ return tk( tk_print ); }
{ID}		{ return tk( tk_id ); }

.		{ return tk( yytext[0] ); }

%%

/*

A -> id { Print( id ); } = E ; { Print( "="); }
   | print E ; 
E -> T E'
E' -> + T { Print( "+"); } E'
    | - T { Print( "-"); } E'
    | ε
T -> F T'
T' -> * F { Print( "*"); } T'
    | / F { Print( "/"); } T'
    | ε
F -> id { Print(id + "@"); }
   | num { Print( num ); }
   | ( E )
   | float { Print( float ); }
   | string { Print( string ); }
   | id( E )
   
*/

int tk( int token ) {
  coluna_anterior = coluna_atual;
  coluna_atual += strlen( yytext ); 
  return token;
}

int next_token() {
  return yylex();
}

void erro( string msg ) {
  cout << "*** Erro: ***" << endl
       << "Linha: " << linha << ", coluna: " << coluna_anterior << endl
       << msg << endl;
  exit( 1 );
}

string nome_token( int token ) {
  if( nome_tokens.find( token ) != nome_tokens.end() )
    return nome_tokens[token];
  else {
    string r;
    r = (char) token;
    
    return "'" + r + "'";
  }
}

void A(){
  switch (token){
    case tk_id: {
      string temp = yytext;
      casa(tk_id);
      cout << temp << " ";
      casa('=');
      E();
      casa(';');
      cout << "= "; }
      break;
    case tk_print: {
      string temp = yytext;
      casa(tk_print);
      E();
      casa(';');
      cout << temp << " # "; }
      break;
  }
}

void E(){
   T();
   E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); cout << "+ "; E_linha(); break;
    case '-' : casa( '-' ); T(); cout << "- "; E_linha(); break;
  }
}

void T() {
  F();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' : casa( '*' ); F(); cout << "* "; T_linha(); break;
    case '/' : casa( '/' ); F(); cout << "/ "; T_linha(); break;
  }
}

void F() {
  switch( token ) {
    case tk_id : {
      string temp = yytext;  
      casa( tk_id );
      if (token == '('){
        casa( '(' );
        while (token != ')'){
      	  E();
      	  if (token == ',') casa ( ',' );
      	 }
      	 casa (')');
      	 cout << temp << " # ";
      } else cout << temp << " " << "@ "; } 
      break;
    case tk_num : {
      string temp = yytext;
      casa( tk_num ); cout << temp << " "; }
      break;
     case tk_float : {
       string temp = yytext;
       casa ( tk_float ); cout << temp << " "; }
       break;
     case tk_string : {
     	string temp = yytext;
     	casa ( tk_string ); cout << temp << " "; }
     	break;
    case '(': 
      casa( '(' ); E(); casa (')'); break;
    default:
      string msg = yytext;
      erro(msg);
  }
}


void casa( int esperado ) {
  if( token == esperado )
    token = next_token();
  else 
    erro( "Esperado " + nome_token( esperado ) +
	  ", encontrado: " + nome_token( token ) );
}

auto f = &yyunput;

int main() {
  func.push_back("max");
  func.push_back("dtos");

  token = next_token();
  while( token != 0 )
    A();
  
  return 0;
}
