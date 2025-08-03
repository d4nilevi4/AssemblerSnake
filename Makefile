all: snake

snake: main.o
	ld -m elf_i386 -o snake $^

%.o: %.asm
	nasm -f elf32 $< -o $@

clean:
	rm -f *.o snake
