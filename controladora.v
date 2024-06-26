module controladora (
    input wire clk, Overflow, reset, div_zero,
    input wire [5:0] opcode, funct,
    output reg PCWriteCond, PCWrite, WDSrc, MemRead_Write, IRWrite,
                RegWrite, RegALoad, RegBLoad, ALUSrcA, EPCWrite, ALUOSrc, ALUOutWrite,
                GLtMux, TwoBytes, Store, DivOrM, HiLoSrc, HiLoWrite, MDRLoad,
    output reg [1:0] RegDst, ALUSrcB, ShiftQnt, ShiftReg, EQorNE, GTorLT,
    output reg [2:0] IorD, ALUOp, PCSrc, ShiftType,
    output reg [3:0] MemtoReg,
    output reg mult_init, mult_stop, div_init, div_stop
);
    
    /*
     * caue: Estou com medo dessa controladora
     * bruno: Eu também
     * eduardo: rs
     *
     *
     * Sáb nov 20 às 15:38 - Cauê: E lá vamos nós.
     * Sáb nov 27 às 05:31 - Cauê: Socorro.
    */

    parameter op0 = 6'h0;

    parameter sll_funct  = 6'h0,
              sllv_funct = 6'h4,
              sra_funct  = 6'h3,
              srav_funct = 6'h7,
              srl_funct  = 6'h2,
              sram_op    = 6'h1,
              lui_op     = 6'hf;

    parameter add_funct = 6'h20,
              and_funct = 6'h24,
              sub_funct = 6'h22,
              slt_funct = 6'h2a,
              addi_op   = 6'h8,
              addiu_op  = 6'h9,
              slti_op   = 6'ha;
    
    parameter div_funct  = 6'h1a,
              mult_funct = 6'h18,
              mfhi_fun   = 6'h10,
              mflo_fun   = 6'h12,
              divm_fun   = 6'h5;
    
    parameter jr_funct = 6'h8;
              
    parameter lb_op = 6'h20,
              lh_op = 6'h21,
              lw_op = 6'h23,
              sb_op = 6'h28,
              sh_op = 6'h29,
              sw_op = 6'h2b;

    // branchs and jumps opcodes
    parameter beq_op   = 6'h4,
              bne_op   = 6'h5,
              ble_op   = 6'h6,
              bgt_op   = 6'h7,
              j_op     = 6'h2,
              jal_op   = 6'h3;

    // break, rte e jr
    parameter break_fun = 6'hd,
              rte_fun   = 6'h13,
              jr_fun    = 6'h8;


    reg [7:0] state;
    // if you want for N cycles, set the counter to N-1
    // and go to a state where you change the state if the
    // clock is 0
    reg [6:0] counter;

    always @(posedge clk) begin: NEXT_STATE_LOGIC
        if(counter > 0)
            counter <= counter - 1;

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
                
                else if((opcode == lb_op) ||
                        (opcode == lh_op) ||
                        (opcode == lw_op) ||
                        (opcode == sb_op) ||
                        (opcode == sh_op) ||
                        (opcode == sw_op))
                    state <= 15;  // any load or store

                else if((opcode == op0) && ((funct == sll_funct) || (funct == sra_funct) || (funct == srl_funct)))
                    state = 25;  // sll, sra or srl

                else if((opcode == op0) && ((funct == sllv_funct) || (funct == srav_funct)))
                    state = 30;  // sllv, srav

                else if(opcode == sram_op)
                    state = 34;  // sram

                else if(opcode == lui_op)
                    state = 41;  // lui

                else if((opcode == addi_op) || (opcode == addiu_op))
                    state <= 73; // addi or addiu
                
                else if(opcode == beq_op)
                    state <= 53; // beq

                else if(opcode == bne_op)
                    state <= 54; // bne             

                else if(opcode == bgt_op)
                    state <= 56; // beq 
                else if(opcode == ble_op)
                    state <= 57; // ble

                else if(opcode == j_op)
                    state <= 60; // j

                else if(opcode == jal_op)
                    state <= 59; // jal
                
                //jr
                else if((opcode == op0) && (funct == jr_fun))
                    state <= 61;

                //break       
                else if((opcode == op0) && (funct == break_fun))
                    state <= 51;
                //rte
                else if((opcode == op0) && (funct == rte_fun))
                    state <= 52;

                //mult
                else if((opcode == op0) && (funct == mult_funct))
                    state <= 62;
                
                //and
                else if((opcode == op0) && (funct == and_funct))
                    state <= 10;

                //sub
                else if((opcode == op0) && (funct == sub_funct))
                    state <= 44;

                //slt
                else if((opcode == op0) && (funct == slt_funct))
                    state <= 47;

                else if(opcode == slti_op)
                    state <= 49; // slti
                
                else if((opcode == op0) && (funct == mfhi_fun))
                    state <= 72; //mfhi
                
                else if((opcode == op0) && (funct == mflo_fun))
                    state <= 71; //mflo

                else if((opcode == op0) && (funct == div_funct))
                    state <= 64; //div

                else if((opcode == op0) && (funct == divm_fun))
                    state <= 65; //divm

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

            10: begin
                state <= 6;
            end

            11: begin: GO_TO_TRATAMENTO_DE_EXCECAO_PADRAO_11
                state <= 12;
            end

            12: begin
                state <= 13;    
            end

            13: begin
                state <= 14;
            end

            14: begin: GO_TO_START_14
                state <= 1;
            end

            15: begin
                if(opcode == sw_op)
                    state <= 17;
                else
                    state <= 16;
            end

            16: begin
                state <= 18;
            end

            17: begin
                state <= 1;
            end

            18: begin
                state <= 19;
            end

            19: begin
                if(opcode == lw_op)
                    state <= 20;
                else if(opcode == lh_op)
                    state <= 21;
                else if(opcode == lb_op)
                    state <= 22;
                else if(opcode == sh_op)
                    state <= 23;
                else if(opcode == sb_op)
                    state <= 24;
                else
                    state <= 0;
            end

            20: begin
                state <= 1;
            end

            21: begin
                state <= 1;
            end

            22: begin
                state <= 1;
            end

            23: begin
                state <= 1;
            end

            24: begin
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
                state <= 33;
            end

            32: begin
                state <= 33;
            end

            33: begin: GO_TO_START_24
                state <= 1;
            end

            34: begin
                state <= 35;
            end

            35: begin
                state <= 36;
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

            44: begin
                if(Overflow)
                    state <= 7;  // overflow
                else
                    state <= 6;  // continue sub
            end

            47: begin
                state <= 6;
            end

            49: begin
                state <= 8;
            end

            73: begin: GO_TO_START_73
                if(opcode == addi_op) begin
                    if(Overflow)
                        state <= 7;  // overflow
                    else
                        state <= 8;  // addi
                end
                else
                    state <= 8;  // addiu
            end

            53: begin
                state <= 1;
            end 

            54: begin
                state <= 1;
            end

            56: begin
                state <= 1;
            end 

            57: begin
                state <= 1;
            end

            59: begin //jal_beginning
                state <= 60; 
            end
            60: begin //jump or jal_end
                state <= 1; 
            end

            61: begin 
                state <= 1;
            end

            51: begin
                state <= 1;
            end

            52: begin 
                state <= 1;
            end 
            
            62: begin
                state <= 74;
            end

            74: begin
                if(counter == 0)
                    state <= 63;
            end

            63: begin
                state <= 1;
            end  

            71: begin
                state <= 1;
            end          

            72: begin
                state <= 1;
            end
            
            64: begin
                state <= 99;
            end

            65: begin
                state <= 66;
            end

            66: begin
                state <= 67;
            end
            67: begin
                state <= 68;
            end
            68: begin
                state <= 99;
            end

            99: begin
                if(div_zero == 1)
                    state <= 70;
                else if(counter == 0)
                    state <= 69;
            end
            69: begin
                state <= 1;      
            end

            70: begin
                state <= 12;
            end

            default: state <= 0;
        endcase
    end

    always @(posedge reset) begin
        counter <= 0;
        state   <= 0;
    end

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

                counter <= 0;
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

            10: begin: AND
                ALUSrcA      = 1;
                ALUSrcB      = 0;
                ALUOp        = 3'b011;
                ALUOSrc      = 0;
                ALUOutWrite  = 1;
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

            15: begin
                ALUSrcA     = 1;
                ALUSrcB     = 2;
                ALUOp       = 1;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
            end

            16: begin
                IorD         = 1;
                MemRead_Write = 0;
                ALUOutWrite  = 0;
            end

            17: begin
                WDSrc        = 0;
                IorD         = 1;
                MemRead_Write = 1;
                ALUOutWrite  = 1;
            end

            18: begin
                // wait
            end

            19: begin
                MDRLoad = 1;
            end

            20: begin
                MemtoReg = 1;
                RegDst   = 0;
                RegWrite = 1;
                MDRLoad  = 0;
            end

            21: begin
                Store    = 0;
                TwoBytes = 1;
                MemtoReg = 2;
                RegDst   = 0;
                RegWrite = 1;
                MDRLoad  = 0;
            end

            22: begin
                Store    = 0;
                TwoBytes = 0;
                MemtoReg = 2;
                RegDst   = 0;
                RegWrite = 1;
                MDRLoad  = 0;
            end

            23: begin
                Store         = 1;
                TwoBytes      = 1;
                WDSrc         = 1;
                IorD          = 1;
                MemRead_Write = 1;
                MDRLoad       = 0;
            end

            24: begin
                Store         = 1;
                TwoBytes      = 0;
                WDSrc         = 1;
                IorD          = 1;
                MemRead_Write = 1;
                MDRLoad       = 0;
            end

            25: begin: SLL_SRA_SRL_START
                ShiftQnt    = 2'b01;
                ShiftReg    = 2'b10;
                ShiftType   = 3'b001;
                ALUOutWrite = 0;
            end

            26: begin
                ShiftType = 3'b010;
            end

            27: begin
                ShiftType = 3'b100;
            end

            28: begin
                ShiftType = 3'b011;
            end

            29: begin
                RegDst   = 2'b01;
                MemtoReg = 4'b0011;
                RegWrite = 1;
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
                ShiftType = 3'b100;
            end

            33: begin: SLL_SRA_SRL_SLLV_SRAV_END
                RegDst      = 2'b01;
                MemtoReg    = 4'b0011;
                RegWrite    = 1;
            end

            34: begin: SRAM_START_34
                RegALoad    = 0;
                RegBLoad    = 0;
                ALUSrcA     = 1;
                ALUSrcB     = 2;
                ALUOp       = 1;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
            end

            35: begin: SRAM_START_35
                ALUOutWrite   = 0;
                IorD          = 1;
                MemRead_Write = 0;
            end

            36: begin: SRAM_START_36
                // wait
            end

            37: begin: SRAM_START_37
                MDRLoad = 1;
            end

            38: begin: SRAM_START_38
                MDRLoad   = 0;
                ShiftQnt  = 0;
                ShiftReg  = 2;
                ShiftType = 1;
            end

            39: begin: SRAM_START_39
                ShiftType = 4;
            end

            40: begin: SRAM_START_40
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
                ShiftType   = 3'b010;
            end

            43: begin: SRAM_LUI_END
                RegDst      = 2'b00;
                MemtoReg    = 4'b0011;
                RegWrite    = 1;
            end

            44: begin: SUB
                ALUSrcA     = 1;
                ALUSrcB     = 0;
                ALUOp       = 3'b010;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
            end

            47: begin: SLT
                ALUSrcA     = 1;
                ALUSrcB     = 0;
                ALUOp       = 3'b111;
                GLtMux      = 0;
                ALUOSrc     = 1;
                ALUOutWrite = 1;
            end

            49: begin: SLTI
                ALUSrcA     = 1;
                ALUSrcB     = 2;
                ALUOp       = 3'b111;
                GLtMux      = 0;
                ALUOSrc     = 1;
                ALUOutWrite = 1;
            end

            73: begin: ADDI_OR_ADDIU
                ALUSrcA     = 1;
                ALUSrcB     = 2;
                ALUOp       = 1;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
            end
            
            // caue:
            53: begin: BEQ
                ALUSrcA     = 1;
                ALUSrcB     = 0;
                ALUOp       = 3'b010;
                PCSrc       = 1;
                ALUOutWrite = 0;
                EQorNE      = 2'b10;
                PCWriteCond = 1;
            end

            54: begin: BNQ
                ALUSrcA     = 1;
                ALUSrcB     = 0;
                ALUOp       = 3'b010;
                PCSrc       = 1;
                ALUOutWrite = 0;
                EQorNE      = 2'b01;
                PCWriteCond = 1;
            end


            56: begin: BGT
                ALUSrcA     = 1;
                ALUSrcB     = 0;
                ALUOp       = 3'b111;
                PCSrc       = 1;
                ALUOutWrite = 0;
                GTorLT      = 2'b10;
                PCWriteCond = 1;
            end

            57: begin: BLE
                ALUSrcA     = 1;
                ALUSrcB     = 0;
                ALUOp       = 3'b111;
                PCSrc       = 1;
                ALUOutWrite = 0;
                GTorLT      = 2'b01;
                PCWriteCond = 1;
            end

            59: begin: JAL
                RegDst = 2;
                MemtoReg = 6;
                RegWrite = 1;
                ALUOutWrite = 0;
            end

            60: begin: Jump_or_Jal
                PCSrc = 2;
                PCWrite = 1;
                RegWrite = 0;
                ALUOutWrite = 0;
            end

            61: begin: JR
                ALUSrcA = 1;
                ALUOp = 3'b000;
                PCSrc = 0;
                PCWrite = 1;
                ALUOutWrite = 0;
            end

            51: begin: Break
                ALUSrcA = 0;
                ALUSrcB = 1;
                ALUOp = 3'b010;
                PCSrc = 0;
                PCWrite = 1;
                ALUOutWrite = 0;                
            end

            52: begin: rte
                PCSrc = 4;
                PCWrite = 1;
                ALUOutWrite = 0;
            end

            62: begin
                ALUOutWrite = 0;
                mult_init = 1;
                counter = 33; 
            end

            74: begin
                mult_init = 0;
            end

            63: begin
                HiLoSrc = 1;
                HiLoWrite = 1;
            end


            72: begin
                MemtoReg = 4;
                RegWrite = 1;
                RegDst = 1;
                ALUOutWrite = 0;  
            end

            71: begin
                MemtoReg = 5;
                RegWrite = 1;
                RegDst = 1;
                ALUOutWrite = 0;
            end

            64: begin
                DivOrM = 1;
                ALUOutWrite = 0;
                div_init = 1'b1;
                counter = 33; 
            end

            65: begin
                IorD = 5;
                MemRead_Write = 0;
                ALUOutWrite = 0;
            end 

            66: begin
                IorD = 6;
                MemRead_Write = 0;
            end
            
            67: begin
                MDRLoad = 1;
            end
            
            68: begin
                DivOrM = 0;
                MDRLoad = 0;
                div_init = 1'b1;
                counter = 33; 
            end    


            69: begin
                HiLoSrc = 0;
                HiLoWrite = 1;
            end 

            99: begin
                if(div_zero == 1'b1) begin
                    counter <= 0;
                end
                div_init = 1'b0;
            end

            70: begin
                div_init = 1'b0;
                IorD = 4;
                MemRead_Write = 0;
                ALUSrcA = 0;
                ALUSrcB = 1;
                ALUOp = 3'b010;
                EPCWrite = 1;
            end

        endcase
    end

endmodule