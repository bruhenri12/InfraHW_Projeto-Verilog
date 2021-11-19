module SignExtended.v (
    input wire in1,
    output wire [31:0] out
);

    assign out = (in1)? {32{1'b'}, in1}: {{32{1'b0}, in1};

endmodule