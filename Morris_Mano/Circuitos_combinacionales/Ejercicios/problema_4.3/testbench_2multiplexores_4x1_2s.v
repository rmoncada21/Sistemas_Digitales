module testbench_2multiplexores_4x1_2s;
    input A0, A1, A2, A3, B0, B1, B2, B3, S, E;
    wire Y0, Y1, Y2, Y3;

    2multiplexores_4x1_2s uut(
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .S(S),
        .E(E),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3)
    );

    
endmodule 