module mux_PCSrc(Out,Sel,In0,In1,In2); 

input [31:0] In0,In1,In2; //entradas de 32 bits
input [1:0] Sel; //seletor de 3 bits
output [31:0] Out; //saida de 32 bits

reg [31:0] Out; 

//Check the state of the input lines 

always @ (In0 or In1 or In2 or Sel) 

begin 

 case (Sel) 

  2'b00 : Out = In0; 

  2'b01 : Out = In1; 

  2'b10 : Out = In2; 

  default : Out = 31'bx; 

  //If input is undefined then output is undefined 

 endcase 

end  

endmodule

