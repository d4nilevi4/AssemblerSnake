TARGET = snake
SRC = main.asm screen.asm cursor.asm
OBJ = $(SRC:.asm=.o)

all: $(TARGET)

$(TARGET): $(OBJ)
	ld -m elf_i386 -o $@ $^

%.o: %.asm
	nasm -f elf32 $< -o $@

clean:
	rm -f *.o $(TARGET)
