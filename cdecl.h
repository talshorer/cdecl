#ifndef __CDECL_H
#define __CDECL_H

#include <stdlib.h>
#include <stdbool.h>

enum node_types {
	NODE_DECLARATION,
	NODE_IDENTIFIER,
	NODE_POINTER,
	NODE_ARRAY,
	NODE_FUNCTION,
};

struct size {
	bool valid;
	size_t value;
};

struct node {
	enum node_types type;
	union {
		struct {
			char *type;
			struct node *prev;
		} declaration;
		struct {
			char *name;
		} identifier;
		struct {
			struct node *prev;
		} pointer;
		struct {
			struct size size;
			struct node *prev;
		} array;
		struct {
			struct node *prev;
		} function;
	};
};

extern struct node *cdecl_create_node(void);

extern void cdecl(struct node *node);

#endif /* __CDECL_H */
