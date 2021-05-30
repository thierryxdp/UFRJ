DIGITO  [0-9]
LETRA   [A-Za-z_]
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STR_1 	[']([^\'\n]|(\\\')|\'\')+[']
STR_2 	["]([^\"\n]|(\\\")|\"\")+["]

%%

"\t"       { coluna += 4; }
" "        { coluna++; }
"\n"       { linha++; coluna = 1; }

             
{DOUBLE}   { yylval.c = novo + yytext; 
             return NUM; }   
             
{STR_1}    { yylval.c = novo + yytext;
	     return STRING; }

{STR_2}    { yylval.c = novo + yytext;
	     return STRING; }
   
">="       { yylval.c = novo + "erro: >="; 
             return MAIOR_IGUAL; }
"<="       { yylval.c = novo + "erro: <="; 
             return MENOR_IGUAL; }
"=="       { yylval.c = novo + "erro: =="; 
             return IGUAL; }  

"=>"       { yylval.c = novo + "erro: =>"; 
             return SETA; }            

"!="       { yylval.c = novo + "erro: !="; 
             return DIF; }                    
	     
"let"      { yylval.c = novo + "erro: let"; 
             return LET; }
             
"function" { yylval.c = novo + "erro: function"; 
             return FUNCTION; }

"return"   { yylval.c = novo + "erro: return"; 
             return RETURN; }             
                          
"if"	   { yylval.c = novo + "erro: if"; 
             return IF; }
             
"while"    { yylval.c = novo + "erro: while"; 
             return WHILE; }    

"for"      { yylval.c = novo + "erro: for"; 
             return FOR; }                          
             
"else"	   { yylval.c = novo + "erro: else"; 
             return ELSE; }             

{ID}       { yylval.c = novo + yytext; 
             return ID; }

.          { yylval.c = novo + yytext;
	     return yytext[0]; }

%%
