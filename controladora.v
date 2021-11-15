`include "../mux_2x1_32_32.v"
`include "../mux_IorD.v"
`include "../mux_RegDst.v"
`include "../mux_ALUSrcB.v"
`include "../mux_MemtoReg.v"
`include "../mux_PCSrc.v"
`include "../mux_ShiftQnt.v"
`include "../mux_ShiftReg.v"
`include "../componentes/Banco_reg.vhd"
`include "../componentes/Instr_Reg.vhd"
`include "../componentes/Memoria.vhd"
`include "../componentes/Registrador.vhd"
`include "../componentes/Ula32.vhd"
`include "../componentes/RegDesloc.vhd"
`include "../componentes/shift_left_2.vhd"


module controladora(
    //Gerais
    input wire clk,
    output wire rst, PCWriteCond, PCWrite,
    //Blocos:
    //Memoria
    output wire MemRead_Write,
    //Instruction Register
    output wire IRWrite,
    //Registers
    output wire RegWrite,
    //ALU
    input wire [2:0] ALUOp,
    //ALUOut
    output wire ALUOutLoad,
    //EPC
    output wire EPCWrite,
    //Registradores
    output wire RegALoad, RegBLoad,
    //Overwrite Block
    output wire TwoBytes,
    //Div, hi, lo
    output wire DivZero, HiLoWrite,
    //Shift
    input wire [2:0] ShiftType,
);
    wire rst, IRWrite;
    wire [4:0] IR25_21_Out, IR20_16_Out, RegDst_Out, IR15_11; //fazer o [15..11]
    wire [5:0] IR32_26_Out;
    wire [15:0] IR15_0_Out;
    wire [31:0] IorD_Out, WDSrc_Out, Mem_Out, MemtoReg_Out, ALUOut_Out, MDR_Out, OW_Out;
    wire [31:0] Shifter_Out, Hi_Out, Lo_Out, PC_Out, ALU_Out, Banco_reg_Out1, Banco_reg_Out2; 
    //Multiplexadores:
    //1bit
    wire WDSrc, ALUSrcA, ALUOSrc, GLtMux, EQorNE, GTorLT, DivOrM, HiLoSrc;
    //2bit
    wire [1:0] RegDst, ALUSrcB, ShiftQnt, ShiftReg;
    //3bit
    wire [2:0] IorD, PCSrc;
    //4bit
    wire [3:0] MemtoReg;


    Memoria Memory(IorD_Out, clk, MemRead_Write, WDSrc_Out, Mem_Out);
    
    Instr_Reg Instruction_Register(clk, rst, IRWrite, Mem_Out, IR32_26_Out, 
                                   IR25_21_Out, IR20_16_Out, IR15_0_Out);

    mux_RegDst Mux_RegDst(RegDst_Out, RegDst, IR20_16_Out, IR15_11);

    mux_MemtoReg mux_MemtoReg(MemtoReg_Out, MemtoReg, ALUOut_Out, MDR_Out, 
                              OW_Out, Shifter_Out, Hi_Out, Lo_Out, PC_Out, ALU_Out);

    Banco_reg Banco_Reg(clk, rst, RegWrite, IR25_21_Out, IR20_16_Out, 
                        RegDst_Out, MemtoReg_Out, Banco_reg_Out1, Banco_reg_Out2);
    




endmodule