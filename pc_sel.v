module pc_sel (
    input wire Zero, Gt, PCWrite, PCWriteCond, 
    input wire [1:0] EQorNE, GTorLT,
    output wire Out
);

    reg ze;
    wire notZero, notGt;
    wire rZeroGt, rAux;
	wire EQorNE_Out, GTorLT_Out;
	 

    assign notZero = ~Zero;
    assign notGt = ~Gt;

    initial begin
        ze = 0;
    end

    // mux_ShiftReg = mux de três entradas ;)
    mux_3x1_1_1 Mux_EQorNE(EQorNE_Out, EQorNE, ze, notZero, Zero); 
    mux_3x1_1_1 Mux_GTorLT(GTorLT_Out, GTorLT, ze, notGt, Gt); 
	 

    assign rZeroGt = EQorNE_Out || GTorLT_Out;
    assign rAux = rZeroGt && PCWriteCond;
    assign Out = rAux || PCWrite;
    
endmodule