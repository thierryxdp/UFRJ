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
vector<string> funcoes;

int linha = 1;
int coluna = 1;

%}

%token NUM ID LET STRING IF ELSE WHILE FOR MAIOR_IGUAL MENOR_IGUAL IGUAL DIF
%token SETA FUNCTION RETURN

%right '=' SETA
%nonassoc '<' '>' _IGUAL MAIOR_IGUAL MENOR_IGUAL DIF
%left '+' '-'
%left '*' '/' '%'
%right '^'

// Start indica o símbolo inicial da gramática
%start S

%%

S : CMDs { $$.c = $1.c + "." + funcoes; imprime( resolve_enderecos($$.c) ); }
  ;

CMDs : CMD CMDs   { $$.c = $1.c + $2.c; }
     | CMD 
     ;
 
CMD : ATRIB   ';'                        { $$.c = $1.c + "^"; }
    | CMD_LET ';'
    | IF '(' E ')' CMD                   { string endif = gera_label("end_if");
                                           $$.c = $3.c + "!" + endif + "?" + $5.c + (":" + endif); }                
    | FUNCTION ID '('')' CMD             { string func_endereco = gera_label( "funcao" ); 
                                           $$.c = $2.c + "&" + $2.c + "{}" + "=" + "\'&funcao\'" + func_endereco + "[=]" + "^"; 
                                           funcoes = funcoes + (":" + func_endereco) + $5.c; funcoes = funcoes + "undefined" + "@" + "\'&retorno\'" + "@" + "~"; }
    | FUNCTION ID '(' PARAMETERS ')' CMD 
    | RETURN E ';'                       { $$.c = $2.c + "\'&retorno\'" + "@" + "~"; }                               
    | BLOCO
    ;

PARAMETERS : ID ',' PARAMETERS {$$.c = $1.c + $3.c; }
           | ID
           ; 
           
CMD_LET :  LET DECLARACOES     { $$.c = $2.c; }
                 ;

BLOCO : '{' CMDs '}'          { $$.c = $2.c; }
      | BLOCOVAZIO
      ;

DECLARACOES: DECLARACAO ',' DECLARACOES  { $$.c = $1.c + $3.c; }
           | DECLARACAO
           ;

DECLARACAO : ID '=' E   { $$.c = $1.c + "&" + $1.c + $3.c + "=" + "^"; }
           | ID         { $$.c = $1.c + "&"; }
           |            { $$.c = novo + ""; }
           ;

ATRIB : LVALUEPROP '=' ATRIB    { $$.c = $1.c + $3.c + "[=]"; }
      | LVALUE '=' ATRIB        { $$.c = $1.c + $3.c + "="; }
      | E                       { $$.c = $1.c; }
      ;


LVALUE : ID   { $$.c = $1.c; }
       ;

LVALUEPROP : ATRIBUTOS  
           ;


ATRIBUTOS : '[' E ']' ATRIBUTOS       { $$.c = novo + "[@]" + $2.c + $4.c; }
          | '.' ID ATRIBUTOS          { $$.c = novo + "[@]" + $2.c + $3.c; }
          |  '[' E ']'   
          | '.' ID                       
          ;

E : E '^' E             { $$.c = $1.c + $3.c + "^"; }
  | E '<' E             { $$.c = $1.c + $3.c + "<"; }
  | E '>' E             { $$.c = $1.c + $3.c + ">"; }
  | E MAIOR_IGUAL E     { $$.c = $1.c + $3.c + ">="; }
  | E DIF E             { $$.c = $1.c + $3.c + "!="; }
  | E MENOR_IGUAL E     { $$.c = $1.c + $3.c + "<="; }
  | E '*' E             { $$.c = $1.c + $3.c + "*"; }
  | E '+' E             { $$.c = $1.c + $3.c + "+"; }
  | E '-' E             { $$.c = $1.c + $3.c + "-"; } 
  | E '/' E             { $$.c = $1.c + $3.c + "/"; }
  | E '%' E             { $$.c = $1.c + $3.c + "%"; }
  | F
  ;



F : LVALUE          { $$.c = $1.c + "@"; }
  | LVALUEPROP      { $$.c = $1.c + "[@]"; }
  | NUM             { $$.c = $1.c; }
  | STRING          { $$.c = $1.c; }
  | BLOCOVAZIO      { $$.c = novo + "{}"; }
  | '['']'          { $$.c = novo + "[]"; }
  | '(' E ')'       { $$ = $2; }
  | ID '('')'       { $$.c = novo + "0" + $1.c + "@" + "$"; }
  ;

BLOCOVAZIO : '{' '}' 
           ;


%%

#include "lex.yy.c"


void imprime( vector<string> codigo ){
  for (int i = 0; i < codigo.size(); i++)
    cout << codigo[i] << endl;
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
