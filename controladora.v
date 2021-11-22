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

    parameter add_funct  = 6'h20,
              and_funct  = 6'h24,
              div_funct  = 6'h1a,
              mult_funct = 6'h18,
              jr_funct   = 6'h8,
              addi_op    = 6'b001000,
              addiu_op   = 6'b001001,
              op0        = 6'h0;

    reg [7:0] state, next_state;

    initial begin
        state = 0;
    end

    always @(posedge reset) begin
        state = 0;
        next_state = 0;
    end

    always @(posedge clk) begin: OUTPUT_LOGIC_AND_NEXT_STATE_LOGIC
        state = next_state;
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
                // output
                RegDst   = 2'b11;
                MemtoReg = 4'b0111;
                RegWrite = 1;
                // next state
                next_state = 1;
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
                // output
                PCWrite       = 1;
                IorD          = 0;
                MemRead_Write = 0;
                ALUSrcA       = 0;
                ALUSrcB       = 1;
                PCSrc         = 0;
                ALUOp         = 1;
                // next state
                next_state = 2;
            end

            2: begin
                // output
                PCWrite       = 0;
                // next state
                next_state    = 3;
            end

            3: begin
                // output
                IRWrite    = 1;
                // next state
                next_state = 4;
            end

            4: begin: END_OF_CICLOS_COMUNS
                // output
                IRWrite     = 0;
                ALUSrcA     = 0;
                ALUSrcB     = 3;
                ALUOp       = 1;
                ALUOSrc     = 0;
                RegALoad    = 1;
                RegBLoad    = 1;
                ALUOutWrite = 1;
                // next state
                if((opcode == op0) && (funct == add_funct)) begin
                    next_state = 5;  // add
                end else if((opcode == addi_op) || (opcode == addiu_op)) begin
                    next_state = 73;  // addi or addiu
                end else begin // opcode inexistente
                    next_state = 11;
                end
            end

            5: begin: ADD
                // output
                ALUSrcA     = 1;
                ALUSrcB     = 0;
                ALUOp       = 1;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
                // next state
                if(Overflow)
                    next_state = 7;  // overflow
                else
                    next_state = 6;  // continue add
            end

            6: begin: END_OF_ADD
                // output
                ALUOutWrite = 0;
                MemtoReg    = 0;
                RegDst      = 1;
                RegWrite    = 1;
                // next state
                next_state = 1;  // start
            end

            73: begin: ADDI_OR_ADDIU
                // output
                ALUSrcA     = 1;
                ALUSrcB     = 2;
                ALUOp       = 1;
                ALUOSrc     = 0;
                ALUOutWrite = 1;
                // next state
                if(opcode == addi_op) begin
                    if(Overflow)
                        next_state = 7;  // overflow
                    else
                        next_state = 8;  // addi
                end
                else
                    next_state = 9;  // addiu
            end

            7: begin: OVERFLOW
                // output
                ALUOutWrite   = 0;
                ALUSrcA       = 0;
                ALUSrcB       = 1;
                ALUOp         = 3'b010;
                EPCWrite      = 1;
                IorD          = 3;
                MemRead_Write = 0;
                // next state
                next_state = 12;
            end

            8: begin: END_OF_ADDI
                // output
                ALUOutWrite = 0;
                MemtoReg    = 0;
                RegDst      = 0;
                RegWrite    = 1;
                // next_state
                next_state = 1; // start
            end

            11: begin: OPCODE_INEXISTENTE
                // output
                IorD           = 2;
                MemRead_Write  = 0;
                ALUSrcA        = 0;
                ALUSrcB        = 1;
                ALUOp          = 3'b010;
                EPCWrite       = 1;
                // next state
                next_state = 12;
            end

            12: begin: TRATAMENTO_DE_EXCECAO_PADRAO
                // output
                EPCWrite       = 0;
                // next state
                next_state = 13;
            end

            13: begin
                // output
                MDRLoad = 1;
                // next state
                next_state = 14;
            end

            14: begin: END_OF_TRATAMENTO_DE_EXCECAO_PADRAO
                // output
                MDRLoad  = 0;
                Store    = 0;
                TwoBytes = 0;
                PCSrc    = 3;
                PCWrite  = 1;
                // next state
                next_state = 1;
            end
            default: next_state = 0;
        endcase
    end

endmodule