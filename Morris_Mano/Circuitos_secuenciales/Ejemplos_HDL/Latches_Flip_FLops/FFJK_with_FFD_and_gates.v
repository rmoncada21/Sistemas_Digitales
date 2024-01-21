// Ejemplo 5.3 b)

module FFJK(
    output reg qjk,
    input clk, J, K, reset_async
);

    wire D;
    assign D = (J & ~qjk) | (~K & qjk);

    // Instanciar FFD
    FFD_reset_async FFD(
        .qd(qjk),
        .clk(clk),
        .data(D),
        .reset_async(reset_async)
    );
endmodule