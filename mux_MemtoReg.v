module mux_MemtoReg(Out,Sel,In0,In1,In2,In3,In4,In5,In6,In8); 

input [31:0] In0,In1,In2,In3,In4,In5,In6,In8; //entradas de 32 bits
input [3:0] Sel; //seletor de 4 bits
output [31:0] Out; //saida de 32 bits

reg [31:0] Out; 
reg [31:0] In7;

initial begin
    In7[31:0] = 32'b00000000000000000000000011100011; // 227
end

//Check the state of the input lines 

always @ (In0 or In1 or In2 or In3 or In4 or In5 or In6 or In7 or In8 or Sel) 

begin 

 case (Sel) 

  4'b0000 : Out = In0; 

  4'b0001 : Out = In1; 

  4'b0010 : Out = In2; 

  4'b0011 : Out = In3; 
  
  4'b0100 : Out = In4; 

  4'b0101 : Out = In5; 

  4'b0110 : Out = In6; 

  4'b0111 : Out = In7; 

  4'b1000 : Out = In8; 

  default : Out = 31'bx; 

  //If input is undefined then output is undefined 

 endcase 

end  

endmodule

