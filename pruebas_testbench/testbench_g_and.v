`timescale 1ns/1ps 
module testbench_g_and;

    // Entradas y salidas del testbench
    reg [1:0] in;
    wire out:

    // Instancia del módulo bajo prueba
    g_and uut (D[1], D[0], out);

    // Inicialización de las señales
    initial begin
        $display("A\tB\tY");

        // Iterar sobre todas las combinaciones posibles de A y B
        for (A = 0; A <= 1; A = A + 1) begin
            for (B = 0; B <= 1; B = B + 1) begin
                // Evaluar el diseño con la combinación actual
                #1;  // Esperar un ciclo para que se actualicen las salidas
                $display("%b\t%b\t%b", A, B, Y);
            end
        end

        $finish;  // Finalizar la simulación
    end

endmodule
