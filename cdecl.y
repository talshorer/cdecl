%{
#include <stdio.h>

#include "cdecl.h"

extern int yylex(void);
extern void yyerror(char *);
%}

%union {
	int integer;
	char *ident;
	struct node *node;
	struct size size;
}

%token <ident> IDENT
%token <integer> INTEGER

%right '*' '[' '('
%left ','

%type <node> request;
%type <node> decl;
%type <node> ptr;
%type <node> arr;
%type <node> func;
%type <size> size;

%%

request
	  : request IDENT decl '\n' {
		$$ = cdecl_create_node();
		$$->type = NODE_DECLARATION;
		$$->declaration.type = $2;
		$$->declaration.prev = $3;
		cdecl($$);
	} |  {
	} ;

decl
	  : IDENT {
		$$ = cdecl_create_node();
		$$->type = NODE_IDENTIFIER;
		$$->identifier.name = $1;
	} | ptr {
		$$ = $1;
	} | arr {
		$$ = $1;
	} | func {
		$$ = $1;
	} | '(' decl ')' {
		$$ = $2;
	} ;

ptr
	  : '*' decl {
		$$ = cdecl_create_node();
		$$->type = NODE_POINTER;
		$$->pointer.prev = $2;
	} ;

size
	  : INTEGER {
		$$.valid = true;
		$$.value = $1;
	} |  {
		$$.valid = false;
	} ;

arr
	  : decl '[' size ']' {
		$$ = cdecl_create_node();
		$$->type = NODE_ARRAY;
		$$->array.prev = $1;
		$$->array.size = $3;
	} ;

func
	  : decl '(' ')' {
		$$ = cdecl_create_node();
		$$->type = NODE_FUNCTION;
		$$->function.prev = $1;
	} ;

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
