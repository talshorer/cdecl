%{
#include "cdecl.h"
#include "cdecl.tab.h"
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

[\[\]*()\n]	{
			char v = *yytext;
			*yytext = 0;
			return v;
		}

[ \t]	*yytext = 0; /* terminate identifiers */

%%

int yywrap(void) {
	return 1;
}
