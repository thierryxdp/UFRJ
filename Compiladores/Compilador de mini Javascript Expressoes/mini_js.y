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

string trim (string original, string remove);
vector<string> tokeniza(string original);

vector<string> novo;
vector<string> funcoes;

int linha = 1;
int coluna = 1;

int contador_parametros = 0;
int contador_argumentos = 0;
%}

%token NUM ID LET STRING IF ELSE WHILE FOR MAIOR_IGUAL MENOR_IGUAL IGUAL DIF
%token SETA FUNCTION RETURN ASM TRUE FALSE

%right '=' SETA
%nonassoc '<' '>' IGUAL MAIOR_IGUAL MENOR_IGUAL DIF
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
    | E ASM ';'                          { $$.c = $1.c + $2.c + "^"; }
    | IF '(' E ')' CMD                   { string endif = gera_label("end_if");
                                           $$.c = $3.c + "!" + endif + "?" + $5.c + (":" + endif); } 
    | IF '(' E ')' CMD ELSE CMD          { string then = gera_label ( "then" );
                                           string endif = gera_label ( "end_if" );
                                           $$.c = $3.c + then + "?" + $7.c + endif + "#" + (":" + then) + $5.c + (":" + endif); }                                                          
    | FUNCTION ID '('')' CMD             { string func_endereco = gera_label( "funcao" ); 
                                           $$.c = $2.c + "&" + $2.c + "{}" + "=" + "\'&funcao\'" + func_endereco + "[=]" + "^"; 
                                           funcoes = funcoes + (":" + func_endereco) + $5.c; funcoes = funcoes + "undefined" + "@" + "\'&retorno\'" + "@" + "~"; }
    | FUNCTION ID '(' PARAMETERS ')' CMD { string func_endereco = gera_label( "funcao" ); 
                                           $$.c = $2.c + "&" + $2.c + "{}" + "=" + "\'&funcao\'" + func_endereco + "[=]" + "^"; 
                                           funcoes = funcoes + (":" + func_endereco); funcoes = funcoes + $4.c; contador_parametros = 0;
                                           funcoes = funcoes + $6.c; funcoes = funcoes + "undefined" + "@" + "\'&retorno\'" + "@" + "~"; }
    | RETURN E ';'                       { $$.c = $2.c + "\'&retorno\'" + "@" + "~"; }
    | FOR '(' ATRIB ';' E ';' ATRIB ')' CMD          { string endfor = gera_label( "end_for" );
                                                       string beginfor = gera_label( "begin_for" );
                                                       $$.c = $3.c + "^" + (":" + beginfor) + $5.c + "!" + endfor + "?" 
                                                       + $9.c + $7.c + "^" + $5.c + beginfor + "?" + (":" + endfor);}                               
    | BLOCO
    ;

PARAMETERS : PARAMETERS ',' ID { $$.c = $1.c + $3.c + "&" + $3.c + "arguments" + "@" + to_string(contador_parametros) + "[@]" + "=" + "^"; contador_parametros += 1; }
           | ID                { $$.c = $1.c + "&" + $1.c + "arguments" + "@" + to_string(contador_parametros) + "[@]" + "=" + "^"; contador_parametros += 1; }
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
           | ID '=' FUNCTION '(' PARAMETERS ')' CMD    { string func_endereco = gera_label( "funcao" ); 
                                                         $$.c = $1.c + "&" + $1.c + "{}" + "\'&funcao\'" + func_endereco + "[<=]" + "=" + "^"; 
                                                         funcoes = funcoes + (":" + func_endereco); funcoes = funcoes + $5.c; contador_parametros = 0;
                                                         funcoes = funcoes + $7.c; funcoes = funcoes + "undefined" + "@" + "\'&retorno\'" + "@" + "~"; }
           ;

ATRIB : LVALUEPROP '=' ATRIB    { $$.c = $1.c + $3.c + "[=]"; }
      | ID '=' ATRIB            { $$.c = $1.c + $3.c + "="; }
      | F                       { $$.c = $1.c; }
      ;



LVALUEPROP : ATRIBUTOS     { $$.c = $1.c; }
           ;

RVALUE : ID '[' E ']'                 { $$.c = $1.c + "@" + $3.c + "[@]"; }
       | ID '.' ID                    { $$.c = $1.c + "@" + $3.c + "[@]"; }
       | ID '.' ID '[' E ']'          { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c + "[@]"; }          
       | ID '.' ID '.' ID             { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c; }
       | ID '.' ID '.' ID '[' E ']'   { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c + "[@]" + $7.c; }
       | ID '.' ID '[' E ']' '.' ID   { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c + "[@]" + $8.c + "[@]"; }                  
       | ID '.' ID '('')'             { $$.c = novo + "0" + $1.c + "@" + $3.c + "[@]" + "$"; }
       | ID '.' ID '(' VALORES ')'    { $$.c = $5.c + to_string(contador_parametros) + $1.c + "@" + $3.c + "[@]" + "$"; contador_parametros = 0; }
          
       | ID '.' ID '[' E ']' '(' VALORES ')'    { $$.c = $8.c + to_string(contador_parametros) + $1.c + "@" + $3.c + "[@]" + $5.c + "[@]" + "$"; 
                                                     contador_parametros = 0; }
       | ID '[' E ']' '(' VALORES ')'           { $$.c = $6.c + to_string(contador_parametros) + $1.c + "@" + $3.c + "[@]" + "$"; 
                                                     contador_parametros = 0; }
          
       | ID '.' ID '.' ID '[' E ']' '(' VALORES ')' { $$.c = $10.c + to_string(contador_parametros) + $1.c + "@" + $3.c + "[@]" + $5.c + "[@]" + 
                                           $7.c + "[@]" + "$"; contador_parametros = 0; }   
       | ID                           { $$.c = $1.c + "@"; }
       | '{' VALORES '}' { $$.c = novo + "{}" + $2.c; }
       | '[' ARGS ']'    { $$.c = novo + "[]" + $2.c; }                   
       ;

ARGS : ARGS ',' E     { contador_argumentos += 1; $$.c = $1.c + to_string(contador_argumentos) + $3.c + "[<=]"; } 
     | E              { contador_argumentos = 0; $$.c = novo + to_string(contador_argumentos) + $1.c + "[<=]"; }
     ;
       
ATRIBUTOS : ID '[' ID ']' ATRIBUTOS       { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c; }
          | ID '.' ID ATRIBUTOS          { $$.c = $1.c + "@" + $3.c + "[@]" + $4.c; }
          | ID '[' ID ']'                { $$.c = $1.c + "@" + $3.c; }
          | ID '.' ID                    { $$.c = $1.c + "@" + $3.c; }
          | ID '.' ID '[' E ']'          { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c; }          
          | ID '.' ID '.' ID             { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c; }
          | ID '.' ID '.' ID '[' E ']'   { $$.c = $1.c + "@" + $3.c + "[@]" + $5.c + "[@]" + $7.c; }                    
          | ID '.' ID '('')'             { $$.c = novo + "0" + $1.c + "@" + $3.c + "[@]" + "$"; }
          | ID '.' ID '(' VALORES ')'    { $$.c = $5.c + to_string(contador_parametros) + $1.c + "@" + $3.c + "[@]" + "$"; contador_parametros = 0; }
          
          | ID '.' ID '[' ID ']' '(' VALORES ')'    { $$.c = $8.c + to_string(contador_parametros) + $1.c + "@" + $3.c + "[@]" + $5.c + "[@]" + "$"; 
                                                     contador_parametros = 0; }
          | ID '[' ID ']' '(' VALORES ')'           { $$.c = $6.c + to_string(contador_parametros) + $1.c + "@" + $3.c + "[@]" + "$"; 
                                                     contador_parametros = 0; }
          
          | ID '.' ID '.' ID '[' E ']' '(' VALORES ')' { $$.c = $10.c + to_string(contador_parametros) + $1.c + "@" + $3.c + "[@]" + $5.c + "[@]" + 
                                           $7.c + "[@]" + "$"; contador_parametros = 0; }                      
          ;
          
E : E '^' E             { $$.c = $1.c + $3.c + "^"; }
  | E '<' E             { $$.c = $1.c + $3.c + "<"; }
  | E '>' E             { $$.c = $1.c + $3.c + ">"; }
  | E MAIOR_IGUAL E     { $$.c = $1.c + $3.c + ">="; }
  | E DIF E             { $$.c = $1.c + $3.c + "!="; }
  | E MENOR_IGUAL E     { $$.c = $1.c + $3.c + "<="; }
  | E IGUAL E           { $$.c = $1.c + $3.c + "=="; }
  | E '*' E             { $$.c = $1.c + $3.c + "*"; }
  | E '+' E             { $$.c = $1.c + $3.c + "+"; }
  | E '-' E             { $$.c = $1.c + $3.c + "-"; } 
  | E '/' E             { $$.c = $1.c + $3.c + "/"; }
  | E '%' E             { $$.c = $1.c + $3.c + "%"; }
  | F
  ;



F : RVALUE          { $$.c = $1.c; }
  | NUM             { $$.c = $1.c; }
  | STRING          { $$.c = $1.c; }
  | ID '=' E        { $$.c = $1.c + $3.c + "="; }  
  | BLOCOVAZIO      { $$.c = novo + "{}"; }
  | '['']'          { $$.c = novo + "[]"; }
  | '(' E ')'       { $$ = $2; }
  | ID '('')'       { $$.c = novo + "0" + $1.c + "@" + "$"; }
  | ID '(' VALORES ')'    { $$.c = $3.c + to_string(contador_parametros) + $1.c + "@" + "$"; contador_parametros = 0; }
  | ID ':' E        { $$.c = $1.c + $3.c + "[<=]"; }
  | CONST           { $$.c = $1.c; }
  ;

CONST : TRUE        { $$.c = novo + "true"; }
      | FALSE       { $$.c = novo + "false"; }
      ;
      
VALORES : VALORES ',' E { contador_parametros += 1; $$.c = $1.c + $3.c; }
        | E             { contador_parametros = 1; $$.c = $1.c; }
        ;
        
BLOCOVAZIO : '{' '}' {$$.c = novo;}
           ;


%%

#include "lex.yy.c"

string trim (string original, string remove){
  string ret = "";
  for (int i = 0; original[i] != '\0'; ++i){
    int avaliador = 0;
    for (int j = 0 ; remove[j] != '\0'; j++){
      if (original[i] == remove[j]) avaliador = 1;
    }
    if (!avaliador) ret += original[i];
  }
  return ret;
}

vector<string> tokeniza(string original){
  string a = "";
  vector<string> retorno;
  for (int i = 0; original[i] != '\0'; ++i){
    if (original[i] != ' '){
      a += original[i];
    } else {
      retorno.push_back(a);
      a = "";
    }
  }
  retorno.push_back(a);
  return retorno;
}

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
