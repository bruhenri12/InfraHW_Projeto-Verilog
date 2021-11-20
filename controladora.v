module controladora (
    input wire clk, Overflow, reset
    input wire [5:0] opcode, funct
    output wire PCWriteCond, PCWrite, EQorNE, GTorLT, WDSrc, MemRead_Write, IRWrite,
                RegWrite, RegALoad, RegBLoad, ALUSrcA, EPCWrite, ALUOSrc, ALUOutLoad,
                GLtMux, TwoBytes, Store, DivOrM, HiLoSrc, HiLoWrite,
    output wire [1:0] RegDst, ALUSrcB, ShiftQnt, ShiftReg,
    output wire [2:0] IorD, ALUOp, PCSrc, ShiftType,
    output wire [3:0] MemtoReg
);
    
    /*
     * caue: Estou com medo dessa controladora
     * bruno: Eu também
     * eduardo: rs
     */

    reg [6:0] state, next_state;

    always @(posedge clk or negedge reset) begin
        if(!reset)
            state = 0;  // reset state
        else
            state = next_state;
    end

    always @(state) begin: OUTPUT LOGIC AND NEXT STATE LOGIC
        
    end

endmodule