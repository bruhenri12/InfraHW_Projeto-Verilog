//ALUSrcA, ALUOSrc
module mux_2x1_32_32(Out,Sel,In0,In1); 

input [31:0] In0,In1; //entradas de 32 bits
input Sel; //seletor de 1 bit
output [31:0] Out; //saida de 32 bits

reg [31:0] Out; 

//Check the state of the input lines 

always @ (In0 or In1 or Sel) 

begin 

 case (Sel) 

  1'b0 : Out = In0; 

  1'b1 : Out = In1; 

  default : Out = 31'bx; 

  //If input is undefined then output is undefined 

 endcase 

end  

endmodule

