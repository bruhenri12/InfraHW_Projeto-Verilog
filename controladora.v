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

    // TODO deixar tudo hexadecimal
    parameter  add_funct  = 6'h20;
    parameter  and_funct  = 6'h24;
    parameter  div_funct  = 6'h1a;
    parameter  mult_funct = 6'h18;
    parameter  jr_funct   = 6'h8;
    parameter  addi_op    = 6'b001000;
    parameter  addiu_op   = 6'b001001;
    parameter  op0        = 6'h0;

    reg [7:0] state;

    // TODO deletar
    initial begin
        state = 0;
    end

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

            // TODO tirar begins e ends
            4: begin: END_OF_CICLOS_COMUNS
                if((opcode == op0) && (funct == add_funct)) begin
                    state <= 5;  // add
                end else if((opcode == addi_op) || (opcode == addiu_op)) begin
                    state <= 73;  // addi or addiu
                end else begin // opcode inexistente
                    state <= 11;
                end
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
            
        endcase
    end

endmodule