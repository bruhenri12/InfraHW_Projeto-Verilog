`include "../mux_2x1_32_32.v"
`include "../mux_IorD.v"
`include "../mux_RegDst.v"
`include "../mux_ALUSrcB.v"
`include "../mux_MemtoReg.v"
`include "../mux_PCSrc.v"
`include "../componentes/Banco_reg.vhd"
`include "../componentes/Instr_Reg.vhd"
`include "../componentes/Memoria.vhd"
`include "../componentes/Registrador.vhd"
`include "../componentes/Ula32.vhd"


module controladora(input wire clk, rst, RegWrite, PCWrite, MemRead, ALUSrcA,
                    input wire IRWrite, ALUOSrc, RegALoad, RegBLoad, ALUOutLoad
                    input wire [1:0] RegDst, ALUSrcB,
                    input wire [2:0] IorD, PCSrc, ALUOp,
                    input wire [3:0] MemtoReg,
                    output wire result);

    Banco_reg bnc_reg()

endmodule