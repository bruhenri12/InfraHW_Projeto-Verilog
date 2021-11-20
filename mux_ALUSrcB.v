module mux_ALUSrcB(Out,Sel,In0,In2,In3); 

input [31:0] In0,In2,In3; //entradas de 32 bits
input [1:0] Sel; //seletor de 2 bits
output [31:0] Out; //saida de 32 bits

reg [31:0] Out; 
reg [31:0] In1;

initial begin
    In1[31:0] = 32'b00000000000000000000000000000100; // 4
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

