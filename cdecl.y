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

%type <node> decl;
%type <node> ptr;
%type <node> arr;
%type <node> func;
%type <size> size;

%%

request
	  : request IDENT decl '\n' {
		struct node *node = cdecl_create_node();

		node->type = NODE_DECLARATION;
		node->declaration.type = $2;
		node->declaration.prev = $3;
		cdecl(node);
	} |  {
	} ;

decl
	  : IDENT {
		struct node *node = cdecl_create_node();

		node->type = NODE_IDENTIFIER;
		node->identifier.name = $1;
		$$ = node;
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
		struct node *node = cdecl_create_node();

		node->type = NODE_POINTER;
		node->pointer.prev = $2;
		$$ = node;
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
		struct node *node = cdecl_create_node();

		node->type = NODE_ARRAY;
		node->array.prev = $1;
		node->array.size = $3;
		$$ = node;
	} ;

func
	  : decl '(' ')' {
		struct node *node = cdecl_create_node();

		node->type = NODE_FUNCTION;
		node->function.prev = $1;
		$$ = node;
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
