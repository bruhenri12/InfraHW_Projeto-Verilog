module controladora (
    input wire clk, Overflow, reset,
    input wire [5:0] opcode, funct,
    output reg PCWriteCond, PCWrite, EQorNE, GTorLT, WDSrc, MemRead_Write, IRWrite,
                RegWrite, RegALoad, RegBLoad, ALUSrcA, EPCWrite, ALUOSrc, ALUOutWrite,
                GLtMux, TwoBytes, Store, DivOrM, HiLoSrc, HiLoWrite, MDRLoad,
    output reg [1:0] RegDst, ALUSrcB, ShiftQnt, ShiftReg,
    output reg [2:0] IorD, ALUOp, PCSrc, ShiftType,
    output reg [3:0] MemtoReg
);
    
    /*
     * caue: Estou com medo dessa controladora
     * bruno: Eu também
     * eduardo: rs
     *
     *
     * Sáb nov 2 às 15:38 - Cauê: E lá vamos nós.
    */

    parameter  sll_funct  = 6'h0;	
    parameter  sllv_funct = 6'h4;	
    parameter  sra_funct  = 6'h3;	
    parameter  srav_funct = 6'h7;	
    parameter  srl_funct  = 6'h2;	
    parameter  sram_op    = 6'b000001;	
    parameter  lui_op     = 6'hf;
    parameter  add_funct  = 6'h20;
    parameter  and_funct  = 6'h24;
    parameter  div_funct  = 6'h1a;
    parameter  mult_funct = 6'h18;
    parameter  jr_funct   = 6'h8;
    parameter  addi_op    = 6'h8;
    parameter  addiu_op   = 6'h9;
    parameter  op0        = 6'h0;

    reg [7:0] state;

    always @(posedge clk) begin: NEXT_STATE_LOGIC
        case(state)
            0: begin: GO_TO_1
                state <= 1;
            end

            1: begin: GO_TO_2
                state <= 2;
            end

            2: begin: GO_TO_3
                state <= 3;
            end

            3: begin: GO_TO_4
                state <= 4;
            end

            4: begin: END_OF_CICLOS_COMUNS
                if((opcode == op0) && (funct == add_funct))
                    state <= 5;  // add
                else if((opcode == op0) && ((funct == sll_funct) || (funct == sra_funct) || (funct == srl_funct)))
                    state = 20;  // sll, sra or srl
                else if((opcode == op0) && ((funct == sllv_funct) || (funct == srav_funct)))
                    state = 22;  // sllv, srav
                else if(opcode == sram_op)
                    state = 25;  // sram
                else if(opcode == lui_op)
                    state = 26;  // lui
                else if((opcode == addi_op) || (opcode == addiu_op))
                    state <= 73; // addi or addiu
                else // opcode inexistente
                    state <= 11;
            end

            5: begin
                if(Overflow)
                    state <= 7;  // overflow
                else
                    state <= 6;  // continue add
            end

            6: begin: GO_TO_START_6
                state <= 1;
            end

            7: begin: GO_TO_TRATAMENTO_DE_EXCECAO_PADRAO_7
                state <= 12;
            end

            8: begin: GO_TO_START_8
                state <= 1;
            end

            11: begin: GO_TO_TRATAMENTO_DE_EXCECAO_PADRAO_11
                state <= 12;
            end

            13: begin
                state <= 14;
            end

            14: begin: GO_TO_START_14
                state <= 1;
            end

            25: begin: GO_TO_24
                if(funct == sll_funct)
                    state <= 26;
                else if(funct == sra_funct)
                    state <= 27;
                else if(funct == srl_funct)
                    state <= 28;
                else
                    state <= 0;
            end

            26: begin
                state <= 29;
            end

            27: begin
                state <= 29;
            end

            28: begin
                state <= 29;
            end

            29: begin
                state <= 1;
            end

            30: begin: GO_TO_23
                if(funct == sllv_funct)
                    state <= 31;
                else if(funct == srav_funct)
                    state <= 32;
            end

            31: begin
                next_state <= 33;
            end

            32: begin
                next_state <= 33;
            end

            33: begin: GO_TO_START_24
                state <= 1;
            end

            36: begin
                state <= 37;
            end

            37: begin
                state <= 38;
            end

            38: begin
                state <= 39;
            end

            39: begin
                state <= 40;
            end

            40: begin
                state <= 1;
            end

            41: begin: GO_TO_27
                state <= 42;
            end

            42: begin: GO_TO_28
                state <= 43;
            end

            43: begin: GO_TO_START_28
                state <= 1;
            end

            73: begin: GO_TO_START_73
                if(opcode == addi_op) begin
                    if(Overflow)
                        state <= 7;  // overflow
                    else
                        state <= 8;  // addi
                end
                else
                    state <= 9;  // addiu
            end

            default: state <= 0;
        endcase
    end

    always @(posedge reset)
        state <= 0;

    always @(state) begin: OUTPUT_LOGIC
        case (state)
            0: begin: RESET
                PCWriteCond   = 0;
                PCWrite       = 0;
                EQorNE        = 0;
                GTorLT        = 0;
                WDSrc         = 0;
                MemRead_Write = 0;
                IRWrite       = 0;
                //RegWrite      = 0;
                RegALoad      = 0;
                RegBLoad      = 0;
                ALUSrcA       = 0;
                EPCWrite      = 0;
                ALUOSrc       = 0;
                ALUOutWrite   = 0;
                GLtMux        = 0;
                TwoBytes      = 0;
                Store         = 0;
                DivOrM        = 0;
                HiLoSrc       = 0;
                HiLoWrite     = 0;
                MDRLoad       = 0;
                //RegDst        = 0;
                ALUSrcB       = 0;
                ShiftQnt      = 0;
                ShiftReg      = 0;
                IorD          = 0;
                ALUOp         = 0;
                PCSrc         = 0;
                ShiftType     = 0;
                //MemtoReg      = 0;

                RegDst   = 2'b11;
                MemtoReg = 4'b0111;
                RegWrite = 1;
            end

            1: begin: START
                PCWriteCond   = 0;
                //PCWrite       = 0;
                EQorNE        = 0;
                GTorLT        = 0;
                WDSrc         = 0;
                //MemRead_Write = 0;
                IRWrite       = 0;
                RegWrite      = 0;
                RegALoad      = 0;
                RegBLoad      = 0;
                //ALUSrcA       = 0;
                EPCWrite      = 0;
                ALUOSrc       = 0;
                ALUOutWrite   = 0;
                GLtMux        = 0;
                TwoBytes      = 0;
                Store         = 0;
                DivOrM        = 0;
                HiLoSrc       = 0;
                HiLoWrite     = 0;
                MDRLoad       = 0;
                RegDst        = 0;
                //ALUSrcB       = 0;
                ShiftQnt      = 0;
                ShiftReg      = 0;
                //IorD          = 0;
                //ALUOp         = 0;
                //PCSrc         = 0;
                ShiftType     = 0;
                MemtoReg      = 0;

                PCWrite       = 1;
                IorD          = 0;
                MemRead_Write = 0;
                ALUSrcA       = 0;
                ALUSrcB       = 1;
                PCSrc         = 0;
                ALUOp         = 1;
            end

            2: begin
                PCWrite = 0;
            end

            3: begin
                IRWrite = 1;
            end

            4: begin: END_OF_CICLOS_COMUNS
                IRWrite     = 0;
                ALUSrcA     = 0;
                ALUSrcB     = 3;
                ALUOp       = 1;
                ALUOSrc     = 0;
                RegALoad    = 1;
                RegBLoad    = 1;
                ALUOutWrite = 1;
            end

            5: begin: ADD
                ALUSrcA     = 1;
                ALUSrcB     = 0;
                ALUOp       = 1;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
            end

            6: begin: END_OF_ADD
                ALUOutWrite = 0;
                MemtoReg    = 0;
                RegDst      = 1;
                RegWrite    = 1;
            end

            73: begin: ADDI_OR_ADDIU
                ALUSrcA     = 1;
                ALUSrcB     = 2;
                ALUOp       = 1;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
            end

            7: begin: OVERFLOW
                ALUOutWrite   = 0;
                ALUSrcA       = 0;
                ALUSrcB       = 1;
                ALUOp         = 3'b010;
                EPCWrite      = 1;
                IorD          = 3;
                MemRead_Write = 0;
            end

            8: begin: END_OF_ADDI
                ALUOutWrite = 0;
                MemtoReg    = 0;
                RegDst      = 0;
                RegWrite    = 1;
            end

            11: begin: OPCODE_INEXISTENTE
                IorD           = 2;
                MemRead_Write  = 0;
                ALUSrcA        = 0;
                ALUSrcB        = 1;
                ALUOp          = 3'b010;
                EPCWrite       = 1;
            end

            12: begin: TRATAMENTO_DE_EXCECAO_PADRAO
                EPCWrite = 0;
            end

            13: begin
                MDRLoad = 1;
            end

            14: begin: END_OF_TRATAMENTO_DE_EXCECAO_PADRAO
                MDRLoad  = 0;
                Store    = 0;
                TwoBytes = 0;
                PCSrc    = 3;
                PCWrite  = 1;
            end

            25: begin: SLL_SRA_SRL_START
                ShiftQnt    = 2'b01;
                ShiftReg    = 2'b10;
                ShiftType   = 3'b001;
                ALUOutWrite = 0;
            end

            26: begin:
                ShiftType = 3'b010;
            end

            27: begin
                ShiftType = 3'b100;
            end

            28: begin
                ShiftType = 3'b011;
            end

            29: begin
                RegDst = 01
                MemtoReg = 0011
                RegWrite = 1
            end

            30: begin: SLLV_SRAV_START
                ShiftQnt    = 2'b11;
                ShiftReg    = 2'b01;
                ShiftType   = 3'b001;
                ALUOutWrite = 0;
            end

            31: begin
                ShiftType = 3'b010;
            end

            32: begin
                ShiftType = 3'b011;
            end

            33: begin: SLL_SRA_SRL_SLLV_SRAV_END
                RegDst = 2'b01;
                MemtoReg = 4'b0011;
                RegWrite = 1;
            end

            34: begin: SRAM_START
                RegALoad    = 0;
                RegBLoad    = 0;
                ALUSrcA     = 1;
                ALUSrcB     = 2;
                ALUOp       = 1;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
            end

            35: begin: SRAM_START
                ALUOutWrite = 0;
                IorD        = 1;
                MemR_W      = 0;
            end

            36: begin: SRAM_START
                // wait
            end

            37: begin: SRAM_START
                MDRLoad = 1;
            end

            38: begin: SRAM_START
                MDRLoad   = 0;
                ShiftQnt  = 0;
                ShiftReg  = 2;
                ShiftType = 1;
            end

            39: begin: SRAM_START
                ShiftType = 4;
            end

            40: begin: SRAM_START
                RegDst   = 0;
                MemtoReg = 4'b0011;
                RegWrite = 1;
            end

            41: begin: LUI_START
                ShiftQnt    = 2'b10;
                ShiftReg    = 2'b00;
                ShiftType   = 3'b001;
                ALUOutWrite = 0;
            end

            42: begin: LUI_SELECTION
                ShiftType = 010;
            end

            43: begin: SRAM_LUI_END
                RegDst = 2'b00;
                MemtoReg = 4'b0011;
                RegWrite = 1;
            end
            
        endcase
    end

endmodule