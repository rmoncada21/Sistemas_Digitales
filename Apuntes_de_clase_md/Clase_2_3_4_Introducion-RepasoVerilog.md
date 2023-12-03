# Repasar Disseño Digital en Verilog y System Verilog
- Maquinas de estado
- Diseñar logica combinal 
- Hacer diseño Gerarquico

Plan de verificación funcional

## 1. SystemVerilog
- Es una extensión de veriog. Es un lenguaje util para la verificaión del diseño. Inclusive permite programación orientada a objetos.

- Permite hacer cosas mas orientadas hacia las verificación.

- Conocer bien la arquitectura.

- Identificar todos los casos de funcionamientos normal del sistema, e identificar los casos de esquina; desbordamiento, multiplicaiones por cero, uso de acarreo, no uso de acarreo

Lista de recursos, interfaces, prueba, protoccolos que se van a necesitar para probar

- Repaso (Diseño digital verilog y system verilog)
- Diseños digitales
- Mauinas de estado de estado finito
- Diseño jerarquico 
- Lógica combinacional
- Mapas K  

Señal mixta: 
Digital-analógico.

Veriloga: parecido a hdl, describe ciruitos analógicos
Verilogams: señal mixta, permite simular circuitos digitales como analógicos

- Polimorfismo: 
  Crear funciones con diferentes tipos de manera de datos. Ejemplo crear un clase que trabaje con datos enteros, flotantes
- Herencia:
  Las clases heredan atributos de otras clases

## Repaso de Verilog (parte sintetizable)
"Sintaxis de lenguaje sintetizable

Comandos - Variables:
**reg:** 	 registro y almacena un valor - se sintetizan como flops o latches normmales
**wire**:  cable, permite la conexión - también sirven para conectar dos modulos
**tri**: 	 variables de tercer estado 
**logic**: permite al compilador inferir el tipo de la variable
Se pueden usar enteros, flotantes , pero no son sintetizables

Declaración 
**Tipo [msb:lsb] nombre**:   (menos significativo, mas significativo)
**wire [31:0] BID**:

Declaración de un módulo 
**-module Nombre (Entrada, Salida)  #parametros**:

Declaración de puertos
**-input Entrada **:
**-output Salida **: 

Instancias
Original Copia (Puertos);

Procesos-> como funciones
always @ (ListaDeSensibilidad) begin

código
end

endmodule

"Implementación de Circuitos Combinacionales
Ver la presentación_02Intro Verilog

"Implementación de Circuitos Secuenciales
Ver la presentación_02Intro Verilog

"Genvar y Generate r Icarus Verilog
Ver la presentación_02Intro Verilog


"Icarus Verilog 
//Instalación icarus/gtkwave fedora
sudo dnf install iverilog
sudo dnf install gtkwave

//manual de icarus-verilog/gtkwave en la terminal 
man iverilog 
man gtlwave

//Compilación de un programa de verilog con icarus
iverilog -g2012 -o nombre_ejecutable -W all nombre_archivo.v > log
iverilog -g2012 -o salida -W all Test_fifo.v > log

>log immprime los warnings en archivo llmado log

//Comandos para el uso del programa 
gtkwave vcd_file.vcd
gtkwave nombre_archivo.vcd


"Clase: en el servidor moverse en la carpeta de
