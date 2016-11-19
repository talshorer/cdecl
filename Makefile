TARGET := cdecl

all: $(TARGET)

# disable implicit rules
.SUFFIXES:

%.tab.c: %.y
	bison -v -d $< -t

%.yy.c: %.l
	flex -o $@ $<

$(TARGET): $(TARGET).c $(TARGET).tab.c $(TARGET).yy.c
	$(CC) -o $@ $^

clean:
	rm -fv *.yy.c *.tab.* *.output *~ $(TARGET)
