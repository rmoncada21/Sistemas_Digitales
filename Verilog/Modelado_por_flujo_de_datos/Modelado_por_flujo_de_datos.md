# Modelado por Flujo de datos

El data flow modeling es una técnica para describir el comportamiento de un circuito digital basándose en la propagación de señales a través de sus componentes, utilizando expresiones de asignación continua (**assign**). **Esta técnica es adecuada para describir la lógica combinacional**, donde las salidas dependen directamente de las entradas sin necesidad de estados intermedios.


## a. Asignaciones continuas (assign)

Sintaxis para usar **assign** dentro del código

~~~verilog
//Syntax of assign statement in the simplest form
assign <drive_strength>? <delay>?  = <list_of_assignments>;
~~~

Desglose:

- **`assign`**: Se utiliza para hacer una asignación continua. Esto significa que la asignación se evalúa continuamente, y cualquier cambio en las señales de la derecha de la asignación provoca una actualización inmediata de la señal en el lado izquierdo.

- **`<drive_strength> (Opcional):`** especifica la fuerza de conducción de la señal. Esto es útil para resolver conflictos cuando múltiples fuentes intentan controlar la misma señal. 
    > assign (strong1, weak0) y = a & b;

- **`<delay> (Opcional):`** especifica un retraso en la propagación de la señal. Esto puede modelar retardos en el hardware real.

    > assign #10 y = a & b

- **`<list_of_assignment>:`** Esta es la lista de asignaciones donde se especifica la relación entre las señales de entrada y salida.
    > assign out = a & b;

**Consideraciones importantes**

Basandose en el siguiente módulo:

~~~verilog
module ejemplo1(
    input wire a,
    input wire b,
    output wire [1:0] y
);

module ejemplo2(
    input wire a,
    input wire b,
    output wire y
);
~~~

- El lado izquierdo de una asignación debe ser siempre una red escalar o vectorial o una concatenación de redes escalares y vectoriales. No puede ser un registro escalar o vectorial. Basandose en el ejemplo1
    > // y es una red vectorial
    assign y = {a , b}; // Concatenación de dos redes escalares

- Las asignaciones continuas están siempre activas. La expresión de asignación **se evalúa tan pronto como uno de los operandos del lado derecho cambia** y el valor se asigna a la red del lado izquierdo. Basándose en el modulo ejemplo2.
    > // la asignación continua siempre activa
    assign y = a & b; 

- Los operandos en el **lado derecho pueden ser registros o redes o llamadas a funciones**. Los registros o redes pueden ser escalares o vectoriales. Basándose en el modulo ejemplo2.

    ~~~verilog
    reg r;
    initial begin
        r = 1'b0; 
    end

    assign y = a & r;
    ~~~

- **Los valores de retardo** pueden especificarse para asignaciones en términos de unidades de tiempo. Los valores de retardo se utilizan para controlar el momento en que una red recibe el valor evaluado.
    > assign #5 y = a & b;

### a.1 Asignaciones implícitas

En vez de declarar una net y luego declarar el assign, se puede ambos al mismo tiempo.

~~~verilog
// versión 1 
wire out;
assign out = a & b;

// versión 2 - con los mismos efectos que conlleva hacer el assign
wire out = a & b;
~~~

## b. Delays

### b.1 Asignacion regular de Delay
En este método cualquier cambio en una de las variables a ó b, procederá a una retardo de 10 unidades de tiempo.

**`Propiedad inertial delay`**: Cuando se especifica un retardo inercial en un módulo o en un proceso de asignación de señales, se introduce un umbral de tiempo que una señal debe mantener un cambio antes de que el cambio se propague a la salida. **Si la señal cambia de nuevo antes de que este umbral se cumpla, el cambio inicial se ignora.**

~~~verilog
// Normal delay assign
assign #10 out = a & b;
~~~

### b.2 Asignación continua implícita de Delay

~~~verilog
// Continuos implicit delay assign
wire #10 out = a & b;

// lo mismo a codificar
wire out;
assign #10 out = a & b;
~~~

### b.3 Declaración net de Delay

~~~verilog
// Net delays
wire #10 out;
assign out = a & b;

// lo mismo a codificar
wire out;
assign #10 out = a & b;
~~~

## c. Expresiones, operadores y reguladores

## d. Tipos de operadores

| Operator Type | Operator Symbol | Operation Performed     | Number of Operands |
|---------------|-----------------|-------------------------|--------------------|
| Arithmetic    | *               | multiply                | two                |
|               | /               | divide                  | two                |
|               | +               | add                     | two                |
|               | -               | subtract                | two                |
|               | %               | modulus                 | two                |
| Logical       | !               | logical negation        | one                |
|               | &&              | logical and             | two                |
|               | \|\|            | logical or              | two                |
| Relational    | >               | greater than            | two                |
|               | <               | less than               | two                |
|               | >=              | greater than or equal   | two                |
|               | <=              | less than or equal      | two                |
| Equality      | ==              | equality                | two                |
|               | !=              | inequality              | two                |
|               | ===             | case equality           | two                |
|               | !==             | case inequality         | two                |
| Bitwise       | ~               | bitwise negation        | one                |
|               | &               | bitwise and             | two                |
|               | \|              | bitwise or              | two                |
|               | ^               | bitwise xor             | two                |
|               | ^~ or ~^        | bitwise xnor            | two                |
| Reduction     | &               | reduction and           | one                |
|               | ~&              | reduction nand          | one                |
|               | \|              | reduction or            | one                |
|               | ~\|             | reduction nor           | one                |
|               | ^               | reduction xor           | one                |
|               | ^~ or ~^        | reduction xnor          | one                |
| Shift         | >>              | Right shift             | two                |
|               | <<              | Left shift              | two                |
| Concatenation | { }             | Concatenation           | any number         |
| Replication   | { { } }         | Replication             | any number         |
| Conditional   | ?:              | Conditional             | three              |

### d.1 Operadores aritméticos

Hay dos tipos de operadores aritméticos: unarios y binarios.

### d.1.1 Unarios

1. **Negación aritmética (`-`)**:
   - Este operador unario devuelve el valor negativo del operando.
   - Ejemplo: `-a` donde `a` es `4'b0010` (2), devuelve `4'b1110` (-2 en complemento a 2).

2. **Más (`+`)**:
   - Este operador unario devuelve el valor del operando sin cambio, es más común en lenguajes de alto nivel, pero se puede usar en Verilog también.
   - Ejemplo: `+a` donde `a` es `4'b0010` (2), devuelve `4'b0010` (2).

### d.1.2 Binarios

1. **Adición (`+`)**:
   - Suma dos operandos.
   - Ejemplo: `a + b` donde `a` es `4'b0010` (2) y `b` es `4'b0011` (3), devuelve `4'b0101` (5).

2. **Sustracción (`-`)**:
   - Resta el segundo operando del primero.
   - Ejemplo: `a - b` donde `a` es `4'b0011` (3) y `b` es `4'b0001` (1), devuelve `4'b0010` (2).

3. **Multiplicación (`*`)**:
   - Multiplica dos operandos.
   - Ejemplo: `a * b` donde `a` es `4'b0010` (2) y `b` es `4'b0011` (3), devuelve `4'b0110` (6).

4. **División (`/`)**:
   - Divide el primer operando por el segundo.
   - Ejemplo: `a / b` donde `a` es `4'b0100` (4) y `b` es `4'b0010` (2), devuelve `4'b0010` (2).

5. **Módulo (`%`)**:
   - Devuelve el residuo de la división del primer operando por el segundo.
   - Ejemplo: `a % b` donde `a` es `4'b0101` (5) y `b` es `4'b0011` (3), devuelve `4'b0010` (2).

### d.2 Operadores lógicos

Los operadores lógicos se utilizan para realizar operaciones lógicas entre operandos booleanos.

1. **NOT lógico (`!`)**:
   - Operador unario.
   - Invierte el valor lógico del operando.
   - Ejemplo: `!a`.

2. **AND lógico (`&&`)**:
   - Operador binario.
   - Realiza una operación lógica AND entre dos operandos. El resultado es `1` solo si ambos operandos son `1`.
   - Ejemplo: `a && b`.

3. **OR lógico (`||`)**:
   - Operador binario.
   - Realiza una operación lógica OR entre dos operandos. El resultado es `1` si al menos uno de los operandos es `1`.
   - Ejemplo: `a || b`.

### d.3 Operadores de relación

En Verilog, los operadores de relación se utilizan para comparar dos operandos. El resultado de una comparación es un valor lógico (`1` o `0`).

1. **Igualdad (`==`)**:
   - Compara si dos operandos son iguales.
   - Ejemplo: `a == b` devuelve `1` si `a` es igual a `b`, y `0` en caso contrario.

2. **Desigualdad (`!=`)**:
   - Compara si dos operandos son diferentes.
   - Ejemplo: `a != b` devuelve `1` si `a` es diferente de `b`, y `0` en caso contrario.

3. **Menor que (`<`)**:
   - Compara si el primer operando es menor que el segundo.
   - Ejemplo: `a < b` devuelve `1` si `a` es menor que `b`, y `0` en caso contrario.

4. **Menor o igual que (`<=`)**:
   - Compara si el primer operando es menor o igual que el segundo.
   - Ejemplo: `a <= b` devuelve `1` si `a` es menor o igual que `b`, y `0` en caso contrario.

5. **Mayor que (`>`)**:
   - Compara si el primer operando es mayor que el segundo.
   - Ejemplo: `a > b` devuelve `1` si `a` es mayor que `b`, y `0` en caso contrario.

6. **Mayor o igual que (`>=`)**:
   - Compara si el primer operando es mayor o igual que el segundo.
   - Ejemplo: `a >= b` devuelve `1` si `a` es mayor o igual que `b`, y `0` en caso contrario.


### d.4 Operadores de igualdad

Los operadores de igualdad se utilizan para comparar dos operandos y determinar si son iguales o diferentes. Estos operadores se pueden utilizar tanto en comparaciones de tipo bit a bit como de tipo lógico.

1. **Igualdad (`==`)**:
   - Compara si dos operandos son iguales.
   - Ejemplo: `a == b` devuelve `1` si `a` es igual a `b`, y `0` en caso contrario.

2. **Desigualdad (`!=`)**:
   - Compara si dos operandos son diferentes.
   - Ejemplo: `a != b` devuelve `1` si `a` es diferente de `b`, y `0` en caso contrario.

3. **Igualdad con comparación exacta (`===`)**:
   - Compara si dos operandos son exactamente iguales, incluyendo el caso de `x` y `z` (desconocido y alta impedancia).
   - Ejemplo: `a === b` devuelve `1` si `a` es exactamente igual a `b`, incluyendo valores `x` y `z`, y `0` en caso contrario.

4. **Desigualdad con comparación exacta (`!==`)**:
   - Compara si dos operandos son exactamente diferentes, incluyendo el caso de `x` y `z` (desconocido y alta impedancia).
   - Ejemplo: `a !== b` devuelve `1` si `a` es exactamente diferente de `b`, incluyendo valores `x` y `z`, y `0` en caso contrario.

### d.5 Operadores bitwise

Los operadores bitwise (bit a bit) se utilizan para realizar operaciones a nivel de bit entre dos operandos. Estos operadores realizan operaciones en cada bit individual de los operandos.

1. **AND Bitwise (`&`)**:
   - Realiza una operación AND bit a bit en dos operandos. El resultado es un valor donde cada bit es el resultado de un AND entre los bits correspondientes de los operandos.
   - Ejemplo: `a & b`.

2. **OR Bitwise (`|`)**:
   - Realiza una operación OR bit a bit en dos operandos. El resultado es un valor donde cada bit es el resultado de un OR entre los bits correspondientes de los operandos.
   - Ejemplo: `a | b`.

3. **XOR Bitwise (`^`)**:
   - Realiza una operación XOR bit a bit en dos operandos. El resultado es un valor donde cada bit es el resultado de un XOR entre los bits correspondientes de los operandos.
   - Ejemplo: `a ^ b`.

4. **XNOR Bitwise (`~^` o `^~`)**:
   - Realiza una operación XNOR bit a bit en dos operandos. El resultado es un valor donde cada bit es el resultado de un XNOR entre los bits correspondientes de los operandos.
   - Ejemplo: `a ~^ b` o `a ^~ b`.

5. **Complemento Bitwise (`~`)**:
   - Realiza una operación NOT bit a bit en un solo operando. El resultado es un valor donde cada bit es el complemento (inverso) del bit correspondiente del operando.
   - Ejemplo: `~a`.

### d.6 Operadores de reducción 

Los operadores de reducción realizan una operación lógica bit a bit en todos los bits del operando y devuelven un solo bit como resultado.

1. **AND de reducción (`&`)**:
   - Realiza un AND bit a bit en todos los bits del operando.
   - Ejemplo: `&a` devuelve `1` si todos los bits de `a` son `1`, y `0` en caso contrario.

2. **OR de reducción (`|`)**:
   - Realiza un OR bit a bit en todos los bits del operando.
   - Ejemplo: `|a` devuelve `1` si al menos uno de los bits de `a` es `1`, y `0` si todos son `0`.

3. **XOR de reducción (`^`)**:
   - Realiza un XOR bit a bit en todos los bits del operando.
   - Ejemplo: `^a` devuelve `1` si hay un número impar de bits en `1` en `a`, y `0` si hay un número par.

4. **XNOR de reducción (`~^` o `^~`)**:
   - Realiza un XNOR bit a bit en todos los bits del operando.
   - Ejemplo: `~^a` o `^~a` devuelve `1` si hay un número par de bits en `1` en `a`, y `0` si hay un número impar.

### d.7 Operadores de desplazamiento (shift)

En Verilog, los operadores de desplazamiento (shift) se utilizan para mover los bits de un operando a la izquierda o a la derecha. Estos operadores son útiles para manipular y transformar datos a nivel de bit.

1. **Desplazamiento a la Izquierda (`<<`)**:
   - Desplaza los bits de un operando hacia la izquierda por un número especificado de posiciones. Los bits que se desplazan fuera del rango se descartan, y los nuevos bits a la derecha se rellenan con ceros.
   - **Sintaxis**: `a << n`
   - **Ejemplo**: `8'b10101100 << 2` resulta en `8'b10110000`.

2. **Desplazamiento a la Derecha (`>>`)**:
   - Desplaza los bits de un operando hacia la derecha por un número especificado de posiciones. Los bits que se desplazan fuera del rango se descartan. Para datos con signo (en `reg` o `logic`), el bit de signo se utiliza para rellenar los espacios vacíos en el desplazamiento derecho (esto es conocido como desplazamiento aritmético).
   - **Sintaxis**: `a >> n`
   - **Ejemplo**: `8'b10101100 >> 2` resulta en `8'b00101011`.

3. **Desplazamiento a la Derecha Lógico (`>>>`)**:
   - Similar al desplazamiento a la derecha, pero siempre rellena los bits a la izquierda con ceros, sin importar el signo del número. Este tipo de desplazamiento es útil para datos sin signo.
   - **Sintaxis**: `a >>> n`
   - **Ejemplo**: `8'b10101100 >>> 2` resulta en `8'b00101011`.

4. **Detalles Adicionales**
    
    **Desplazamiento Aritmético (>>) vs. Desplazamiento Lógico (>>>)**:
    - El operador `>>` realiza un desplazamiento aritmético cuando el operando es un número con signo (`reg` o `logic`), preservando el bit de signo. Por ejemplo, para números negativos, el bit de signo se replica para llenar los espacios vacíos.
    - El operador `>>>` realiza un desplazamiento lógico, independientemente del signo, siempre llenando los espacios vacíos con ceros.

### d.8 Operadores de concatenación y repliicación

Los operadores de concatenación se utilizan para combinar varios operandos en una sola palabra de datos. Estos operadores **son útiles cuando se necesita construir una señal más grande a partir de señales más pequeñas** o cuando se desea agrupar múltiples señales en una sola variable. 

1. **Concatenación (`{}`)**:
   - **Descripción**: Permite combinar varios operandos en una sola señal. Los operandos se concatenan en el orden en que aparecen dentro de las llaves.
   - **Ejemplo**: Si `a` es una señal de 4 bits (`4'b1010`) y `b` es una señal de 8 bits (`8'b11001100`), la concatenación horizontal `{a, b}` dará como resultado una señal de 12 bits, con el valor `12'b101011001100`.

2. **Replicación (`{N{op}}`)**:
   - **Descripción**: Permite replicar un operando un número especificado de veces. El operando se repite `N` veces para formar una señal de tamaño adecuado.
   - **Ejemplo**: La replicación `{4{1'b0}}` crea una señal de 4 bits, todos con valor `0`, resultando en `4'b0000`..

### d.10 Operador condicional

Este operador evalúa una condición y selecciona uno de dos valores posibles basados en el resultado de esa condición.

**Sintáxis**

> condicion ? valor_si_verdadero : valor_si_falso;

Primero se evalúa condición. Si el resultado de evaluar condicion es verdadero, se devuelve el valor de valor_si_verdadero, caso contrario, se devuelve valor_si_falso.

**Ejemplo**: Se le asigna c a resultado si a es mayor que b, y d en caso contrario.

~~~verilog
assign resultado = (a>b) ? c : d;
~~~


### d.11 Prioridad


| Prioridad | Operador                | Tipo de Operador        | Descripción                                      |
|-----------|-------------------------|-------------------------|--------------------------------------------------|
| 1         | `()`                    | Paréntesis              | Agrupa expresiones para alterar la prioridad     |
| 2         | `+`, `-`, `~`           | Unario                  | Negación unaria y signo positivo/negativo        |
| 3         | `**`                    | Aritmético              | Exponentes (aunque poco común en Verilog)       |
| 4         | `*`, `/`, `%`           | Aritmético              | Multiplicación, división y módulo                |
| 5         | `+`, `-`                | Aritmético              | Suma y resta                                     |
| 6         | `<<`, `>>`, `>>>`       | Desplazamiento          | Desplazamiento a la izquierda y derecha          |
| 7         | `<`, `<=`, `>`, `>=`, `==`, `!=` | Relacional        | Comparación de igualdad y relación               |
| 8         | `&&`, `\|\|`, `!`         | Lógico                  | Operadores lógicos AND, OR, y NOT                |
| 9         | `&`, ` \|`, `^`, `~^`, `^~` | Bitwise               | Operadores bitwise AND, OR, XOR, XNOR, NOT       |
| 10        | `{}`, `{N{op}}`         | Concatenación/Replicación | Concatenación de bits y replicación             |
| 11        | `? :`                   | Condicional             | Operador condicional (ternario)                  |

## e. Ejemplos 