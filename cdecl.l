%{
#include "cdecl.tab.h"
#include <stdlib.h>
extern void yyerror(char *);
%}

%%

[0-9]+	{
		yylval.integer = atoi(yytext);
		return INTEGER;
	}

[a-zA-Z_][a-zA-Z_1-9]*	{
				yylval.ident = yytext;
				return IDENT;
			}

[\[\]*()\n]	return *yytext;

[ \t]	{
		*yytext = 0; /* terminate identifiers */
	}

%%

int yywrap(void) {
	return 1;
}
