module pc_sel (
    input wire Zero, Gt, PCWrite, PCWriteCond, EQorNE, GTorLT,
    output wire Out
);

    wire notZero, notGt;
    wire rZeroGt, rAux;

    assign notZero = ~Zero;
    assign notGt = ~Gt;

    mux_2x1_1_1 Mux_EQorNE(EQorNE_Out, EQorNE, Zero, notZero); 
    mux_2x1_1_1 Mux_GTorLT(GTorLT_Out, GTorLT, Gt, notGt); 

    assign rZeroGt = EQorNE_Out | GTorLT_Out;
    assign rAux = rZeroGt & PCWriteCond;
    assign Out = rAux | PCWrite;
    
endmodule