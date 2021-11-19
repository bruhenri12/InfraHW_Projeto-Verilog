`include "../mux_2x1_1_1.v"

module pc_sel (
    input reg Zero, Gt, PCWrite, PCWriteCond, EQorNE, GTorLT,
    output reg Out
);

    reg notZero, notGt;
    reg rZeroGt, rAux;

    assign notZero = ~Zero;
    assign notGt = ~Gt;

    mux_2x1_1_1 Mux_EQorNE(EQorNE_Out, EQorNE, Zero, notZero); 
    mux_2x1_1_1 Mux_GTorLT(GTorLT_Out, GTorLT, Gt, notGt); 

    assign rZeroGt = EQorNE_Out or GTorLT_Out;
    assign rAux = rZeroGt and PCWriteCond;
    assign Out = rAux or PCWrite;
    
endmodule