#include <stdio.h>

#include "cdecl.h"

struct node *cdecl_create_node(void)
{
	void *ret;

	ret = malloc(sizeof(struct node));
	if (!ret) {
		fprintf(stderr, "failed to allocate node\n");
		exit(1);
	}
}

void cdecl(struct node *node)
{
	switch (node->type) {
	case NODE_DECLARATION:
		cdecl(node->declaration.prev);
		printf("%s\n", node->declaration.type);
		break;
	case NODE_IDENTIFIER:
		printf("%s is ", node->identifier.name);
		break;
	case NODE_POINTER:
		cdecl(node->pointer.prev);
		printf("a pointer to ");
		break;
	case NODE_ARRAY:
		cdecl(node->array.prev);
		printf("an array ");
		if (node->array.size.valid)
			printf("of size %zd ", node->array.size.value);
		printf("of ");
		break;
	case NODE_FUNCTION:
		cdecl(node->function.prev);
		printf("a function returning ");
		break;
	}
	free(node);
}
