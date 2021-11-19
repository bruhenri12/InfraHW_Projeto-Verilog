//ALUSrcA, ALUOSrc
module mux_2x1_1_1(Out,Sel,In0,In1); 

input In0,In1; //entradas de 1 bits
input Sel; //seletor de 1 bit
output Out; //saida de 1 bits

reg Out; 

//Check the state of the input lines 

always @ (In0 or In1 or Sel) 

begin 

 case (Sel) 

  1'b0 : Out = In0; 

  1'b1 : Out = In1; 

  default : Out = 1'bx; 

  //If input is undefined then output is undefined 

 endcase 

end  

endmodule

