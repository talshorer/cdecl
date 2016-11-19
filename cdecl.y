%{
#include <stdio.h>
extern int yylex(void);
extern void yyerror(char *);
%}

%union {
	int integer;
	char *ident;
}

%token <ident> IDENT
%token <integer> INTEGER

%right '*' '[' '('
%left ','

%%

request
	: request IDENT decl '\n' { printf("%s\n", $2); }
	| 
	;

decl
	: IDENT { printf("%s is ", $1); }
	| ptr { printf("a pointer to "); }
	| arr { printf("an array of "); }
	| func { printf("a function returning "); }
	| '(' decl ')'
	;

ptr
	: '*' decl
	;

size
	: INTEGER
	| 
	;

arr
	: decl '[' size ']'
	;

func
	: decl '(' ')'
	;

%%

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(int argc, char *argv[]) {
	if (argc > 1 && argv[1][0] == 't')
		yydebug = 1;
	yyparse();
	return 0;
}
