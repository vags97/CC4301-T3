        .text
        .align 32  # por razones de eficiencia se alinea en borde
                   # de linea en memoria cache

# Para que codigo_btoitob funcione, Ud. debe implementar al
# final de este archivo las instrucciones BTOI, ITOB, ARG2 y ARG3.
# Estudie el codigo de otras instrucciones para descubrir
# como debe implementarlas.

# Este archivo incluye:
# codigo_btoitob: el codigo interpretado que invoca
# las operaciones BTOI, ITOB, ARG2 y ARG3.  Estudie este codigo
# para determinar como reciben la pila las operaciones que
# Ud. debe implementar.
#
# codigo_verifica: el codigo interpretado que verifica
# que la implementacion actual del interprete es correcta
# y que las operaciones que Ud. agrego no rompen su
# funcionamiento.  No necesita estudiar este codigo
# si no rompe nada.

# interprete: el interprete de threaded-code.  Estudie
# como se implementaron las operaciones preexistentes.

#
# Le sera de mucha utilidad escribir un programa en C que
# implemente estas operaciones y luego compilelo con -S -O.
# Luego adapte el codigo generado por gcc para que funcione
# con el resto de las instrucciones del interprete.
#
# Solo modifique el final de este archivo, desde la linea en
# donde se indica:
# "Agregue aca la implementacion de las operaciones faltantes".
#

#------------------------------------------------------------
# No modificar el codigo que viene a continuacion
#------------------------------------------------------------

# El codigo que sigue sirve para verificar que las instrucciones BTOI e
# ITOB funcionan correctamente.  Es funcionalmente equivalente a este otro
# codigo escrito en C:
#  void codigo_btoitob(char **ascii, int n, int *numeros_salida, char **ascii_salida) {
#    int i= 0;
#    int x;
#    while (i<n) {
#      x= btoi(ascii[i]);
#      numeros_salida[i]= x;
#      itob(x, ascii_salida[i]);
#      i++;
#    }
#  }

# El estado del tope de la pila se denota como:
#       ...            # valor1, valor2, ..., etc.
# en donde valor1 es el tope de la pila, valor2 el siguiente elemento, etc.
# La pila vacia se escribe como <vacia>
# Efectos laterales se denotan entre [ ... ].
        .globl codigo_btoitob
codigo_btoitob:
        .long PUSH, 0  # i= 0
        .long PUSH, 0  # x
# etiqueta INI_FOR
# while (i<n)
        .long LOCAL0   # i
        .long ARG1     # n, i
        .long JMPGE, 21 # [if (i>=n) goto FIN_FOR] <vacia>
# x= htoi(ascii[i]);
        .long ARG0     # ascii
        .long LOCAL0   # i, ascii
        .long ARRAY    # ascii[i]
        .long BTOI     # call btoi(ascii[i])
        .long ST_LOCAL1 # [x= ...] <vacia>
# numeros_salida[i]= x;
        .long ARG2     # numeros_salida
        .long LOCAL0   # i, numeros_salida
        .long LOCAL1   # x, i, numeros_salida
        .long ST_ARRAY  # [numeros_salida[i]= x], <vacia>
# itoh(x, ascii_salida[i]);
        .long LOCAL1   # x
        .long ARG3     # ascii_salida, x
        .long LOCAL0   # i, ascii_salida, x
        .long ARRAY    # ascii_salida[i], x
        .long ITOB     # [call itob(x, ascii_salida[i])], vacia
# i++;
        .long LOCAL0   # i
        .long PUSH, 1  # 1, i
        .long ADD      # i+1
        .long ST_LOCAL0 # [ i= i+1 ] <vacia>
        .long JMP, -25 # [goto INI_FOR]
# etiqueta FIN_FOR
        .long RET

# Este codigo hace el mejor esfuerzo por verificar que haya implementado
# correctamente las instrucciones.  Con mala suerte, algunos errores
# pueden escaparse.
        .globl codigo_verifica   # Para que se vea desde test-sieve-threaded.c
codigo_verifica:
  # Verifica que funciona los LOCALx
        .long PUSH, 1 
        .long PUSH, 2 
        .long PUSH, 3 
        .long PUSH, 4 

        .long LOCAL0 
        .long PUSH, 1 
        .long JMPEQ, 3 
        .long PUSH, -1  # No funciona LOCAL0
        .long RET 

        .long LOCAL1 
        .long PUSH, 2 
        .long JMPEQ, 3 
        .long PUSH, -2  # No funciona LOCAL1
        .long RET 

        .long LOCAL2 
        .long PUSH, 3 
        .long JMPEQ, 3 
        .long PUSH, -3  # No funciona LOCAL2
        .long RET 

        .long LOCAL3 
        .long PUSH, 4 
        .long JMPEQ, 3 
        .long PUSH, -4  # No funciona LOCAL3
        .long RET 

  # Verifica que funcionan los ST_LOCALx
        .long PUSH, 10 
        .long ST_LOCAL0 
        .long PUSH, 10 
        .long LOCAL0 
        .long JMPEQ, 3 
        .long PUSH, -10  # No funciona ST_LOCAL0
        .long RET 

        .long PUSH, 20 
        .long ST_LOCAL1 
        .long PUSH, 20 
        .long LOCAL1 
        .long JMPEQ, 3 
        .long PUSH, -11  # No funciona ST_LOCAL1
        .long RET 

        .long PUSH, 30 
        .long ST_LOCAL2 
        .long PUSH, 30 
        .long LOCAL2 
        .long JMPEQ, 3 
        .long PUSH, -12  # No funciona ST_LOCAL2
        .long RET 

        .long PUSH, 40 
        .long ST_LOCAL3 
        .long PUSH, 40   # Se vuelve a chequear al final del programa!
        .long LOCAL3 
        .long JMPEQ, 3 
        .long PUSH, -13  # No funciona ST_LOCAL3
        .long RET 

  # Verifica que funcione ARRAY y ST_ARRAY
        .long ARG0 
        .long PUSH, 5 
        .long PUSH, -123 
        .long ST_ARRAY 
        .long ARG0 
        .long PUSH, 5 
        .long ARRAY 
        .long PUSH, -123 
        .long JMPEQ, 3 
        .long PUSH, -20  # No funciona ARRAY o ST_ARRAY
        .long RET 

  # Verifica que funcione ADD
        .long PUSH, 5 
        .long PUSH, 15 
        .long ADD 
        .long PUSH, 20 
        .long JMPEQ, 3 
        .long PUSH, -30  /* No funciona ADD */
        .long RET

  # Verifica que funcione JMPNE

        .long PUSH, 1
        .long PUSH, 2 
        .long JMPNE, 3 
        .long PUSH, -40  # No funciona JMPNE: no salto cuando es menor
        .long RET 

        .long PUSH, 2 
        .long PUSH, 1 
        .long JMPNE, 3 
        .long PUSH, -41  # No funciona JMPNE: no salto cuando es mayor
        .long RET 

        .long PUSH, 10 
        .long PUSH, 10 
        .long JMPNE, 2 
        .long JMP, 3 
        .long PUSH, -42  # No funciona JMPNE: salta cuando hay igualdad
        .long RET 

  # Verifica que funcione JMPGT

        .long PUSH, 5 
        .long PUSH, 2 
        .long JMPGT, 3 
        .long PUSH, -50  # No funciona JMPGT: no salta cuando deberia
        .long RET 

        .long PUSH, 10 
        .long PUSH, 10 
        .long JMPGT, 2 
        .long JMP, 3 
        .long PUSH, -51  # No funciona JMPGT: salta cuando hay igualdad
        .long RET 

        .long PUSH, 10 
        .long PUSH, 15 
        .long JMPGT, 2 
        .long JMP, 3 
        .long PUSH, -52  # No funciona JMPGT: salta cuando es menor
        .long RET 

        .long PUSH, 40 
        .long JMPEQ, 3 
        .long PUSH, -60  # Los movimientos del sp son incorrectos:
        .long RET     # A estas alturas, deberia apuntar hacia la 4ta. variable
                      # local, que contiene 40

        .long PUSH, 0    # La instrucciones parecen funcionar ok
        .long RET


# El interprete de threaded-code
# int interprete(int *codigo, int *sp)
# Asi queda la pila despues de inicializar %ebp, ver (*):
#                  +-----------+
#                  |    sp     |
#                  +-----------+
#              +8  |  codigo   |
#                  +-----------+
#              +4  | dir. ret. |
#                  +-----------+
# %ebp, %esp->     | %ebp ant. |
#                  +-----------+
        .globl interprete  # Hace que interprete sea visible desde
                           # otros archivos
        .align  4  # por razones de eficiencia se alinea en borde de palabra
interprete:
        pushl   %ebp
        movl    %esp, %ebp      # %ebp inicializado (*)
        pushl   %edi            # resguarda registros del llamador
        pushl   %esi
        pushl   %ebx
        # Inicializacion de sp, pc y fp del interprete de bytecode.
        # No confundir con %esp, %eip y %ebp que son los registros
        # del procesador.
        movl    12(%ebp), %ecx  # %ecx = sp (puntero a la pila)
        movl    8(%ebp), %ebx   # %ebx = pc (inicialmente = &codigo)
        movl    %ecx, %edi      # %edi = fp (puntero a los parametros)

        # La partida:
        #       +---------------+
        # pc->  | dir. cod. op.-+----+  direccion del codigo de la operacion
        #       +---------------+    |
        #       |               |    |
        #       +---------------+    |
        #       |               |    |
        #       +---------------+    |
        #       | inst. 1       |<---+  Instrucciones que ejecutan la operacion
        #       +---------------+
        #       | inst. 2       |
        #       +---------------+
        #       | ...           |

        movl    (%ebx), %eax    # %eax= *pc
        jmp     *%eax           # jmp a la direccion contenida en %eax

# Cada operacion como ARG0, ST_ARG0, etc.
# puede modificar %eax, %edx y %esi pero:
# + debe incrementar el pc (%ebx) en el largo de la instruccion
# + ajustar sp (%ecx) de acuerdo a los argumentos que se apilaron/desapilaron
# + no modificar fp (%edi)
# + no modificar %esp (pero Ud. puede apilar valores temporales si
#   se preocupa de desapilarlo).
# + no modificar %ebp
# apilar primer argumento
        .align  4
ARG0:
        subl    $4, %ecx        # --sp
        movl    (%edi), %eax    # parm0= fp[0]      (primer parametro)
        movl    %eax, (%ecx)    # sp[0]= parm0

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# apilar 2do. argumento
        .align  4
ST_ARG0:
        movl    (%ecx), %eax    # val= sp[0]
        movl    %eax, (%edi)    # fp[0]= val
        addl    $4, %ecx        # sp++

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# guardar primer argumento
       .align  4
ARG1:
        subl    $4, %ecx        # --sp
        movl    4(%edi), %eax   # parm1= fp1
        movl    %eax, (%ecx)    # sp[0]= parm1

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# guardar 2do. argumento
        .align  4
ST_ARG1:
        movl    (%ecx), %eax    # val= sp[0]
        movl    %eax, 4(%edi)   # fp[1]= val
        addl    $4, %ecx        # sp++

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# la resta
        .align  4
SUB:
        movl    (%ecx), %edx    # y= sp[0]
        addl    $4, %ecx        # sp++
        movl    (%ecx), %eax    # x= sp[0]
        subl    %edx, %eax      # z= x-y
        movl    %eax, (%ecx)    # sp[0]= z

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# salto incondicional
        .align  4
JMP:
        movl    4(%ebx), %eax   # disp= pc[1]
        leal    (%ebx,%eax,4), %eax  # nuevopc= pc+disp (load effective address)
        leal    8(%eax), %ebx   # pc= nuevopc+2
        movl    8(%eax), %eax   # operacion= *nuevopc
        jmp     *%eax           # jmp *operacion

# salta si >=
        .align  4
JMPGE:
        movl    (%ecx), %edx    # y= sp[0]
        movl    4(%ebx), %esi   # disp= pc[1]
        addl    $4, %ecx        # sp++
        addl    $8, %ebx        # pc= pc+2
        movl    (%ecx), %eax    # x= sp[0]
        addl    $4, %ecx        # sp++
        cmpl    %edx, %eax
        jl      JMPGE_FALSE     # if (x<y) goto JMPGE_FALSE
        leal    (%ebx,%esi,4), %ebx # pc= pc+disp (load effective address)
JMPGE_FALSE:
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # goto *operacion

# salta si ==
        .align  4
JMPEQ:
        movl    (%ecx), %edx    # y= sp[0]
        movl    4(%ebx), %esi   # disp= pc[1]
        addl    $4, %ecx        # sp++
        addl    $8, %ebx        # pc= pc+2
        movl    (%ecx), %eax    # x= sp[0]
        addl    $4, %ecx        # sp++
        cmpl    %edx, %eax
        jne     JMPEQ_FALSE     # if (x!=y) goto JMPEQ_FALSE
        leal    (%ebx,%esi,4), %ebx # pc= pc+disp (load effective address)
JMPEQ_FALSE:
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # goto *operacion

# retorna al llamador
        .align  4
RET:
        movl    (%ecx), %eax    # x= sp[0]
        popl    %ebx            # restaura los registros del llamador
        popl    %esi
        popl    %edi
        popl    %ebp
        ret                     # retorna al llamador

# Implemente el resto de las instrucciones aca ...
# apilar primer argumento
        .align  4
LOCAL0:
        subl    $4, %ecx        # --sp
        movl    -4(%edi), %eax  # parm0= fp[-1]
        movl    %eax, (%ecx)    # sp[0]= parm0

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion


# apilar primer argumento
        .align  4
LOCAL1:
        subl    $4, %ecx        # --sp
        movl    -8(%edi), %eax  # parm0= fp[-2]
        movl    %eax, (%ecx)    # sp[0]= parm0

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# apilar primer argumento
        .align  4
LOCAL2:
        subl    $4, %ecx        # --sp
        movl    -12(%edi), %eax # parm0= fp[-3]
        movl    %eax, (%ecx)    # sp[0]= parm0

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# apilar primer argumento
        .align  4
LOCAL3:
        subl    $4, %ecx        # --sp
        movl    -16(%edi), %eax  # parm0= fp[-4]
        movl    %eax, (%ecx)    # sp[0]= parm0

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# guardar variable local 0
        .align  4
ST_LOCAL0:
        movl    (%ecx), %eax    # val= sp[0]
        movl    %eax, -4(%edi)  # fp[-1]= val
        addl    $4, %ecx        # sp++

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# guardar variable local 0
        .align  4
ST_LOCAL1:
        movl    (%ecx), %eax    # val= sp[0]
        movl    %eax, -8(%edi)  # fp[-1]= val
        addl    $4, %ecx        # sp++

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

ST_LOCAL2:
        movl    (%ecx), %eax    # val= sp[0]
        movl    %eax, -12(%edi)  # fp[-2]= val
        addl    $4, %ecx        # sp++

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# guardar variable local 0
        .align  4
ST_LOCAL3:
        movl    (%ecx), %eax    # val= sp[0]
        movl    %eax, -16(%edi) # fp[-3]= val
        addl    $4, %ecx        # sp++

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# push
        .align  4
PUSH:
        subl    $4, %ecx        # --sp
        movl    4(%ebx), %eax    # parm0= pc[1]
        movl    %eax, (%ecx)    # sp[0]= parm0
        
        addl    $8, %ebx        # pc+=2
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

# salta si !=
        .align  4
JMPNE:
        movl    (%ecx), %edx    # y= sp[0]
        movl    4(%ebx), %esi   # disp= pc[1]
        addl    $4, %ecx        # sp++
        addl    $8, %ebx        # pc= pc+2
        movl    (%ecx), %eax    # x= sp[0]
        addl    $4, %ecx        # sp++
        cmpl    %edx, %eax
        je      JMPNE_FALSE     # if (x==y) goto JMPNE_FALSE
        leal    (%ebx,%esi,4), %ebx # pc= pc+disp (load effective address)
JMPNE_FALSE:
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # goto *operacion

# salta si >
        .align  4
JMPGT:
        movl    (%ecx), %edx    # y= sp[0]
        movl    4(%ebx), %esi   # disp= pc[1]
        addl    $4, %ecx        # sp++
        addl    $8, %ebx        # pc= pc+2
        movl    (%ecx), %eax    # x= sp[0]
        addl    $4, %ecx        # sp++
        cmpl    %edx, %eax
        jle     JMPGT_FALSE     # if (x<=y) goto JMPGE_FALSE
        leal    (%ebx,%esi,4), %ebx # pc= pc+disp (load effective address)
JMPGT_FALSE:
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # goto *operacion

# la suma
        .align  4
ADD:
        movl    (%ecx), %edx    # y= sp[0]
        addl    $4, %ecx        # sp++
        movl    (%ecx), %eax    # x= sp[0]
        addl    %edx, %eax      # z= x+y
        movl    %eax, (%ecx)    # sp[0]= z

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

ARRAY:
        movl    (%ecx), %edx    # i= sp[0]
        addl    $4, %ecx        # sp++
        movl    (%ecx), %eax    # a= sp[0]
        addl    $4, %ecx        # sp++
        subl    $4, %ecx        # --sp
        movl    (%eax,%edx,4), %eax  # parm0=a[i]
        movl    %eax, (%ecx)    # sp[0]= parm0

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

ST_ARRAY:
        movl    (%ecx), %esi    # v= sp[0]
        addl    $4, %ecx        # sp++
        movl    (%ecx), %edx    # i= sp[0]
        addl    $4, %ecx        # sp++
        movl    (%ecx), %eax    # a= sp[0]
        addl    $4, %ecx        # sp++
        movl    %esi,(%eax,%edx,4) # a[i]=v

        addl    $4, %ebx        # pc++
        movl    (%ebx), %eax    # operacion= *pc
        jmp     *%eax           # jmp *operacion

#------------------------------------------------------------
# Agregue aca la implementacion de las operaciones faltantes
#------------------------------------------------------------

ARG2:

ARG3:

BTOI:

ITOB:

