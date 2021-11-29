module SignExtended_1_32 (
    input wire in1,
    output wire [31:0] out
);

    assign out = {{32{1'b0}}, in1};

endmodule