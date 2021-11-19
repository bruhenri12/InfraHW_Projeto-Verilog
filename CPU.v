`include "../mux_2x1_1_1.v"
`include "../mux_2x1_32_32.v"
`include "../mux_IorD.v"
`include "../mux_RegDst.v"
`include "../mux_ALUSrcB.v"
`include "../mux_MemtoReg.v"
`include "../mux_PCSrc.v"
`include "../mux_ShiftQnt.v"
`include "../mux_ShiftReg.v"
`include "../pc_sel.v"
`include "../SignExtended_16_32.v"
`include "../SignExtended_1_32.v"
`include "../componentes/Banco_reg.vhd"
`include "../componentes/Instr_Reg.vhd"
`include "../componentes/Memoria.vhd"
`include "../componentes/Registrador.vhd"
`include "../componentes/Ula32.vhd"
`include "../componentes/RegDesloc.vhd"
`include "../componentes/shift_left_2.vhd"


module CPU(
    //Inputs
    input wire clk, Overflow,
    input wire [31:0] instruction,
    //Outputs
    output wire rst, PCWriteCond, PCWrite, EQorNE, GTorLT, WDSrc, MemRead_Write, IRWrite,
    output wire RegWrite, RegALoad, RegBLoad, ALUSrcA, EPCWrite, ALUOSrc, ALUOutLoad,
    output wire GLtMux, TwoBytes, Store, DivOrM, HiLoSrc, HiLoWrite,
    output wire [1:0] RegDst, ALUSrcB, ShiftQnt, ShiftReg,
    output wire [2:0] IorD, ALUOp, PCSrc, ShiftType,
    output wire [3:0] MemtoReg
);
    //Blocos:
    //Gerais
    wire rst, PCWriteCond, PCWrite;
    wire [31:0] Shift_L2_Out;
    //Memoria
    wire MemRead_Write, WDSrc;
    wire [2:0] IorD;
    wire [31:0] IorD_Out, WDSrc_Out, Mem_Out;
    //Instruction Register
    wire IRWrite;
    wire [4:0] IR25_21_Out, IR20_16_Out;
    wire [5:0] IR32_26_Out;
    wire [15:0] Imediato;
    //Banco de Registers
    wire RegWrite;
    wire [1:0] RegDst;
    wire [3:0] MemtoReg;
    wire [4:0] RegDst_Out, IR15_11;
    wire [31:0] Banco_reg_Out1, Banco_reg_Out2;
    wire [31:0] MemtoReg_Out, Shifter_Out, Hi_Out, Lo_Out, PC_Out, ALUResult_Out, ALUOut_Out, MDR_Out, OW_Out;
    //Registradores
    wire RegALoad, RegBLoad;
    wire [31:0] RegA_Out, RegB_Out;
    //ULA
    wire ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [2:0] ALUOp;
    wire [31:0] ALUSrcA_Out, ALUSrcB_Out, Imediato, Imedato_L2_Out, ImediatoExt;
    //PC
    wire ALUOSrc, GLtMux, Lt, Gt, GLtMux_Out, ALUOutLoad, EPCWrite, EQorNE, GTorLT, EQorNE_Out, GTorLT_Out, PCLoad;
    wire [2:0] PCSrc;
    wire [25:0] IR25_0_Out;
    wire [31:0] ALUOSrc_Out, IR25_0_Out_L2_Out, EPC_Out, PCSrc_Out, GLtMuxExt;

    //Shifter
    wire [1:0] ShiftQnt, ShiftReg;
    wire [2:0] ShiftType;
    wire [4:0] MDR4_0_Out, shamt, RegB4_0_Out, ShiftQnt_Out;
    wire [31:0] ShiftReg_Out; 
    
    assign IR15_11 <= Imediato[15:11];
    assign MDR4_0_Out <= MDR_Out[4:0];
    assign shamt <= Imediato[10:6];
    assign RegB4_0_Out <= RegB_Out[4:0];

    //Conjuntos de blocos:
    //Memoria
    mux_IorD Mux_IorD(IorD_Out, IorD, PC_Out, ALUOut_Out, RegA_Out, RegB_Out);

    mux_2x1_32_32 Mux_WDSrc(WDSrc_Out, WDSrc, RegB_Out, OW_Out);

    Memoria Memory(IorD_Out, clk, MemRead_Write, WDSrc_Out, Mem_Out);
    
    //Instruction Register
    Instr_Reg Instruction_Register(clk, rst, IRWrite, Mem_Out, IR32_26_Out, 
                                   IR25_21_Out, IR20_16_Out, Imediato);

    //Banco de Registradores
    mux_RegDst Mux_RegDst(RegDst_Out, RegDst, IR20_16_Out, IR15_11);

    mux_MemtoReg Mux_MemtoReg(MemtoReg_Out, MemtoReg, ALUOut_Out, MDR_Out, 
                              OW_Out, Shifter_Out, Hi_Out, Lo_Out, PC_Out, ALUResult_Out);

    Banco_reg Banco_Reg(clk, rst, RegWrite, IR25_21_Out, IR20_16_Out, 
                        RegDst_Out, MemtoReg_Out, Banco_reg_Out1, Banco_reg_Out2);

    //Registradores
    Registrador Reg_A(clk, rst, RegALoad, Banco_reg_Out1, RegA_Out);

    Registrador Reg_B(clk, rst, RegBLoad, Banco_reg_Out2, RegB_Out);
    
    //ULA
    mux_2x1_32_32 Mux_ALUSrcA(ALUSrcA_Out, ALUSrcA, PC_Out, RegA_Out);

    SignExtended_16_32 SignExtended_16_32(Imediato, ImediatoExt);

    shift_left_2 Imediato_L2(clk, rst, ImediatoExt, Imedato_L2_Out);

    mux_ALUSrcB Mux_ALUSrcB(ALUSrcB_Out, ALUSrcB, RegB_Out, ImediatoExt, Imedato_L2_Out);

    Ula32 ULA(ALUSrcA_Out, ALUSrcB_Out, ALUOp, ALUResult_Out, Overflow, Negativo, Zero, Igual, Gt, Lt); //Fazer: Negativo, Zero, Igual

    
    //ALUOut
    Registrador ALUOut(clk, rst, ALUOutLoad, ALUOSrc_Out, ALUOut_Out);
    
    //PC
    mux_2x1_1_1 Mux_GLtMux(GLtMux_Out, GLtMux, Lt, Gt); 

    SignExtended_1_32 SignExtended_1_32(GLtMux_Out, GLtMuxExt);

    mux_2x1_32_32 Mux_ALUOSrc(ALUOSrc_Out, ALUOSrc, ALUResult_Out, GLtMuxExt);

    Registrador EPC(clk, rst, EPCWrite, ALUResult_Out, EPC_Out);
    
    shift_left_2 IR25_0_Out_L2(clk, rst, IR25_0_Out, IR25_0_Out_L2_Out); //IR25_0_Out_L2_Out concatena com PC_Out[31..28]

    mux_PCSrc Mux_PCSrc(PCSrc_Out, PCSrc, ALUResult_Out, ALUOut_Out, IR25_0_Out_L2_Out, OW_Out, EPC_Out);
    
    pc_sel PCSel(Zero, Gt, PCWrite, PCWriteCond, EQorNE, GTorLT, PCLoad);

    Registrador PC(clk, rst, PCLoad, PCSrc_Out, PC_Out);
    
    //Shifter

    mux_ShiftQnt Mux_ShiftQnt(ShiftQnt_Out, ShiftQnt, MDR4_0_Out, shamt, RegB4_0_Out); 

    mux_ShiftReg Mux_ShiftReg(ShiftReg_Out, ShiftReg, ImediatoExt, RegA_Out, RegB_Out);

    RegDesloc Shifter(clk, rst, ShiftType, ShiftQnt_Out, ShiftReg_Out, Shifter_Out);

endmodule

//Auxiliares

//Overwrite Block
//wire TwoBytes,

//Div, hi, lo
//wire DivZero, HiLoWrite,

//Multiplexadores:
//1bit
//wire DivOrM, HiLoSrc;