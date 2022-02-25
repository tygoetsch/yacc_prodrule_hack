CC=gcc
CFLAGS=-g -Wall
CFLAGS_OBJ=-g -Wall -c

all: pr_hack

#============================================================ pr_hack

lex.yy.o: yacc_prodrule_hack_lex.l
	flex yacc_prodrule_hack_lex.l
	$(CC) $(CFLAGS_OBJ) lex.yy.c

pr_hack: lex.yy.o yacc_prodrule_hack.c
	$(CC) $(CFLAGS_OBJ) yacc_prodrule_hack.c
	$(CC) $(CFLAGS) yacc_prodrule_hack.o lex.yy.o -o pr_hack
	@ make -s move

#============================================================ MOVE

move:
	@ mkdir -p build
	@ mv lex.yy.c build/
	@ mv *.o build/

#============================================================ CLEAN

clean:
	rm -rf build/
