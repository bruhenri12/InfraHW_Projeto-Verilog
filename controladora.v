module controladora (
    input wire clk, Overflow,
    input wire [31:0] instruction,
    output wire rst, PCWriteCond, PCWrite, EQorNE, GTorLT, WDSrc, MemRead_Write, IRWrite,
    output wire RegWrite, RegALoad, RegBLoad, ALUSrcA, EPCWrite, ALUOSrc, ALUOutLoad,
    output wire GLtMux, TwoBytes, Store, DivOrM, HiLoSrc, HiLoWrite,
    output wire [1:0] RegDst, ALUSrcB, ShiftQnt, ShiftReg,
    output wire [2:0] IorD, ALUOp, PCSrc, ShiftType,
    output wire [3:0] MemtoReg
);
    
    /*
     * caue: Estou com medo dessa controladora
     * bruno: Eu também
     */
endmodule