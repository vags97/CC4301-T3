# Instrucciones de uso:
#
# + Interprete de bytecode para calcular el mcd de 2 numeros.
#   El programa se encuentra en mcd-bytecode.c.
#   Compilar:    % make mcd-bytecode
#   Ejecutar:    % ./mcd-bytecode 12 15
#
# + Interprete de bytecode para calcular los primeros n numeros primos.
#   El programa se encuentra en sieve-bytecode.c.
#   Compilar:    % make sieve-bytecode
#   Ejecutar:    % ./sieve-bytecode 100
#
# + Codigo threaded para calcular el mcd de 2 numeros.
#   Archivos:
#     - interp-threaded0.s (interprete de codigo threaded)
#     - mcd-threaded.s     (codigo threaded para calcular mcd)
#     - test-mcd-threaded.c (programa de prueba)
#   Compilar:    % make test-mcd-threaded
#   Ejecutar:    % ./test-mcd-threaded 12 15
#
# + Codigo threaded para calcular los primeros n numeros primos.
#   Archivos:
#     - interp-threaded0.s (interprete de codigo threaded)
#     - sieve-threaded.s   (codigo threaded para calcular sieve)
#     - test-sieve-threaded.c (programa de prueba)
#   Compilar:    % make test-sieve-threaded
#   Ejecutar:    % ./test-sieve-threaded 100
#
# + Codigo threaded para realizar una busqueda binaria.
#   Archivos:
#     - interp-threaded.s (*falta*, implementelo a partir de interp-threaded0.s)
#     - btoitob-threaded.s (codigo threaded de la busqueda binaria)
#     - test-btoitob-threaded.c (programa de prueba)
#   Compilar:    % make test-btoitob-threaded
#   Ejecutar:    % ./test-btoitob-threaded
#
CFLAGS= -g -m32
LDFLAGS= -g -m32
ASFLAGS= --32

all: mcd-bytecode sieve-bytecode test-mcd-threaded \
     test-sieve-threaded test-btoitob-threaded

test-mcd-threaded: mcd-threaded.o test-mcd-threaded.o interp-threaded0.o

test-sieve-threaded: sieve-threaded.o test-sieve-threaded.o \
                     interp-threaded0.o verifica-threaded.o

test-btoitob-threaded: btoitob-threaded.o test-btoitob-threaded.o

clean:
	rm -f *.o
	rm -f mcd-bytecode sieve-bytecode
	rm -f test-mcd-threaded test-sieve-threaded test-btoitob-threaded
