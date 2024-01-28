`include "FFJK_with_FFD_and_gates.v"

module testbench_FFJK_with_FFD_and_gates;
    // Entradas y salidas del testbench
    wire Q;
    reg clk, J, K, reset_async;

    // Vectores para las tareas 
    reg Q_prev;
    
    // instanciar el modulo
    FFJK uut(
        .Q(Q),
        .clk(clk), 
        .J(J), 
        .K(K), 
        .reset_async(reset_async)
        );

    // Tareas del test
    task gen_vcd_file;
        $dumpfile("testbench_FFJK_with_FFD_and_gates");
        $dumpvars(1, testbench_FFJK_with_FFD_and_gates);
    endtask
    
    task verify(reg Q_prev);

        case({J,K})
        2'b00: 
            if(Q==Q_prev) begin
                $display("Correcto a");
            end else begin
                $display("ERROR a");
            end 
        2'b01: 
            if(Q==1'b0) begin
                $display("Correcto b");
            end else begin
                $display("ERROR b");
            end 
        2'b10: 
            if(Q==1'b1) begin
                $display("Correcto C");
            end else begin
                $display("ERROR C");
            end 
        2'b11: if(Q==(~Q_prev)) begin
                $display("Correcto d");
            end else begin
                $display("ERROR d");
            end 
        default: $display("OTRO");
        endcase
    endtask
    
    always #5 clk = ~clk; 
    // always #5 Q_prev <= Q;

    always @(posedge clk) begin
        reg captura;
        assign captura = Q & 1;
        Q_prev <= captura;
        #0.5;

        if (reset_async) begin
            verify(Q_prev);
        end else if(~reset_async) begin
            $display("PUSH RESET BUTOM");
        end
        
    end

    initial begin
        $monitor("Clk=%b Reset=%b JK=%b%b Q=%b tiempo=%0dns ",clk, reset_async,J, K, Q, $time);
        
        // Generar archivo de onda VCD
        gen_vcd_file;

        // Inicializar los valores
        clk = 0;
        J=0; K=0; 
        
        reset_async = 0;
        #5 reset_async = 1;
        // #5 J=1; K=1;
        // #5 J=1; K=0;
        // #5 J=1; K=0;
        // #5 J=1; K=1;

        repeat(5) begin
            J = $urandom_range(0,1);
            K = $urandom_range(0,1); 
            // JK = {J,K};
            // $display("JK=%b%b", J, K);
            #5;
        end

           reset_async = 0;
        #5 reset_async = 1;
        // #5 J=1; K=0;
        // #5 J=1; K=1;
        // #5 J=0; K=0;
        // #5 J=0; K=0;
        repeat(5) begin
            J = $urandom_range(0,1);
            K = $urandom_range(0,1); 
            // JK = {J,K};
            // $display("JK=%b%b", J, K);
            #5;
        end

        $finish;
    end
endmodule