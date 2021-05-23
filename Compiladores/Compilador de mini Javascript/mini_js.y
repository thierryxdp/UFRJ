%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <map>

using namespace std;

struct Atributos {
  vector<string> c;
};

#define YYSTYPE Atributos

int yylex();
int yyparse();
void yyerror(const char *);

vector<string> concatena( vector<string> a, vector<string> b ); 
vector<string> operator+( vector<string> a, vector<string> b );
vector<string> operator+( vector<string> a, string b );

string pega_string ( vector<string> a );
string gera_label( string prefixo );
vector<string> resolve_enderecos( vector<string> entrada );
void imprime( vector<string> codigo );

vector<string> novo;

map<string, int> variaveis;

int linha = 1;
int coluna = 1;

%}

%token NUM ID LET STR IF ELSE WHILE FOR


// Start indica o símbolo inicial da gramática
%start S

%%

S : CMDs { imprime(resolve_enderecos($1.c)); }
  ;

CMDs : CMD ';' CMDs   { $$.c = $1.c + $3.c; }
     | DECLIF CMDs    { $$.c = $1.c + $2.c; }
     | DECLWHILE CMDs { $$.c = $1.c + $2.c; }
     | DECLFOR CMDs   { $$.c = $1.c + $2.c; }
     |                { $$.c = novo; }
     ;

CMD : ATR              { $$.c = $1.c + "^"; }
    | LET DECLVARs     { $$ = $2; }
    | DECLOBJ          { $$.c = $1.c; }
    ;
    
DECLIF : IF '(' R ')' CMD ';'                   { string endif = gera_label( "end_if" );
                                                  $$.c = $3.c + "!" + endif + "?" + $5.c + (":" +  endif); }
       | IF '(' R ')' '{' CMDs '}' ELSE CMD ';' { string then = gera_label ( "then" );
                                                  string endif = gera_label ( "end_if" );
                                                  $$.c = $3.c + then + "?" + $9.c + endif + "#" + (":" + then) + $6.c + (":" + endif); }
       | IF '(' R ')' CMD ';' ELSE CMDs         { string then = gera_label ( "then" );
                                                  string endif = gera_label ( "end_if" );
                                                  $$.c = $3.c + then + "?" + $8.c + endif + "#" + (":" + then) + $5.c + (":" + endif); }
       ;

DECLWHILE : WHILE '(' R ')' '{' CMDs '}' { string endwhile = gera_label( "end_while" );
                                           string beginwhile = gera_label( "begin_while" );
                                           $$.c = novo + (":" + beginwhile) + $3.c + "!" + endwhile + "?" + $6.c + $3.c + beginwhile + "?" + (":" + endwhile);}
          ;
          
DECLFOR : FOR '(' LET DECLVAR ';' R ';' ATR ')' '{' CMDs '}'  { string endfor = gera_label( "end_for" );
                                                                string beginfor = gera_label( "begin_for" );
                                                                $$.c = $4.c + (":" + beginfor) + $6.c + "!" + endfor + "?" 
                                                                + $11.c + $8.c + "^" + $6.c + beginfor + "?" + (":" + endfor); }         
        | FOR '(' ATR ';' R ';' ATR ')' '{' CMDs '}'          { string endfor = gera_label( "end_for" );
                                                                string beginfor = gera_label( "begin_for" );
                                                                $$.c = $3.c + "^" + (":" + beginfor) + $5.c + "!" + endfor + "?" 
                                                                + $10.c + $7.c + "^" + $5.c + beginfor + "?" + (":" + endfor);}                                                                
        ;
 
        
DECLVARs : DECLVAR ',' DECLVARs { $$.c = $1.c + $3.c; }
         | DECLVAR              { $$.c = $1.c; }
         ;
         
DECLVAR : ID '=' R                              { $$.c = $1.c + "&" + $1.c + $3.c + "=" + "^";
                                                  string var = pega_string($1.c);
                                                  if (variaveis.find(var) != variaveis.end()) {
                                                    cerr << "Erro: a variável \'" << var << "\' já foi declarada na linha " << variaveis[var] << "." << endl;
                                                    exit( 1 );
                                                  }
                                                  variaveis.insert({var, linha}); }
        | ID                                    { $$.c = $1.c + "&"; 
                                                  string var = pega_string($1.c);
                                                  if (variaveis.find(var) != variaveis.end()) {
                                                    cerr << "Erro: a variável \'" << var << "\' já foi declarada na linha " << variaveis[var] << "." << endl;
                                                    exit( 1 );
                                                  }
                                                  variaveis.insert({var, linha}); }
        ;
        
DECLOBJ : ID '.' ID '=' R                       { $$.c = $1.c + "@" + $3.c + $5.c + "[=]" + "^"; }
        | ID '.' ID '[' E ']' '=' R             { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c + $8.c + "[=]" + "^"; }
        | ID '[' E ']' '=' ID '.' ID '+' R      { $$.c = $1.c + "@" + $3.c + $6.c + "@" + $8.c + "[@]" + $10.c + "+" + "[=]" + "^"; }
        | ID '[' E ']' '=' R                    { $$.c = $1.c + "@" + $3.c + $6.c + "[=]" + "^"; }
        | ID '[' ID ']' '=' R                   { $$.c = $1.c + "@" + $3.c + "@" + $6.c + "[=]" + "^"; }
        | ID '[' ATR ']' '=' R                  { $$.c = $1.c + "@" + $3.c + $6.c + "[=]" + "^"; }
        ;




         
ATR : ID '=' ATR { string var = pega_string($1.c);
                   if (variaveis.find(var) == variaveis.end()) {
                     cerr << "Erro: a variável \'" << var << "\' não foi declarada." << endl;
                     exit( 1 );
                   }
                   $$.c = $1.c + $3.c + "="; }
    | R
    ;

R : E '<' E      { $$.c = $1.c + $3.c + "<"; }
  | E '>' E      { $$.c = $1.c + $3.c + ">"; }
  | E '>' '=' E  { $$.c = $1.c + $4.c + ">="; }
  | E '<' '=' E  { $$.c = $1.c + $4.c + "<="; }
  | E '=' '=' E  { $$.c = $1.c + $4.c + "=="; }
  | E
  ;
  
E : E '+' T { $$.c = $1.c + $3.c + "+"; }
  | E '-' T { $$.c = $1.c + $3.c + "-"; }
  | '-' E   { $$.c = novo + "0" + $2.c + "-"; }
  | T
  ;

T : T '*' F { $$.c = $1.c + $3.c + "*"; }
  | T '/' F { $$.c = $1.c + $3.c + "/"; }
  | F

F : ID          { $$.c = $1.c + "@"; }
  | NUM         { $$.c = $1.c; }
  | STR         { $$.c = $1.c; }
  | '(' E ')'   { $$.c = $2.c; }
  | '{' '}'     { $$.c = novo + "{}"; }
  | '[' ']'     { $$.c = novo + "[]"; }
  ;



%%

#include "lex.yy.c"


void imprime( vector<string> codigo ){
  for (int i = 0; i < codigo.size(); i++)
    cout << codigo[i] << endl;
  
  cout << "." << endl;
}

vector<string> concatena( vector<string> a, vector<string> b ) {
  for(int i = 0; i < b.size(); i++ )
    a.push_back( b[i] );
  return a;
}

vector<string> operator+( vector<string> a, vector<string> b ) {
  return concatena( a, b );
}

vector<string> operator+( vector<string> a, string b ) {
  a.push_back( b );
  return a;
}

string pega_string ( vector<string> a ) {
  string retorno = "";
  retorno = retorno + a[0];
  return retorno;
}


string gera_label( string prefixo ) {
  static int n = 0;
  return prefixo + "_" + to_string( ++n ) + ":";
}

vector<string> resolve_enderecos( vector<string> entrada ) {
  map<string,int> label;
  vector<string> saida;
  for( int i = 0; i < entrada.size(); i++ ) 
    if( entrada[i][0] == ':' ) 
        label[entrada[i].substr(1)] = saida.size();
    else
      saida.push_back( entrada[i] );
  
  for( int i = 0; i < saida.size(); i++ ) 
    if( label.count( saida[i] ) > 0 )
        saida[i] = to_string(label[saida[i]]);
    
  return saida;
}

void yyerror( const char* st ) {
   puts( st ); 
   printf( "Proximo a: %s\n", yytext );
   exit( 1 );
}

int main( int argc, char* argv[] ) {
  yyparse();
  
  return 0;
}
