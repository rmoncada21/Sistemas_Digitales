module FFD_reset_async(
    output reg qd,
    input clk, data, reset_async
);

    always @ (posedge clk or reset_async) begin
        // si reset_async == 0
        if (~reset_async) qd = 1'b0;
        else qd <= data;
    end 
endmodule