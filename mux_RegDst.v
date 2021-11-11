module mux_RegDst(Out,Sel,In0,In1); 

input [4:0] In0,In1; //entradas de 5 bits
input [1:0] Sel; //seletor de 2 bits
output [4:0] Out; //saida de 5 bits

reg [4:0] Out; 
reg [4:0] In2,In3;

initial begin
    In2[4:0] = 5'b11111; // 31
    In3[4:0] = 5'b11101; // 29
end

//Check the state of the input lines 

always @ (In0 or In1 or In2 or In3 or Sel) 

begin 

 case (Sel) 

  2'b00 : Out = In0; 

  2'b01 : Out = In1; 

  2'b10 : Out = In2; 

  2'b11 : Out = In3; 

  default : Out = 31'bx; 

  //If input is undefined then output is undefined 

 endcase 

end  

endmodule

