TARGET := cdecl

cdecl.o_CFLAGS := -Wall -Werror

all: $(TARGET)

# disable implicit rules
.SUFFIXES:

%.tab.c: %.y
	bison -v -d $< -t

%.yy.c: %.l
	flex -o $@ $<

%.o: %.c
	$(CC) -c -o $@ $($@_CFLAGS) $<

$(TARGET): $(TARGET).o $(TARGET).tab.o $(TARGET).yy.o
	$(CC) -o $@ $^

clean:
	rm -fv *.yy.c *.tab.* *.output *~ $(TARGET)
