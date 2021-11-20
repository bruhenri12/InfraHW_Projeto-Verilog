module SignExtended_16_32 (
    input wire [15:0] in1,
    output wire [31:0] out
);

    assign out = (in1[15])? {{16{1'b1}}, in1}: {{16{1'b0}}, in1};

endmodule