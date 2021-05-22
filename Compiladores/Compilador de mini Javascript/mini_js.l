DELIM   [\t\n ]
DIGITO  [0-9]
LETRA   [A-Za-z_]
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STR_1 	[']([^\'\n]|(\\\')|\'\')+[']
STR_2 	["]([^\"\n]|(\\\")|\"\")+["]

%%

{DELIM}    { }

             
{DOUBLE}   { yylval.c = novo + yytext; 
             return NUM; }   
             
{STR_1}    { yylval.c = novo + yytext;
	     return STR; }

{STR_2}    { yylval.c = novo + yytext;
	     return STR; }
	     
"let"	   { yylval.c = novo + "let"; 
             return LET; }
             
"if"	   { yylval.c = novo + "if"; 
             return IF; }
             
"while"    { yylval.c = novo + "while"; 
             return WHILE; }    

"for"      { yylval.c = novo + "for"; 
             return FOR; }                          
             
"else"	   { yylval.c = novo + "else"; 
             return ELSE; }             

{ID}       { yylval.c = novo + yytext; 
             return ID; }

.          { yylval.c = novo + yytext;
	     return yytext[0]; }

%%
