module mux_PCSrc(Out,Sel,In0,In1,In2,In3); 

input [4:0] In0,In1,In2,In3; //entradas de 32 bits
input [1:0] Sel; //seletor de 3 bits
output [4:0] Out; //saida de 32 bits

reg [4:0] Out; 

initial begin
    In2[31:0] = 5'b10000; // 16
end

//Check the state of the input lines 

always @ (In0 or In1 or In2 or In3 or Sel) 

begin 
 case (Sel) 

  2'b00 : Out = In0; 

  2'b01 : Out = In1; 

  2'b10 : Out = In2; 

  2'b11 : Out = In3; 

  default : Out = 5'bx; 

 endcase 
end  

endmodule

