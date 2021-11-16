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
    input wire clk, Overflow,
    input wire [31:0] instruction
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
    wire [15:0] IR15_0_Out;
    //Banco de Registers
    wire RegWrite;
    wire [1:0] RegDst;
    wire [3:0] MemtoReg;
    wire [4:0] RegDst_Out, IR15_11; //fazer o [15..11]
    wire [31:0] Banco_reg_Out1, Banco_reg_Out2;
    wire [31:0] MemtoReg_Out, Shifter_Out, Hi_Out, Lo_Out, PC_Out, ALU_Out, ALUOut_Out, MDR_Out, OW_Out;
    //Registradores
    wire RegALoad, RegBLoad;
    wire [31:0] RegA_Out, RegB_Out;
    //ULA
    wire ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [2:0] ALUOp;
    wire [31:0] ALUSrcA_Out, ALUSrcB_Out, Imediato, Imedato_L2_Out;
    //PC
    wire ALUOSrc, GLtMux, Lt, Gt, GLtMux_Out, ALUOutLoad, EPCWrite, EQorNE, GTorLT;
    wire [2:0] PCSrc;
    wire [25:0] IR25_0_Out;
    wire [31:0] ALUOSrc_Out, IR25_0_Out_L2_Out, EPC_Out;
    //Shifter
    wire [1:0] ShiftQnt, ShiftReg;
    wire [2:0] ShiftType;
    wire [4:0] MDR4_0_Out, shamt, RegB4_0_Out, ShiftQnt_Out; //Transformar o MDR_Out em MDR[4..0], o IR15_0_Out em shamt(IR[10..6]), o RegB_Out em B[4..0]
    wire [31:0] ShiftReg_Out; 

    //Conjuntos de blocos:
    //Memoria
    mux_IorD Mux_IorD(IorD_Out, IorD, PC_Out, ALUOut_Out, RegA_Out, RegB_Out);

    mux_2x1_32_32 Mux_WDSrc(WDSrc_Out, WDSrc, RegB_Out, OW_Out);

    Memoria Memory(IorD_Out, clk, MemRead_Write, WDSrc_Out, Mem_Out);
    
    //Instruction Register
    Instr_Reg Instruction_Register(clk, rst, IRWrite, Mem_Out, IR32_26_Out, 
                                   IR25_21_Out, IR20_16_Out, IR15_0_Out);

    //Banco de Registradores
    mux_RegDst Mux_RegDst(RegDst_Out, RegDst, IR20_16_Out, IR15_11);

    mux_MemtoReg Mux_MemtoReg(MemtoReg_Out, MemtoReg, ALUOut_Out, MDR_Out, 
                              OW_Out, Shifter_Out, Hi_Out, Lo_Out, PC_Out, ALU_Out);

    Banco_reg Banco_Reg(clk, rst, RegWrite, IR25_21_Out, IR20_16_Out, 
                        RegDst_Out, MemtoReg_Out, Banco_reg_Out1, Banco_reg_Out2);

    //Registradores
    Registrador Reg_A(clk, rst, RegALoad, Banco_reg_Out1, RegA_Out);

    Registrador Reg_B(clk, rst, RegBLoad, Banco_reg_Out1, RegB_Out);
    
    //ULA
    mux_2x1_32_32 Mux_ALUSrcA(ALUSrcA_Out, ALUSrcA, PC_Out, RegA_Out);

    shift_left_2 Imediato_L2(clk, rst, Imediato, Imedato_L2_Out); //Imediato requer extensão de 16 -> 32

    mux_ALUSrcB Mux_ALUSrcB(ALUSrcB_Out, ALUSrcB, RegB_Out, Imediato, Imedato_L2_Out); //Imediato requer extensão de 16 -> 32

    Ula32 ULA(ALUSrcA_Out, ALUSrcB_Out, ALUOp, ALU_Out, Overflow, Negativo, Zero, Igual, Gt, Lt); //Fazer: Negativo, Zero, Igual

    //Saídas da ULA
    mux_2x1_1_1 Mux_GLtMux(GLtMux_Out, GLtMux, Lt, Gt); 

    mux_2x1_32_32 Mux_ALUOSrc(ALUOSrc_Out, ALUOSrc, ALU_Out, GLtMux_Out); //GLtMux_Out requer extensão de 1 -> 32

    //ALUOut

    //EPC

    //Começa PC
    shift_left_2 IR25_0_Out_L2(clk, rst, IR25_0_Out, IR25_0_Out_L2_Out); //IR25_0_Out_L2_Out concatena com PC_Out[31..28]

    mux_PCSrc Mux_PCSrc(PCSrc_Out, PCSrc, ALU_Out, ALUOut_Out, IR25_0_Out_L2_Out, OW_Out, EPC_Out);
    //Termina PC
    
    //Shifter

    mux_ShiftQnt Mux_ShiftQnt(ShiftQnt_Out, ShiftQnt, MDR4_0_Out, shamt, RegB4_0_Out); 

    mux_ShiftReg Mux_ShiftReg(ShiftReg_Out, ShiftReg, Imediato, RegA_Out, RegB_Out); //Imediato requer extensão de 16 -> 32

    RegDesloc Shifter(clk, rst, ShiftType, ShiftQnt_Out, ShiftReg_Out, Shifter_Out);

endmodule

//Auxiliares

//Overwrite Block
wire TwoBytes,
//Div, hi, lo
wire DivZero, HiLoWrite,

//Multiplexadores:
//1bit
wire DivOrM, HiLoSrc;