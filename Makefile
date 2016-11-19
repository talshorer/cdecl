all:
	bison -v -d cdecl.y -t            # create y.tab.h, y.tab.c
	flex cdecl.l                   # create lex.yy.c
	gcc lex.yy.c cdecl.tab.c -o cdecl  # compile/link

