# Aleatorización/"randonmización" en SV

La **randomización** en SystemVerilog es un proceso clave en la creación de pruebas de verificación funcional para dispositivos bajo prueba (DUT). Permite generar estímulos variados de manera automática para abarcar una gran cantidad de casos de prueba, lo cual es crucial para identificar errores y asegurar la robustez del diseño.

- **CRT (Constrained Random Testing)**

El **CRT** o **Constrained Random Testing** es una técnica que consiste en aplicar randomización con restricciones o condiciones específicas. En lugar de generar valores completamente al azar, se definen ciertos límites o reglas (constraints) para mantener los valores dentro de un rango o cumplir con ciertos criterios. Esto es útil cuando no todos los valores posibles son válidos o interesantes para la verificación. 

El CRT se basa en dos elementos clave: el código de prueba que genera entradas aleatorias al DUT y una semilla para el generador de números pseudoaleatorios (PRNG). Cambiar la semilla permite que una sola prueba CRT funcione como muchas pruebas dirigidas, al variar las combinaciones de estímulos. Para garantizar que se cubran todos los aspectos del diseño, aunque el espacio de posibles entradas es vasto, se utiliza la cobertura funcional para medir el progreso y la eficacia de las pruebas, lo que se explica en capítulos posteriores.

- **PRNG (Pseudo-Random Number Generator)**

El **PRNG** o **Pseudo-Random Number Generator** es un algoritmo que genera secuencias de números que aparentan ser aleatorios, pero que en realidad son deterministas, ya que dependen de una semilla inicial. En verificación, los **PRNGs** permiten reproducir secuencias de estímulos al utilizar la misma semilla, lo que es crucial para la depuración cuando se encuentra un error.

El PRNG es la base para generar los valores aleatorios utilizados en SystemVerilog y otros lenguajes de verificación. Aunque los números son pseudoaleatorios, su uso combinado con restricciones (CRT) proporciona una manera eficiente y controlada de explorar el espacio de pruebas.

**Que randomizar?**

Cuando se aleatoriza el estímulo para un diseño, lo más fácil es comenzar con los **campos de datos**, pero esto solo encuentra errores menores, como los de la ruta de datos o errores a nivel de bits, y la prueba sigue siendo mayormente dirigida. Los errores más difíciles de encontrar están en la **lógica de control**.

Para mejorar la cobertura, necesitas aleatorizar todos los **puntos de decisión** en tu DUT, aumentando la probabilidad de tomar diferentes caminos de control en cada prueba. Debes aleatorizar varias entradas del diseño, como:

- **Configuración del dispositivo**
- **Configuración del entorno**
- **Datos de entrada principales**
- **Datos de entrada encapsulados**
- **Excepciones del protocolo**
- **Retrasos**
- **Estado de transacciones**
- **Errores y violaciones**

Esto maximiza la posibilidad de encontrar errores difíciles de detectar.

## a. Aleatorización

La generación de estímulos aleatorios en SystemVerilog es más útil cuando se utiliza con OOP. Primero se crea una clase para contener un grupo de variables aleatorias relacionadas, y luego se hace que el random-solver las llene con valores aleatorios. Se puenden crear constraints para limitar los valores aleatorios a valores legales o a características específicas de la prueba.

```verilog
// Ejemplo 6.1
class Packet;
    // The random variables
    rand bit [31:0] src, dst, data[8]; 
    randc bit [7:0] kind;

    // Limit the values for src
    constraint c {
        src > 10;
        src < 15;
    }
endclass

Packet p;

initial begin
    p = new(); // Create a packet

    assert (p.randomize())
    else $fatal(0, "Packet::randomize failed");

    transmit(p);
end
```

Este código define una clase `Packet` con variables aleatorias (`rand` y `randc`) y una restricción (`constraint c`) que limita los valores de la variable `src` entre 10 y 15. Luego, en el bloque `initial`, se crea un objeto de la clase y se randomiza su contenido. Si la randomización falla, el programa termina con un mensaje de error.

- **`rand:`** Da un valor aleatorio a cada variable cada que se aleatoriza la clase. Puede repetir valores. 
- **`randc:`** `(aleatorización ciclica)` El random solver no repite un valor aleatorio hasta que se haya asignado cada valor posible. 
- **`constraints:`** es simplemente un conjunto de expresiones relacionales que deben ser verdaderas para el valor elegido de las variables. 
`Nota:` Nótese que la expresión del constraint está agrupada usando llaves: {}. Esto se debe a que este código es declarativo, no procedimental, que usa begin.. end.
- **`randomize():`** Es una función integrada de SV que asigna valores aleatorios a variables de la clase declaradas como `rand` o `randc`. Devuelve 0 si se encuentra un problema con los contraints. También se asegura de que se cumplan todas las contrainst activas

**Importante:**

- **No aleatorizar en el constructor**: Evita llamar a `randomize()` en el constructor de la clase. La razón es que la prueba puede necesitar modificar restricciones, cambiar pesos, o agregar nuevas restricciones antes de la aleatorización.
  
- **El propósito del constructor**: El constructor solo debe inicializar variables del objeto, y aleatorizar en esta etapa temprana puede generar resultados no deseados.
  
- **Variables aleatorias y públicas**: Todas las variables en las clases deben ser aleatorias y públicas para dar a la prueba el máximo control sobre el estímulo y el DUT. 

- **Controlar la aleatorización**: Se pueden desactivar variables aleatorias si es necesario, y evitar olvidarlas para no tener que modificar el entorno más adelante. 

## b. Constraints/restricciones

En el ámbito de la aleatorización (randomization) en SystemVerilog, **constraints** (restricciones) son condiciones que limitan o especifican los valores que pueden tomar las variables aleatorias durante el proceso de aleatorización. Los constraints ayudan a dirigir el proceso de generación de estímulos aleatorios para que se ajusten a las condiciones deseadas y sean válidos para el diseño bajo prueba (DUT).

**Propósito de los Constraints**:
   - **Guía la Aleatorización**: Definen el rango de valores o las relaciones entre variables aleatorias para que los estímulos generados sean realistas y relevantes para el DUT.
   - **Previene Valores No Válidos**: Aseguran que los valores generados cumplan con ciertas reglas o requisitos, evitando así la generación de datos que podrían ser inválidos o irrelevantes.

**Sintáxis**:
   - Los constraints se definen en la clase que contiene las variables aleatorias. Se utilizan bloques `constraint` para especificar las condiciones.
   - Por ejemplo:
     ```verilog
     class Packet;
       rand bit [31:0] src, dst;
       constraint c { src < dst; }
     endclass
     ```

**Tipos de Constraints**:
   - **Simples**: Pueden ser condiciones directas sobre valores, como `a > 10` o `b < 20`.
   - **Compuestos**: Pueden combinar múltiples condiciones, como `a > 10 && b < 20`.
   - **Condicionales**: Aplican restricciones solo cuando se cumplen ciertas condiciones, usando estructuras como `if` o `case`.

### b.1 Ejemplo introductorio

Este diseño permite configurar y controlar cómo se generan los estímulos aleatorios en función de la prueba de congestión, proporcionando flexibilidad para ajustar las condiciones de prueba según sea necesario.

```verilog
// Ejemplo 6.3

class Stim;
  // Constant value for congestion address
  const bit [31:0] CONGEST_ADDR = 42;

  // Enumerated type for different stimulus kinds
  typedef enum {READ, WRITE, CONTROL} stim_e;
  
  // Random cyclic variable for stimulus kind
  randc stim_e kind;

  // Random variables for length, source, and destination addresses
  rand bit [31:0] len, src, dst;

  // Flag for congestion test
  bit congestion_test;

  // Constraint block to limit the values of the random variables
  constraint c_stim {
    // Length must be between 1 and 999
    len < 1000;
    len > 0;

    // Conditional constraints based on congestion_test flag
    if (congestion_test) {
      // When congestion_test is true, destination must be within a specific range
      // and source must be equal to CONGEST_ADDR
      dst inside {[CONGEST_ADDR-100:CONGEST_ADDR+100]};
      src == CONGEST_ADDR;
    } else {
      // When congestion_test is false, source must be within specific ranges
      src inside {0, [2:10], [100:107]};
    }
  }
endclass
```

**Explicación**

1. **Constantes**:
   - `const bit [31:0] CONGEST_ADDR = 42;`: Define una constante llamada `CONGEST_ADDR` con un valor de `42`. Esta constante se utiliza en las restricciones para especificar un rango de direcciones.

2. **Tipo Enumerado**:
   - `typedef enum {READ, WRITE, CONTROL} stim_e;`: Define un tipo enumerado `stim_e` con tres posibles valores (`READ`, `WRITE`, `CONTROL`). Este tipo se usa para la variable `kind`, que representa el tipo de estímulo.

3. **Variables Aleatorias**:
   - `randc stim_e kind;`: Declara una variable `kind` de tipo `stim_e` que se aleatoriza de manera cíclica, es decir, recorre todos los valores posibles en un orden repetitivo.
   - `rand bit [31:0] len, src, dst;`: Declara tres variables aleatorias (`len`, `src`, `dst`) de tipo `bit [31:0]` para representar la longitud, la dirección de origen y la dirección de destino, respectivamente.

4. **Variable de Prueba de Congestión**:
   - `bit congestion_test;`: Declara una variable booleana que indica si se debe realizar una prueba de congestión.

5. **Bloque de Restricciones (`constraint c_stim`)**:
   - `len < 1000; len > 0;`: Restringe la longitud (`len`) para que esté entre `1` y `999`.
   - `if (congestion_test)`: Si `congestion_test` es verdadero:
     - `dst inside {[CONGEST_ADDR-100:CONGEST_ADDR+100]};`: Restringe el valor de `dst` a estar dentro del rango de `CONGEST_ADDR` menos 100 hasta `CONGEST_ADDR` más 100.
     - `src == CONGEST_ADDR;`: Restringe el valor de `src` a ser exactamente igual a `CONGEST_ADDR`.
   - `else`: Si `congestion_test` es falso:
     - `src inside {0, [2:10], [100:107]};`: Restringe el valor de `src` a estar dentro del conjunto `{0}`, el rango `[2:10]`, o el rango `[100:107]`.

### b.3 Expresiones simples

En SystemVerilog, al definir restricciones (`constraints`) para variables aleatorias, es importante seguir ciertas reglas para asegurar que las restricciones se evalúen correctamente y produzcan resultados esperados.

**Problema con Restricciones Mal Definidas**

En el **Ejemplo 6.4**, se intenta definir una restricción para tres variables `lo`, `med`, y `hi` en un solo paso usando una única expresión:

```verilog
// Ejemplo 6.6
class order;
  rand bit [7:0] lo, med, hi;
  constraint bad {lo < med < hi;} // Incorrecto
endclass
```

**Error en la Restricción**:
- En esta expresión, `lo < med < hi`, SystemVerilog no evalúa la restricción como se podría esperar. En su lugar, la expresión se descompone en múltiples comparaciones binarias de izquierda a derecha: `((lo < med) < hi)`.
  - Primero, `lo < med` se evalúa como una expresión binaria que produce 0 o 1.
  - Luego, `hi` se restringe a ser mayor que el resultado de `lo < med`, lo cual no es lo deseado.

**Resultados de la Restricción Incorrecta**:
Los resultados obtenidos en el **Ejemplo 6.5** no son los esperados debido a la forma en que se evaluó la restricción:

- `lo = 20, med = 224, hi = 164`
- `lo = 114, med = 39, hi = 189`
- `lo = 186, med = 148, hi = 161`
- `lo = 214, med = 223, hi = 201`

Estos resultados no cumplen con la restricción deseada porque el orden de las comparaciones no se respetó adecuadamente.

**Restricción Correcta**

```verilog
// Ejemplo 6.6
class order;
  rand bit [15:0] lo, med, hi;
  // Usa restricciones binarias separadas
  constraint good {
    lo < med;
    med < hi;
  }
endclass
```

- Aquí, las restricciones se definen de manera separada utilizando expresiones binarias:
  - `lo < med` asegura que `lo` sea menor que `med`.
  - `med < hi` asegura que `med` sea menor que `hi`.

Esto garantiza que `lo`, `med`, y `hi` estén en el orden correcto y produce resultados esperados donde cada variable está restringida adecuadamente.

### b.4 Expresiones de equivalencias

En SystemVerilog, los bloques de restricciones (`constraint blocks`) se utilizan para definir las condiciones que deben cumplir las variables aleatorias durante la aleatorización. Sin embargo, hay algunas limitaciones y errores comunes que deben evitarse:

**Error Común: Intentar Hacer Asignaciones en un Bloque de Restricción**

**Problema**:
- **Error Común**: Intentar usar asignaciones dentro de un bloque de restricciones. Por ejemplo, escribir `len = 42;` dentro del bloque de restricciones es incorrecto y dará lugar a errores.
- **Razón**: Los bloques de restricciones no están diseñados para realizar asignaciones directas. En su lugar, están destinados a contener expresiones que definen las relaciones y condiciones entre las variables aleatorias.

**Correcto**:
- **Uso del Operador de Equivalencia**: Para establecer el valor de una variable aleatoria dentro de un bloque de restricciones, se debe usar el operador de equivalencia `==` en lugar de `=`.
  - **Ejemplo Correcto**: `len == 42;`
  - Esto establece que la variable `len` debe ser igual a 42 durante la aleatorización.

**Construcción de Relaciones Complejas**

Los bloques de restricciones también permiten construir relaciones más complejas entre una o más variables aleatorias utilizando expresiones matemáticas o lógicas. Estos bloques pueden combinar varias variables para cumplir condiciones específicas.

**Ejemplo**:
- **Relaciones Complejas**: Puedes definir restricciones que impliquen relaciones matemáticas entre variables. Por ejemplo:
  - **Expresión**: `len == header.addr_mode * 4 + payload.size()`
  - Aquí, `len` debe ser igual al valor calculado a partir de `header.addr_mode` multiplicado por 4 más el tamaño de `payload`.

**Cómo Funciona**:
- **Operador de Equivalencia**: Utiliza `==` para definir las condiciones exactas que deben cumplirse. Este operador verifica si la variable cumple con el valor o la expresión dada.
- **Expresiones Complejas**: Puedes usar operaciones aritméticas o lógicas para relacionar varias variables. Esto permite definir restricciones más detalladas y específicas.

### b.5 Distribuciones de peso 

En SystemVerilog, el operador `dist` permite definir distribuciones ponderadas para variables aleatorias, especificando qué tan frecuentemente deben ser seleccionados ciertos valores durante la aleatorización. Esto es útil cuando se quiere controlar la probabilidad de que ciertos valores sean generados en comparación con otros.

**Uso del Operador `dist`**

- **Sintaxis**: 
  - `value dist {value1 := weight1, value2 := weight2, ...}` 
  - `value dist {range := weight, ...}` 
  - `value dist {value1 :/ weight, value2 :/ weight, ...}` 
  - `value dist {range :/ weight, ...}` 

- **Operador `:=`**: Asigna el mismo peso a todos los valores especificados en el rango. 
- **Operador `:/`**: Divide el peso especificado igualmente entre todos los valores en el rango.

- **Valores**: Pueden ser valores individuales o rangos (por ejemplo, `[lo:hi]`).
- **Pesos**: No tienen que sumar 100 y no son porcentajes; simplemente indican la probabilidad relativa.

**Ejemplo de Código**

```verilog
// Ejemplo 6.7
rand int src, dst;

constraint c_dist {
  // Distribución de pesos para 'src'
  src dist {
    0 := 40,         // El valor 0 tiene un peso de 40
    [1:3] := 60      // El rango [1:3] tiene un peso total de 60, distribuido entre 1, 2, y 3
    // Por lo tanto, los pesos relativos son:
    // src = 0, peso = 40 / (40 + 60) = 40 / 100
    // src = 1, peso = 60 / (40 + 60) = 60 / 100
    // src = 2, peso = 60 / (40 + 60) = 60 / 100
    // src = 3, peso = 60 / (40 + 60) = 60 / 100
  }

  // Distribución de pesos para 'dst'
  dst dist {
    0 :/ 40,        // El valor 0 tiene un peso total de 40 dividido entre 4 (ya que hay 4 valores en total)
    [1:3] :/ 60     // El rango [1:3] tiene un peso total de 60, distribuido igualmente entre 1, 2, y 3
    // Por lo tanto, los pesos relativos son:
    // dst = 0, peso = 40 / (40 + 60) = 40 / 100
    // dst = 1, peso = 60 / (60 + 60) * (1/3) = 20 / 100
    // dst = 2, peso = 60 / (60 + 60) * (1/3) = 20 / 100
    // dst = 3, peso = 60 / (60 + 60) * (1/3) = 20 / 100
  }
}
```

**Explicación del Ejemplo**

- **Para `src`**:
  - El valor `0` tiene un peso de 40.
  - El rango `[1:3]` tiene un peso total de 60, que se distribuye igualmente entre `1`, `2`, y `3`.
  - Esto significa que `0` tiene una probabilidad relativa más alta de ser seleccionado en comparación con los valores del rango `[1:3]`.

- **Para `dst`**:
  - El valor `0` tiene un peso total de 40, distribuido entre todos los valores posibles (`0`, `1`, `2`, y `3`), resultando en un peso de `40/100` para `0`.
  - El rango `[1:3]` tiene un peso total de 60, que se divide igualmente entre los valores `1`, `2`, y `3`, resultando en un peso de `20/100` para cada uno de esos valores.

**Distribuciones dinámicas**

En SystemVerilog, los pesos para las distribuciones aleatorias pueden ser constantes o variables, lo que proporciona flexibilidad en la generación de estímulos de prueba. Esto permite ajustar las distribuciones en tiempo de simulación para adaptarse a diferentes necesidades de verificación.

**Ejemplo:**

```verilog
// Ejemplo 6.7

// Clase que representa una operación de bus
class BusOp;
  // Tipo de longitud de operando
  typedef enum {BYTE, WORD, LWRD} length_e;
  rand length_e len; // Variable aleatoria que define la longitud de la operación

  // Pesos para la constraint de distribución
  bit [31:0] w_byte = 1, w_word = 3, w_lwrd = 5;

  constraint c_len {
    len dist {
      BYTE := w_byte,  // El valor BYTE tiene un peso de 1
      WORD := w_word,  // El valor WORD tiene un peso de 3
      LWRD := w_lwrd   // El valor LWRD tiene un peso de 5
    };
  }
endclass
```

**Explicación:**

- **Variables Aleatorias**:
  - `len` es una variable aleatoria de tipo enumerado (`length_e`) que puede tomar uno de los valores: `BYTE`, `WORD`, o `LWRD`.

- **Pesos Variables**:
  - Los pesos (`w_byte`, `w_word`, `w_lwrd`) determinan la probabilidad de selección de cada valor de `len`.
  - `w_byte` tiene un peso de 1.
  - `w_word` tiene un peso de 3.
  - `w_lwrd` tiene un peso de 5.
  - Debido a estos pesos, `LWRD` (longword) tiene la mayor probabilidad de ser seleccionado, seguido por `WORD`, y luego `BYTE`.

- **Distribución Dinámica**:
  - Los pesos pueden ser variables y cambiar durante la simulación. Esto permite ajustar dinámicamente la distribución de valores.
  - Por ejemplo, si se desea que `BYTE` tenga una mayor probabilidad en un momento dado, el peso `w_byte` puede incrementarse mientras que se puede reducir el peso de `WORD` o `LWRD`.

- **Modificación de Pesos**:
  - Los pesos no tienen que ser constantes; pueden ser modificados sobre la marcha para obtener diferentes distribuciones durante la simulación.

Este enfoque proporciona una poderosa herramienta para la generación de estímulos en pruebas automatizadas, haciendo que los casos de prueba sean más flexibles y adaptables a diferentes situaciones.


### b.6. Membresías y el operador `inside`

En SystemVerilog, los conjuntos de valores y los rangos se pueden usar para definir restricciones en las variables aleatorias, lo que proporciona flexibilidad en la generación de estímulos.

**Uso del Operador `inside`**

El operador `inside` se utiliza para definir un conjunto de valores permitidos para una variable aleatoria. El solucionador de SystemVerilog selecciona aleatoriamente un valor del conjunto con igual probabilidad, a menos que existan otras restricciones que modifiquen esta probabilidad.

**Ejemplo 6.9: Conjuntos Aleatorios de Valores**

```verilog
// Ejemplo 6.9

rand int c; // Variable aleatoria
int lo, hi; // Variables no aleatorias usadas como límites

constraint c_range {
  c inside {[lo:hi]}; // c debe estar en el rango de lo a hi
}
```

- **Variables Aleatorias y No Aleatorias**:
  - `c` es una variable aleatoria cuyo valor se restringe a un rango definido por las variables `lo` y `hi`.
  - `lo` y `hi` son variables que no cambian aleatoriamente y definen el límite del rango de valores permitidos para `c`.

- **Uso de Rangos**:
  - El operador `inside` asegura que `c` se mantenga dentro del rango `[lo:hi]`.
  - Si `lo` es mayor que `hi`, se forma un conjunto vacío, y la constraint no se puede cumplir, lo que hace que la aleatorización de `c` falle.

**Uso de los Valores Mínimo y Máximo con `$**

El símbolo `$` se puede usar como un atajo para especificar valores mínimos y máximos en rangos. Esto es útil para simplificar las constraints cuando se trabajan con diferentes rangos de valores.

**Ejemplo 6.10: Especificando Rango Mínimo y Máximo con `$**

```verilog
rand bit [6:0] b; // 0 <= b <= 127
rand bit [5:0] e; // 0 <= e <= 63

constraint c_range {
  b inside {[$:4], [20:$]}; // 0 <= b <= 4 || 20 <= b <= 127
  e inside {[$:4], [20:$]}; // 0 <= e <= 4 || 20 <= e <= 63
}
```

- **Definición de Rangos**:
  - `[$:4]` representa el rango desde el valor mínimo posible de `b` hasta 4.
  - `[20:$]` representa el rango desde 20 hasta el valor máximo posible de `b`.

- **Uso de `$`**:
  - El uso de `$` simplifica la definición de rangos cuando se necesita especificar los límites inferior o superior sin conocer el valor exacto.

**Invertir el Conjunto Aleatorio con `!`**

El operador `!` (NOT) puede usarse para definir restricciones que excluyen ciertos conjuntos de valores. Esto es útil cuando se quiere que una variable tome cualquier valor, excepto los especificados en un conjunto.

**Ejemplo 6.11: Constraint Invertido**

```verilog
constraint c_range {
  !(c inside {[lo:hi]}); // c no debe estar en el rango de lo a hi
}
```

- **Inversión de la Constraint**:
  - `!(c inside {[lo:hi]})` asegura que `c` no tome valores dentro del rango `[lo:hi]`.
  - Este enfoque permite especificar que ciertos valores son indeseables sin tener que enumerar todos los valores válidos explícitamente.

**Resumen**

- **`inside`**: Utilizado para definir un conjunto de valores permitidos para una variable aleatoria.
- **`$`**: Atajo para definir valores mínimos y máximos en rangos.
- **`!`**: Utilizado para excluir valores específicos en las constraints.

### b.7 Arreglo de distribuciones

El concepto **"Using an Array in a Set"** en SystemVerilog te permite seleccionar valores aleatorios de un conjunto almacenado en un arreglo. En lugar de tener que especificar manualmente cada valor permitido, puedes almacenar esos valores en un arreglo y usar el operador `inside` para definir restricciones que seleccionen entre esos valores.

Voy a analizar y explicar un ejemplo simple, **Sample 6.12**, para que puedas entender el concepto claramente.

**Ejemplo 6.12: Constraint Aleatoria con un Arreglo**

```verilog
// Ejemplo 6.12

rand int f; // Variable aleatoria
int fib[5] = {1,2,3,5,8}; // Arreglo de números de Fibonacci

constraint c_fibonacci {
  f inside fib; // f debe ser uno de los valores en el arreglo fib
}
```

**Explicación**:

- **Variable Aleatoria**: La variable `f` es una variable aleatoria, lo que significa que su valor será determinado aleatoriamente durante la simulación.
  
- **Arreglo**: `fib` es un arreglo que contiene una serie de valores (en este caso, los números de Fibonacci `{1, 2, 3, 5, 8}`).

- **Restricción**: La restricción `f inside fib` indica que el valor aleatorio que se le asignará a `f` debe estar dentro del conjunto de valores almacenados en el arreglo `fib`.

Esto significa que durante la simulación, `f` solo puede tomar los valores 1, 2, 3, 5 o 8. El operador `inside` simplifica la selección de valores permitidos, en lugar de escribir múltiples comparaciones.

**Equivalente Manual del Ejemplo 6.13**:

Para entender mejor cómo funciona el operador `inside`, veamos el código equivalente en el Ejemplo 6.13, que es lo que sucede internamente:

```verilog
constraint c_fibonacci {
  (f == fib[0]) || // f == 1
  (f == fib[1]) || // f == 2
  (f == fib[2]) || // f == 3
  (f == fib[3]) || // f == 5
  (f == fib[4]);   // f == 8
}
```

Este código es una expansión manual de la restricción `inside`, que verifica que `f` sea igual a alguno de los elementos del arreglo `fib`. El operador `inside` hace todo esto automáticamente, reduciendo el código y haciéndolo más fácil de leer.

**Aplicación Práctica**

Este enfoque es útil en situaciones donde se requiere elegir aleatoriamente entre un conjunto predefinido de opciones, como en sistemas donde ciertos parámetros pueden tomar solo valores específicos. Por ejemplo, podrías usar este concepto para simular diferentes longitudes de paquetes de datos en una red (si los tamaños permitidos son, por ejemplo, 64, 128, y 256 bytes) o para seleccionar entre comandos válidos en una secuencia de operaciones de bus.

Este método te permite generar estímulos dinámicos sin necesidad de reescribir las restricciones cada vez que cambian los valores permitidos.

### b.8 Constraints condicionales

En SystemVerilog, normalmente todas las expresiones de constraint están activas, lo que significa que se aplican siempre que el solucionador de restricciones intenta generar valores aleatorios. Sin embargo, a veces necesitas que una expresión de constraint esté activa solo bajo ciertas condiciones, como cuando hay diferentes tipos de operaciones que implican restricciones diferentes. Para manejar estos casos condicionales, SystemVerilog proporciona dos operadores: `->` (implicación) e `if-else`.

**Operador de Implicación (`->`)**

El operador de implicación (`->`) funciona como un condicional que actúa de forma similar a un bloque `case`, donde una expresión condicional controla si otra restricción es aplicable o no. Es útil cuando tienes una lista de opciones entre las que elegir, como en un tipo enumerado o un modo de operación.

**Ejemplo 6.19: Bloque de restricción con operador de implicación**

```verilog
class BusOp;
  ...
  constraint c_io {
    (io_space_mode) -> addr[31] == 1'b1;
  }
```

**Explicación**:

- **Condición**: La restricción dice que **si** `io_space_mode` es verdadero, entonces el bit 31 de `addr` debe ser `1'b1` (es decir, un `1` binario). Si `io_space_mode` es falso, la restricción en `addr[31]` no se aplicará.

Este tipo de restricción es útil cuando tienes diferentes modos de operación y quieres imponer diferentes reglas dependiendo del modo actual.

Por ejemplo, en este caso, si el bus está en modo de espacio de entrada/salida (`io_space_mode`), se activa la restricción que establece que el bit 31 de la dirección debe ser un 1. Si no está en este modo, el valor del bit 31 no está restringido.

**Operador `if-else`**

El operador `if-else` es más adecuado cuando tienes una expresión que puede evaluarse como verdadera o falsa, y quieres aplicar una restricción diferente para cada caso.

**Ejemplo 6.20: Bloque de restricción con operador if-else**

```verilog
class BusOp;
  ...
  constraint c_len_rw {
    if (op == READ)
      len inside {[BYTE:LWRD]};
    else
      len == LWRD;
  }
```

**Explicación**:

- **Condición**: Aquí, la restricción depende del valor de la variable `op`. Si `op` es igual a `READ`, entonces la longitud (`len`) puede ser cualquier valor entre `BYTE` y `LWRD` (longitud de una palabra larga). Sin embargo, si `op` no es igual a `READ`, entonces la longitud debe ser exactamente igual a `LWRD`.

Este uso de `if-else` permite aplicar diferentes restricciones para diferentes tipos de operaciones. En este caso, cuando se trata de una operación de lectura (`READ`), se permiten varias longitudes de datos. Para otros tipos de operaciones (como escritura), la longitud debe ser fija (una palabra larga en este caso).

**Diferencia entre `->` e `if-else`**

- **`->` (implicación)**: Se usa cuando tienes una condición y quieres que **solo bajo esa condición** se aplique otra restricción. Funciona como un bloque `case`, donde una condición activa o desactiva una restricción.
  
- **`if-else`**: Es más adecuado cuando quieres evaluar una condición verdadera/falsa y aplicar una de dos posibles restricciones dependiendo del resultado.

**Uso de Bloques de Restricciones**

Cuando necesitas agrupar varias restricciones, puedes usar llaves `{}` en lugar de `begin...end` como lo harías en el código procedimental. Las llaves se utilizan para agrupar múltiples expresiones dentro de un bloque de restricciones.

**Resumen**

- El operador `->` se usa para aplicar una restricción solo si una condición es verdadera, similar a un `case`.
- El operador `if-else` se utiliza cuando quieres aplicar restricciones diferentes según si una condición es verdadera o falsa.
- Ambos operadores permiten aplicar restricciones condicionales y hacer que el proceso de generación de valores sea más dinámico y controlado en función de las circunstancias del diseño o la operación.


### b.9 Constraints bidireccionales

En SV cabe recalcar un aspecto importante del funcionamiento de las **constraints** (restricciones) en **SystemVerilog**: no funcionan como código procedimental que se ejecuta de arriba hacia abajo, sino que son **declarativas** y se resuelven todas al mismo tiempo de forma **simultánea y bidireccional**.

**Principales conceptos**

1. **Código declarativo y concurrente**:
   - Las constraints en SystemVerilog no se ejecutan de manera secuencial como si fueran instrucciones que siguen un flujo de control (de arriba hacia abajo). En lugar de eso, son **declarativas** y todas las restricciones que apliques sobre una o varias variables están **activas al mismo tiempo**. 
   - Por ejemplo, si aplicas una restricción que limita una variable a un rango (`inside [10:50]`) y luego otra que la obliga a ser mayor que 20 (`> 20`), el solucionador de constraints resolverá ambas simultáneamente, eligiendo un valor que cumpla ambas restricciones. En este caso, solo los valores entre 21 y 50 serían válidos.

2. **Constraints bidireccionales**:
   - Las restricciones en SystemVerilog son **bidireccionales**, lo que significa que el solucionador evalúa todas las variables relacionadas simultáneamente. Esto no es como un flujo "unidireccional" en el que una variable se resuelve primero y luego se resuelven las demás en función de ella.
   - Por ejemplo, si tienes una relación entre varias variables, el valor de cada variable puede influir en las demás y viceversa, lo que significa que agregar o eliminar una restricción en una variable puede afectar a otras variables relacionadas.

**Ejemplo 6.21: Constraint bidireccional**

En este ejemplo, se muestran tres variables aleatorias (`r`, `s`, `t`) que están relacionadas a través de varias restricciones:

```verilog
// Ejemplo 6.21
rand logic [15:0] r, s, t;
constraint c_bidir {
  r < t;
  s == r;
  t < 30;
  s > 25;
}
```

**Explicación de las constraints**:
- `r < t`: El valor de `r` debe ser menor que el de `t`.
- `s == r`: El valor de `s` debe ser igual al de `r`.
- `t < 30`: El valor de `t` debe ser menor que 30.
- `s > 25`: El valor de `s` debe ser mayor que 25.

Aunque parece que no hay una restricción directa sobre el valor mínimo de `t`, la restricción en `s` (que también afecta a `r` debido a la relación `s == r`) limita las posibles opciones de `t`. El solucionador evalúa todas estas restricciones al mismo tiempo, encontrando valores que satisfagan todas las condiciones.

**Posibles soluciones**:

En este caso, las posibles combinaciones de valores para `r`, `s` y `t` que cumplen con todas las restricciones son:

| Solución | `r` | `s` | `t` |
|----------|-----|-----|-----|
| A        | 26  | 26  | 27  |
| B        | 26  | 26  | 28  |
| C        | 26  | 26  | 29  |
| D        | 27  | 27  | 28  |
| E        | 27  | 27  | 29  |
| F        | 28  | 28  | 29  |

**Cómo funcionan las constraints condicionales**

Incluso las restricciones condicionales, como el operador de implicación (`->`) o el `if-else`, siguen siendo bidireccionales, a pesar de que pueden parecer similares a los condicionales secuenciales de un lenguaje procedimental.

**Ejemplo: Constraint condicional**

```verilog
constraint c_cond {
  (a == 1) -> (b == 0);
}
```

Esto significa que **si** `a == 1`, entonces `b` debe ser igual a `0`. Pero como SystemVerilog resuelve todo de manera concurrente, esta restricción es **equivalente** a:

```verilog
!(a == 1) || (b == 0);
```

Es decir, el solucionador no evalúa primero si `a == 1` y luego decide el valor de `b`. En cambio, el solucionador selecciona valores para ambas variables (a y b) que satisfagan esta restricción. Si añades otra restricción adicional como `b == 1`, el solucionador automáticamente establecerá `a == 0`, porque es la única forma de satisfacer ambas condiciones.

**Resumen**:

- Las **constraints** en SystemVerilog son **declarativas** y no se ejecutan de forma secuencial.
- Son **bidireccionales**, lo que significa que todas las restricciones sobre las variables se resuelven al mismo tiempo, y el valor de una variable puede afectar el valor de otras variables relacionadas.
- Las **restricciones condicionales** como el operador de implicación (`->`) también se resuelven de manera concurrente, no secuencial.

### b.10 Operador aritmético correcto para mejorar la eficiencia del constraint

Este fragmento trata sobre cómo optimizar las **restricciones aritméticas** en **SystemVerilog** para que el **solver** (solucionador de restricciones) funcione de manera más eficiente. En particular, se enfoca en evitar operaciones costosas, como la **multiplicación**, **división**, y el **módulo**, cuando se trabajan con números de 32 bits, y sugiere usar alternativas más rápidas como **extracciones de bits** y **desplazamientos**.

**Conceptos Clave:**

1. **Operaciones eficientes**:  
   Operaciones simples como **suma**, **resta**, **extracción de bits** y **desplazamientos** son rápidas y fáciles de manejar para el solver. Estas operaciones pueden resolverse fácilmente y, por lo tanto, no ralentizan el proceso de generación de valores aleatorios.

2. **Operaciones costosas**:  
   Por otro lado, las operaciones como **multiplicación**, **división** y **módulo** son mucho más costosas en términos de tiempo de cómputo cuando se aplican a valores de 32 bits. Esto se debe a que el solver debe evaluar muchas combinaciones posibles de números para encontrar una solución que cumpla con la restricción. Cuando no se especifica un tamaño de constante, el valor se trata como un número de 32 bits, lo que agrega complejidad.

3. **Ejemplo de operación costosa (Sample 6.22)**:  
   En este ejemplo, se genera una dirección aleatoria `addr` de 32 bits y se aplica una restricción que usa el operador de **módulo** (`%`):

   ```verilog
   rand bit [31:0] addr;
   constraint slow_near_page_boundary {
       addr % 4096 inside {[0:20], [4075:4095]};
   }
   ```

   - Aquí, el valor de `addr` debe ser tal que su módulo 4096 esté dentro de los rangos `[0:20]` o `[4075:4095]`, lo cual representa valores cercanos a los límites de una página de memoria (donde una página tiene 4096 bytes).
   - Esta operación es **costosa** porque el solver debe calcular muchos valores posibles para `addr` y verificar su módulo, lo que puede ser ineficiente.

4. **Optimización usando extracciones de bits (Sample 6.23)**:  
   Una optimización consiste en aprovechar que las potencias de 2 (como 4096) pueden representarse fácilmente mediante **bit extraction**. Dado que 4096 es `2^12`, en lugar de usar el operador de módulo, puedes extraer los bits correspondientes de `addr` y aplicar la restricción directamente sobre esos bits.

   ```verilog
   rand bit [31:0] addr;
   constraint near_page_boundry {
       addr[11:0] inside {[0:20], [4075:4095]};
   }
   ```

   - Aquí, `addr[11:0]` extrae los 12 bits menos significativos de `addr`. Estos 12 bits representan el desplazamiento dentro de una página de 4096 bytes.
   - El solver solo necesita verificar si esos bits están dentro de los rangos `[0:20]` o `[4075:4095]`, lo que es mucho más eficiente que calcular un módulo.

**Explicación detallada de la optimización**:

- **4096 en binario** es `1000000000000`, lo que significa que es una potencia de 2 (`2^12`). En lugar de hacer una operación de módulo para obtener el valor dentro de una página de memoria, puedes simplemente **extraer los 12 bits inferiores** de `addr` (que corresponderán al rango de 0 a 4095 dentro de la página).
  
- Esta extracción de bits reduce drásticamente el esfuerzo computacional del solver, ya que no tiene que realizar operaciones aritméticas complejas como el módulo, sino solo trabajar con un subconjunto de bits que ya representan lo que el módulo calcula.

- Además, el **desplazamiento** (shift) se puede usar en lugar de la **multiplicación** por una potencia de 2. Esto también es más rápido para el solver.

Esta técnica de optimización mejora significativamente el rendimiento del proceso de randomización en diseños de hardware y verificación funcional.


Seguir en la pag 178