# Task and functions en verilog

## a. Diferencias entre task y functions

Las tareas/task son similares a las subrutinas y las functions a las funciones en C. 

- Las **task** y **functions** no pueden contener **wires**.

- Las **task** y **functions** contienen instrucciones de comportamiento solamente. 

- Las **task** y **functions** no contienen bloques **always** o **initial**.

| **Funciones**                                                                 | **Tareas**                                                           |
|-------------------------------------------------------------------------------|----------------------------------------------------------------------|
| Una función puede habilitar otra función, pero no otra tarea.                 | Una tarea puede habilitar otras tareas y funciones.                  |
| Las funciones siempre se ejecutan en 0 tiempo de simulación.                  | Las tareas pueden ejecutarse en un tiempo de simulación distinto de 0. |
| Las funciones no deben contener ninguna declaración de delay, evento o control de tiempo. | Las tareas pueden contener declaraciones de delay, evento o control de tiempo. |
| Las funciones deben tener al menos un argumento de entrada (input). Pueden tener más de una entrada. | Las tareas pueden tener cero o más argumentos de tipo input, output o inout. |
| Las funciones siempre devuelven un solo valor. No pueden tener argumentos de salida (output) ni bidireccionales (inout). | Las tareas no devuelven un valor, pero pueden pasar múltiples valores a través de argumentos de salida (output) y bidireccionales (inout). |



## b. task 

Las tareas se declaran con las palabras claves **task** y **endtask**

Las tareas tienen **input, output, inout**

Sintáxis:

~~~verilog
task [nombre_de_la_tarea];
    // Declaración de parámetros y variables locales
    input [tipo] [nombre_de_entrada];
    output [tipo] [nombre_de_salida];
    inout [tipo] [nombre_de_inout];
    // Código de la tarea
endtask
~~~

Ejemplo:

~~~verilog
task add;
    input [7:0] a, b;
    output [7:0] sum;
    begin
        sum = a + b;
    end
endtask

// Invocación de la tarea
reg [7:0] result;
add(3, 4, result);
~~~

## c. functions
Las funciones se declaran con las palabras claves, **function** y **endfunction.**

Las funciones en verilog deben de contener al menos una entrada/input 

Una peculiaridad de las funciones en verilog, es que cuando se declara funcion, un registro con el nombre de la función se declara implicitamente por debajo. 

Sintáxis:

~~~verilog
function [tipo] [nombre_de_la_función];
    // Declaración de parámetros y variables locales
    input [tipo] [nombre_de_entrada];
    // Código de la función
endfunction
~~~

Ejemplo:
~~~verilog
function [7:0] add;
    input [7:0] a, b;
    begin
        add = a + b;
    end
endfunction

// Invocación de la función
reg [7:0] result;
result = add(3, 4);
~~~