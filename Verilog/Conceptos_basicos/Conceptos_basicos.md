# Conceptos básicos de Verilog

## a. Convenciones léxicas / Sintaxis 
Las convenciones léxicas usadas por Verilog HDL, son similares a las que se usan en el lenguaje de C.


### a.1 Whitespace
- `\b` blank space

- `\t` tabs

- `\n` newlines



### a.2 Comentarios

> // comentario en una sola línea

> /*  
    Comentarios de múltples lineas
*/

## a.3 Operadores

En verilog hay 3 tipos de operadores: `unary`, `biniry`, `ternary`

~~~verilog
a = ~ b;  // ~ es un operador unario

a = b && c; // && operador binario

a = b ? c : d ; // ?: es un operador ternario
~~~

## a.4 Especificación de número / Number Specification

### a.4.1 Sized NUmbers

```bash
<size>'<base><number>
```

- `<size>`: Especifica el número de bits del valor.
- `'`: Es un carácter literal que separa el tamaño de la base.
- `<base>`: Indica la base del número. Puede ser:
  - `b` o `B` para binario
  - `o` o `O` para octal
  - `d` o `D` para decimal
  - `h` o `H` para hexadecimal
- `<number>`: El valor del número en la base especificada.

Ejemplos:
~~~verilog
4'b1111 // Número de 4 bits  -  binario
12'habc // Número de 12 bits - hexadecimal
16'd255 // Número de 16 bits - decimal
~~~

### a.4.2 Unsized numbers

- Los números que se especifican sin la instrucción de `<base format>` se consideraran como decimales por default.

- Los números que se especifican sin `<size>` se consideran por default como un numero de **32 bits**.

Ejemplos:

~~~verilog
23456   // Número de 32 bits decimal
'hc3    // Número de 32 bits hexadecimal
'o21    // Número de 32 bits octal
~~~

### a.4.3 Valores de X (unknow) o Z (alta impedancia) 

Estos valores son importantes para modelar circuitos reales.

El valor de **X** se utiliza para indicar un valor desconocido de una señal. Lo cual puede ocurrir cuando:

- Una señal no está inicializada.
- Hay un conflicto en las señales de entrada (por ejemplo, cuando dos conductores están tratando de conducir la misma línea a diferentes valores).
- Hay un comportamiento indefinido en el  circuito.

El valor de **Z** representa un estado de alta impedancia (flotante o desconectado). Este estado es comúnmente utilizado en busesy circuitos tri-state.

Ejemplos:
~~~verilog
12'h13x // Número de 12 bits hexadecimal  los últimos 4 bits son desconocidos.
6'hx    // Número de 6 bits hexadecimal. 
32'bz   // Número de 32 bits binarios de alta impedancia
~~~

Si el MSB es X, los bits más significativos se llenarán con X. Si el MSB es z, los bits más significativos se llenarán con z. Si el MSB es 0, los bits más significativos se llenarán con 0.

Ejemplos:

- El número X3A
    - `X` se extiende a `XXXX` (4 bits de X).
    - `3` se extiende a `0011`.
    - `A` se extiende a `1010`.

- El número z5C
    - `z` se extiende a `zzzz` (4 bits de z).
    - `5` se extiende a `0101`.
    - `C` se extiende a `1100`.

### a.4.4 Números Negativos

Se debe poner el signo del **-** delante de la especificación.

Ejemplo:

~~~verilog
-6'd3   // Número de 6  bits que almacena el complemento a 2 del número 3 en binario.
~~~

### a.4.5 Underscore and question marks

- Los caracteres underscore son permitidos en Verilog con el objeto de mejorar la legibilidad del código. De igual manera son ignorados por el compilador. 

- EL signo de interrogación **?** es una alternativa para Z en el contexto de números. 

Ejemplos:

~~~verilog
12'b1111_0000_1010  // Se usa para mejorar la legibilidad del código
4'b10?? // Equivalente a escribir 4'b10zz
~~~

### a.4.5 Strings

Los strings se deben escribir dentro de comillas dobles " ".

Ejemplo:

~~~verilog
"Hello world Verilog"
~~~

### a.4.6 Indentificadores y palabras claves

Ver apéndice C del libro.

### a.4.7 Identificadores de escape.

Lo identificadores de escape permiten utilizar caracteres en los nombres de identificadores que normalmente no serían permitidos. Esto **es útil cuando se necesita utilizar nombres que contienen espacios, caracteres especiales, palabras reservadas, o cualquier otra secuencia de caracteres que no cumpla con las reglas** estándar para nombres de identificadores.
**

**Reglas para los Escaped Identifiers**

- Comienzo: Deben comenzar con una barra invertida (`\`). 
- Contenido: Pueden contener cualquier carácter después de la barra invertida, incluidos espacios, caracteres especiales, y palabras reservadas 
- Finalización: **Terminan con un espacio en blanco o un salto de línea** que no forma parte del identificador.

Ejemplos:

~~~verilog
\mi identificador // es una variable con espacio en blanco

\signal$special#name // es una variable que tiene caracteres especiales en su nombre
~~~

## b. Tipos de datos
### b.1 Set de Valores

- **Valor de nivel**

| Strength Level | Type                               |
|----------------|------------------------------------|
| 0              | Logica zero, condición falsa       |
| 1              | Logica uno, condición verdadera    |
| x              | Valor desconocido                  |
| z              | Alta impedancia - estado flotante  |


- **Niveles de fortaleza**

Los niveles de fortaleza son una característica que permite modelar de manera más precisa el comportamiento eléctrico de las señales en un circuito digital.
Esto es especialmente útil en simulaciones donde se necesita replicar el comportamiento de hardware real con alta fidelidad.

| Strength Level | Type           | Degree    |
|----------------|----------------|-----------|
| supply         | Driving        | strongest |
| strong         | Driving        |           |
| pull           | Driving        |           |
| large          | Storage        |           |
| weak           | Driving        |           |
| medium         | Storage        |           |
| small          | Storage        |           |
| highz          | High Impedance | weakest   |

**Driving Strengths**

- **`supply`**: La fortaleza más alta, utilizada para representar fuentes de alimentación.

- **`strong`**: Fortaleza alta, típica para representar salidas de puertas lógicas.
- **`pull`**: Fortaleza media-baja, utilizada para representar resistencias de pull-up o pull-down.

- **`weak`**: Fortaleza baja, usada para señales débiles, como salidas de transistores débiles.

- **`highz`**: Representa un estado de alta impedancia (tri-state), efectivamente desconectado.

Ejemplo:

~~~verilog
// Especificando niveles de fortaleza para una puerta NOT
not (strong1, weak0) u1 (out, in);

// Especificando un driver con diferentes fortalezas
trireg (weak1, strong0) signal; // La señal 'signal' tiene una fortaleza 'weak1' cuando es '1' y 'strong0' cuando es '0'
~~~

La explicación proporcionada aborda cómo se resuelven las contenciones de señales en Verilog cuando diferentes niveles de fortaleza (strength levels) están involucrados. Aquí está la explicación detallada:


**Resolución de Contenciones de Señales: Contención de Señales con Fortalezas Desiguales:**
   - **Regla:** Si dos señales con fortalezas desiguales se conducen en un mismo cable (wire), la señal más fuerte prevalece.
   - **Ejemplo:** Si una señal con fortaleza `strong1` (valor lógico 1 con alta fortaleza) y otra señal con fortaleza `weak0` (valor lógico 0 con baja fortaleza) se encuentran, el resultado será `strong1`. La señal fuerte (strong1) domina sobre la débil (weak0).

**Contención de Señales con Igual Fortaleza:**
   - **Regla:** Si dos señales con igual fortaleza se conducen en un mismo cable, el resultado es desconocido.
   - **Ejemplo:** Si dos señales `strong1` (valor lógico 1 con alta fortaleza) y `strong0` (valor lógico 0 con alta fortaleza) se encuentran, el resultado será `X`, que indica un estado indefinido o de contención.

**Utilidad de los Niveles de Fortaleza**

Los niveles de fortaleza son particularmente útiles para el modelado preciso de:
- Contención de Señales: Permiten simular cómo diferentes señales compiten por el control de un nodo.
- Dispositivos MOS y MOS Dinámicos: Facilitan la simulación de dispositivos semiconductores a nivel de transistor, donde la fortaleza de las señales puede variar.
- Dispositivos de Bajo Nivel: Ayudan a representar dispositivos electrónicos que tienen comportamientos específicos según las fortalezas de las señales.

**Niveles de Fortaleza en Redes de Almacenamiento (trireg nets)**

Solo las redes `trireg` pueden tener fortalezas de almacenamiento (storage strengths) como:
- **large**
- **medium**
- **small**

Estas fortalezas permiten modelar la capacidad de una señal para retener un valor lógico, emulando comportamientos de almacenamiento en circuitos electrónicos.


### b.2 Nets

Los nets representan conexiones entre los elementos de un hardware. Se suelen declarar como variables **wire**. Los nets son variables de un bit de valor y de tipo **Z** (exepto los trireg net) por default.

Tipos de variables que son consideradas como nets

- **wire**
- **wand**
- **wor**
- **tri** 
- **triand**
- **trior**
- **trireg**

### b.3 Registros

Los registros son elementos de almacenamiento de datos. Este tipo de registro, no es el registro construido con FF's en hardware.

El valor por defecto de un reg es X.

~~~verilog
reg reset; // declara una variable reset del tipo reg/registro
initial
    begin
        reset = 1'b1; // iniciliza el registro en 1
        #100 reset = 1'b0; // depues de 100 unidades de tiempo, se resetea a 0
    end
~~~

### b.4 Integer, Real y Tipos de Registros de datos de tiempo

- **Integer:** Las variables enteras en Verilog se utilizan para contar y realizar operaciones aritméticas generales. Por defecto, son de 32 bits de ancho.
    ~~~verilog
    integer counter;
    initial
        counter = -1; // Se pueden declarar valores negativos
    ~~~

- **Real:** Las variables de tipo real se utilizan para cálculos de punto flotante. Aunque son menos comunes en la descripción de hardware, son útiles en los bancos de pruebas (testbenches) para simulaciones.
    ~~~verilog
    real delta; 
    initial
        begin
            delta = 4e10; // se le asigna a delta la notación cientifica
            delta = 2.13; // delta toma el valor fraccionario real
        end
    
    integer i; 
    initial
        i = delta; // i toma el valor de 2 debido al redondeo
    ~~~
- **Time:** El tipo time se utiliza para almacenar valores de tiempo de simulación. Es útil para medir intervalos de tiempo en los bancos de pruebas.
    ~~~verilog
    time save_sim_time;
    initial
        save_sim_time = $time;
    ~~~

### b.5 Vectores

Los vectores en Verilog son una secuencia de bits organizados en una sola dimensión. Básicamente, son una extensión de la definición de un solo bit (reg o wire) a múltiples bits.

Los tipos de datos nets o reg, pueden ser declarados como vectores. Para declarar un vector se puede usar la connotación **[high, low]** ó **[low, high]**, pero siempre el número de la izquierda es el bit mas significativo. 

Ejemplos:

~~~verilog
wire [7:0] bus; // variable bus del tipo wire de 8 bits
wire [31:0] busA, busB // buses de 32 bits
reg [0:40] virtual_addr; // vector vritual_addr de 41 bits
~~~

Es posible direccionar bits o partes de los vectores

~~~verilog
busA[7]; // bit número 7 del vector busA
bus[2:0] // Los 3 bits menos significativos del vector bus
virtual_addr[0:1] // Los dos bits mas significativos del vector virtual_addr
~~~

### b.6 Arreglos/arrays

Los arreglos en Verilog son una colección de elementos del mismo tipo, organizados en una secuencia o una matriz. Se pueden tener arreglos de bits, de registros, de enteros, etc.

En Verilog se permite hacer arreglos de tipo ***reg, integer, time, vector***.

Ejemplo:

~~~verilog
integer count[0:7]; // Arreglo de 8 bits  de tipo integer

reg bool[31:0];    // Arreglo de 32 bits de tipo reg

time check_point[1:100];

reg [4:0] port_id[0:7]; // Arreglo de 8 port_id; cada port_id contiene 5 bits de ancho

integer matriz [4:0][4:0]   // Expresión ilegal de declaración de una matriz
~~~

### b.7 Memorias

Las memorias en Verilog son un arreglo de registros. Cada elemento del arreglo es conocido como una word/palabra. 

~~~verilog
reg mem1bit [0:1023]; // Memoria mem1bit de 1K de 1-bit words

reg [7:0] membyte[0:1023]; // Memoria membytecon 1k de 8-bits words

~~~

### b.8 Parámetros 

Verilog permite usar constantes deifnidas en un modulo con la palabra clave/keyword **parameter**. 

~~~verilog
parameter port_id = 5;  // Define una constante port_id 
parameter cache_line_with = 256;
~~~

### b.8.1 defparam

La palabra clave defparam se utiliza para modificar los parámetros de un módulo instanciado después de su declaración. 

~~~verilog
module contador #(parameter WIDTH = 8) (
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else
            count <= count + 1;
    end
endmodule

module top;
    wire [15:0] count1;
    wire [7:0] count2;

    contador contador_inst1 (
        .clk(clk),
        .rst(rst),
        .count(count1)
    );
    contador contador_inst2 (
        .clk(clk),
        .rst(rst),
        .count(count2)
    );
    // Uso de defparam para cambiar los parámetros de la instancia
    defparam contador_inst1.WIDTH = 16;
endmodule
~~~

### b.9 Strings

Los strings se pueden almacenar de un registro. EL ancho del registro debe ser lo suficientemente largo como para almacenar el string completo. **Cada caracter de un string pesa 8 bits (1 byte)**. Si el ancho del registro es mayor que el largo del string, el compilador lleno el resto de contenido a la izquierda de ceros. 

~~~verilog
reg [8*18:1] string; // Declara una variable de 18 bytes de ancho
initial
    string = "Hello Verilog World";
~~~

### b.9.1 Caracteres especiales en string

| Escaped Characters | Character Displayed               |
|--------------------|-----------------------------------|
| `\n`                 | newline                           |
| `\t`                 | tab                               |
| `%%`                 | %                                 |
| `\\`                 | \                                 |
| `\"`                 | "                                 |
| `\ooo`               | Character written in 1–3 octal digits |


## c. System task y Compile directives

Todas las system task de Verilog aparecen de la forma **`$keyword`**

### c.1 System Task 

- **\$display:** Es la principal system task para mostrar valores de las variables, strings o expresiones. 

| Format   | Display                                                   |
|----------|-----------------------------------------------------------|
| %d or %D | Display variable in decimal                                |
| %b or %B | Display variable in binary                                 |
| %s or %S | Display string                                             |
| %h or %H | Display variable in hex                                    |
| %c or %C | Display ASCII character                                    |
| %m or %M | Display hierarchical name (no argument required)           |
| %v or %V | Display strength                                           |
| %o or %O | Display variable in octal                                  |
| %t or %T | Display in current time format                             |
| %e or %E | Display real number in scientific format (e.g., 3e10)      |
| %f or %F | Display real number in decimal format (e.g., 2.13)         |
| %g or %G | Display real number in scientific or decimal, whichever is shorter |

- **\$monitor, \$monitoron, \$monitoroff:** Verilog provee un mecanismo para monitorear una señal cuando el valor tiende a cambiar. 

- **$stop:** Pone la simulación en estado interactivo. Se puede debuggear el programa en este modo.

- **$finish:** Finaliza la simulación.

Ademas existen:

- **\$write, \$strobe**: Para imprimir texto en la consola.

- **\$time, \$stime, \$realtime**: Para obtener el tiempo de simulación.

- **$random**: Para generar números aleatorios.

- **\$readmemb, \$readmemh**: Para leer datos de archivos en formato binario o hexadecimal.


### c.2 Directivas del compilador 

- **`define**: Se utiliza para definir macros de preprocesador. Estas macros pueden ser constantes, nombres simbólicos para bloques de código, o cualquier texto que se requiera reutilizar a lo largo de tu código. El uso de define facilita la modificación y mantenimiento del código, ya que permite cambiar un valor o una secuencia de texto en un solo lugar, en lugar de tener que hacerlo en múltiples ubicaciones.

~~~verilog
// Se utiliza para definir una variable
`define WORD_SIZE 32

// definir un alias
`define S $stop

// deifnir un texto de uso común en el código

`define WORD_REG reg [31:0]
~~~

- **`ifdef (If Defined):** Comprueba si un simbolo o macro esta definido.

~~~verilog
`ifdef MY_MACRO
// Código que se incluye si MY_MACRO está definido
`endif
~~~

- **ifndef (If not Defined):** Comprueba si un símbolo no esta definido. 

~~~verilog
`ifndef MY_MACRO
// Código que se incluye si MY_MACRO no está definido
`endif
~~~

- **undef:** Elimina la definición de un símbolo (macro)

~~~verilog
`undef MY_MACRO
~~~

- **else:** Se usa en combinación con ifdef o ifndef. 

~~~verilog
`ifdef MY_MACRO
// Código si MY_MACRO está definido
`else
// Código si MY_MACRO no está definido
`endif
~~~

- **elseif (Else if):** Similar a else, pero se usa para proporcionar un bloque de código alternativo.

~~~verilog
`ifdef MACRO1
// Código si MACRO1 está definido
`elsif `MACRO2
// Código si MACRO2 está definido
`else
// Código si ni MACRO1 ni MACRO2 están definidos
`endif
~~~

- **`include:** Se utiliza para incluir código de otros archivos como en el lenguaje C

~~~verilog
`include "sumador.v"
~~~

- **timescale:** Define la unidad de tiempo y la precisión de la simulación. 
En este ejemplo, **1ns** es la unidad de tiempo y **1ps** es la precisión. Esto significa que las operaciones temporales en el código se interpretarán en nanosegundos, y la simulación será precisa hasta los picosegundos.

~~~verilog
`timescale 1ns/1ps
~~~