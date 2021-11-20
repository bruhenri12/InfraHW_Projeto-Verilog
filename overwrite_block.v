module overwrite_block(
    input wire [31:0] written, writer,
    input wire two_bytes,
    output wire [31:0] result);

    assign result = two_bytes ?
                    {written[31:16], writer[15:0]} :
                    {written[31:8], writer[7:0]};

endmodule