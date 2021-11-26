module shift_left32_32 (

     input  wire [31:0] data_in,
     output wire [31:0] data_out

);
    
    wire [31:0] out1;

    assign data_out     = {data_in,2'b0};

endmodule