/* Coloque aqui definições regulares */

DIGITO [0-9]
LETRA [A-Za-z_$]

ID 	{LETRA}({LETRA}|{DIGITO})*
INT 	{DIGITO}+
FLOAT 	{INT}(\.{INT})?([Ee][+\-]?{INT})?
FOR 	[Ff][Oo][Rr]
IF	[Ii][Ff]
WS	[ \t\n]


COMENTARIO_1	[/][/][^\n]*
COMENTARIO_2	[/][*]([^*]*[*]+[^*/])*[^*]*[*]+[/]

STRING	["]([^\\"\n]|[\\]["]|["]["]|[\\][^"])*["]


%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */



{WS}	{ /* ignora espaços, tabs e '\n' */ } 
{INT}	{return _INT;}
{FLOAT} {return _FLOAT;}	
{FOR}	{return _FOR;}
{IF}	{return _IF;}

{COMENTARIO_1}	{return _COMENTARIO;}
{COMENTARIO_2}	{return _COMENTARIO;}

{STRING}	{return _STRING;}

">="	{return _MAIG;}
"<="	{return _MEIG;}
"=="	{return _IG;}
"!="	{return _DIF;}
{ID}	{return _ID;}
.       { return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%

/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */
