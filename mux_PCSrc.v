module mux_PCSrc(Out,Sel,In0,In1,In2,In3,In4); 

input [31:0] In0,In1,In2,In3,In4; //entradas de 32 bits
input [2:0] Sel; //seletor de 3 bits
output [31:0] Out; //saida de 32 bits

reg [31:0] Out; 

//Check the state of the input lines 

always @ (In0 or In1 or In2 or In3 or In4 or Sel) 

begin 

 case (Sel) 

  3'b000 : Out = In0; 

  3'b001 : Out = In1; 

  3'b010 : Out = In2; 

  3'b011 : Out = In3; 

  3'b100 : Out = In4; 

  default : Out = 31'bx; 

  //If input is undefined then output is undefined 

 endcase 

end  

endmodule

