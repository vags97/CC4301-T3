#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Este programa verifica que las instrucciones BTOI e ITOB
 * funcionan correctamente.  Si su tarea funciona correctamente,
 * la salida estadar de este programa incluira este mensaje:
 *
 *     Bravo! Su tarea funciona correctamente
 *
 */

/* Datos de prueba: Su programa debe funcionar *con* estos datos de
 * prueba.
 */

int N= 10;
char *ascii[] = { "0", "1", "10", "1111", "111010", "10000000", "100110011001",
                  "111111111111", "0", "1111111111111111111111111111111" };
int numeros[] = { 0, 1, 2, 15, 58, 128, 2457, 4095, 0, 2147483647};

/* Estos simbolos deben ser definidos en sieve-threaded.s como .globl */
int interprete(int *code, int *sp);
extern int codigo_verifica[10];  /* Da lo mismo el tamano del arreglo */
extern int codigo_btoitob[10];   /* % */

/* El stack */

#define STACK_SIZE 4096
int stack[STACK_SIZE];

/* programa principal a modo de ejemplo */

int main(int argc, char **argv) {
  int *sp= &stack[STACK_SIZE];
  int array_verif[6];
  int retV;

  {
    /* Primero verificamos que el interprete ande bien */
#if 1
    /* Una vez que esta verificacion funcione, puede ser mas facil
     * el resto de la depuracion desactivando este codigo.  Para ello
     * cambie la linea anterior por #if 0.  Cuidado: su tarea se
     * verificara con este codigo activo!
     */
    sp[-1]= (int)array_verif;
    retV= interprete(codigo_verifica, &sp[-1]);
    if (retV!=0) {
      printf("Alguna de las nuevas intrucciones no funciona bien.\n");
      printf("El codigo de error es %d.  Vea en sieve-bytecode que\n", retV);
      printf("instruccion es la que falla, en la declaracion de\n");
      printf("codigo_verifica.\n");
      exit(1);
    }
    if (array_verif[5]!=-123) {
      printf("ST_ARRAY no funciona, no guardo -123 en el indice 5\n");
      exit(1);
    }
#endif
  }

  {
    int numeros_salida[N];
    char *ascii_salida[N];
    int i;
    for (i= 0; i<N; i++)
      ascii_salida[i]= (char*)malloc(40);

    sp[-1]= (int)ascii_salida;
    sp[-2]= (int)numeros_salida;
    sp[-3]= N;
    sp[-4]= (int)ascii;
    interprete(codigo_btoitob, &sp[-4]); 
    for (i=0; i<N; i++) { 
      if (numeros[i]!=numeros_salida[i]) {
         printf("btoi no funciona con x= %d\n", numeros[i]);
         exit(1);
      }
      if (strncmp(ascii[i], ascii_salida[i], 40)!=0) {
        printf("itob no funciona con x= %d\n", numeros[i]);
        exit(1);
      }
    }
  }
  printf("Bravo! Su tarea funciona correctamente\n");

  return 0;
}

