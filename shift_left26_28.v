module shift_left26_28 (

     input  wire [25:0] data_in,
     output wire [27:0] data_out

);
    
    wire [27:0] out1;

    assign data_out     = {data_in,2'b0};

endmodule