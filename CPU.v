module CPU(
    input wire clk, rst
);
    //Blocos:
    //Gerais
    wire PCWriteCond, PCWrite;
    wire [31:0] Shift_L2_Out;
    //Memoria
    wire MemRead_Write, WDSrc;
    wire [2:0] IorD;
    wire [31:0] IorD_Out, WDSrc_Out, Mem_Out;
    //Memory Data Register
    wire MDR;
    wire [31:0] MDR_Out;
    //Instruction Register
    wire IRWrite;
    wire [4:0] IR25_21_Out, IR20_16_Out;
    wire [5:0] Opcode, Funct;
    wire [15:0] Imediato;
    //Banco de Registers
    wire RegWrite;
    wire [1:0] RegDst;
    wire [3:0] MemtoReg;
    wire [4:0] RegDst_Out, IR15_11;
    wire [31:0] Banco_reg_Out1, Banco_reg_Out2;
    wire [31:0] MemtoReg_Out, Shifter_Out, Hi_Out, Lo_Out, ALUResult_Out, ALUOut_Out;
    //Registradores
    wire RegALoad, RegBLoad;
    wire [31:0] RegA_Out, RegB_Out;
    //ULA
    wire ALUSrcA, Overflow, Zero, Negativo, Igual;
    wire [1:0] ALUSrcB;
    wire [2:0] ALUOp;
    wire [31:0] ALUSrcA_Out, ALUSrcB_Out, Imedato_L2_Out, ImediatoExt;
    //PC
    wire ALUOSrc, GLtMux, Lt, Gt, GLtMux_Out, ALUOutWrite, EPCWrite, EQorNE_Out, GTorLT_Out, PCLoad;
    wire [1:0] EQorNE, GTorLT;
    wire [2:0] PCSrc;
    wire [25:0] IR25_0_Out;
    wire [27:0] ShiftLeft_26_28_Out;
    wire [31:0] ALUOSrc_Out, ShiftLeft_PC, PC_Out, EPC_Out, PCSrc_Out, GLtMuxExt;

    //Shifter
    wire [1:0] ShiftQnt, ShiftReg;
    wire [2:0] ShiftType;
    wire [4:0] MDR4_0_Out, shamt, RegB4_0_Out, ShiftQnt_Out;
    wire [31:0] ShiftReg_Out; 

    //Overwrite Block
    wire Store, TwoBytes;
    wire [31:0] Store1_Out, Store2_Out, Store_Zero, OW_Out;
    
    //Div, Mult hi, lo
    wire DivZero, HiLoWrite, DivOrM, HiLoSrc;
    wire [31:0] mult_out1, mult_out2, HiSrc_out, LoSrc_out;
    wire [31:0] div_out1, div_out2, DivOrM1_out, DivOrM2_out;
    wire mult_init, mult_stop;
    wire div_init, div_stop, div_zero;
    
    assign Store_Zero = 32'd0;
    assign Funct = Imediato[5:0];
    assign IR15_11 = Imediato[15:11];
    assign MDR4_0_Out = MDR_Out[4:0];
    assign shamt = Imediato[10:6];
    assign RegB4_0_Out = RegB_Out[4:0];

    //Controladora
    controladora Control(clk, Overflow, rst, Opcode, Funct, PCWriteCond, 
                        PCWrite, WDSrc, MemRead_Write, IRWrite,
                        RegWrite, RegALoad, RegBLoad, ALUSrcA, EPCWrite, ALUOSrc, 
                        ALUOutWrite, GLtMux, TwoBytes, Store, DivOrM, HiLoSrc, 
                        HiLoWrite, MDR, RegDst, ALUSrcB, ShiftQnt, ShiftReg, EQorNE, 
                        GTorLT, IorD, ALUOp, PCSrc, ShiftType, MemtoReg, mult_init, mult_stop, div_init, div_stop, div_zero);


    //Conjuntos de blocos:
    //Memoria
    mux_IorD Mux_IorD(IorD_Out, IorD, PC_Out, ALUOut_Out, RegA_Out, RegB_Out);

    mux_2x1_32_32 Mux_WDSrc(WDSrc_Out, WDSrc, RegB_Out, OW_Out);

    Memoria Memory(IorD_Out, clk, MemRead_Write, WDSrc_Out, Mem_Out);

    //Memory Data Register
    Registrador MemoryDataRegister(clk, rst, MDR, Mem_Out, MDR_Out);
    
    //Instruction Register
    Instr_Reg Instruction_Register(clk, rst, IRWrite, Mem_Out, Opcode, 
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

    shift_left32_32 Imediato_L2(ImediatoExt, Imedato_L2_Out);

    mux_ALUSrcB Mux_ALUSrcB(ALUSrcB_Out, ALUSrcB, RegB_Out, ImediatoExt, Imedato_L2_Out);

    Ula32 ULA(ALUSrcA_Out, ALUSrcB_Out, ALUOp, ALUResult_Out, Overflow, Negativo, Zero, Igual, Gt, Lt); //Fazer: Negativo, Zero, Igual

    
    //ALUOut
    Registrador ALUOut(clk, rst, ALUOutWrite, ALUOSrc_Out, ALUOut_Out);
    
    //PC
    mux_2x1_1_1 Mux_GLtMux(GLtMux_Out, GLtMux, Lt, Gt); 

    SignExtended_1_32 SignExtended_1_32(GLtMux_Out, GLtMuxExt);

    mux_2x1_32_32 Mux_ALUOSrc(ALUOSrc_Out, ALUOSrc, ALUResult_Out, GLtMuxExt);

    Registrador EPC(clk, rst, EPCWrite, ALUResult_Out, EPC_Out);

    //concatena(25..21+20..16+15..0)
    assign IR25_0_Out = {{IR25_21_Out,IR20_16_Out},Imediato};
    
    shift_left26_28 ShiftLeft_26_28(IR25_0_Out, ShiftLeft_26_28_Out);
    
    //concatena(31..28+27..0)
    assign ShiftLeft_PC = {PC_Out[31:28], ShiftLeft_26_28_Out};

    mux_PCSrc Mux_PCSrc(PCSrc_Out, PCSrc, ALUResult_Out, ALUOut_Out, ShiftLeft_PC, OW_Out, EPC_Out);
    
    pc_sel PCSel(Zero, Gt, PCWrite, PCWriteCond, EQorNE, GTorLT, PCLoad);

    Registrador PC(clk, rst, PCLoad, PCSrc_Out, PC_Out);
    
    //Shifter

    mux_ShiftQnt Mux_ShiftQnt(ShiftQnt_Out, ShiftQnt, MDR4_0_Out, shamt, RegB4_0_Out); 

    mux_ShiftReg Mux_ShiftReg(ShiftReg_Out, ShiftReg, ImediatoExt, RegA_Out, RegB_Out);

    RegDesloc Shifter(clk, rst, ShiftType, ShiftQnt_Out, ShiftReg_Out, Shifter_Out);

    //Overwrite Block

    mux_2x1_32_32 Mux_Store1(Store1_Out, Store, Store_Zero, MDR_Out);

    mux_2x1_32_32 Mux_Store2(Store2_Out, Store, MDR_Out, RegB_Out);

    overwrite_block OverwriteBlock(Store1_Out, Store2_Out, TwoBytes, OW_Out);

    //DIV,MULT,HI,LO
    mult Mult(RegA_Out,RegB_Out,mult_init,mult_stop, clk, rst, mult_out1, mult_out2);
    
    
    wire [31:0] teste1;
    
    mux_2x1_32_32 Mux_DivOrM1(DivOrM1_out, DivOrM, MDR_Out, RegA_Out);
    mux_2x1_32_32 Mux_DivOrM2(DivOrM2_out, DivOrM, Mem_Out, RegB_Out);

            // a, b, init, stop, clock, reset, hi, lo, zero 

    div Div(DivOrM1_out, DivOrM2_out, div_init,div_stop, clk, rst, div_out1, div_out2, div_zero);

    mux_2x1_32_32 Mux_HiSrc(HiSrc_out, HiLoSrc, div_out1 ,mult_out1);
    mux_2x1_32_32 Mux_LoSrc(LoSrc_out, HiLoSrc, div_out2, mult_out2);

    Registrador Hi(clk, rst, HiLoWrite, HiSrc_out, Hi_Out);
    Registrador Lo(clk, rst, HiLoWrite, LoSrc_out, Lo_Out);



endmodule