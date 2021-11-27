module div (
    input wire [31:0] a,b,
    input wire init,stop,
    input wire clk, rst,
    output reg [31:0] hi,lo,
    output reg divzero
);



reg [6:0] counter, state;
reg rodando;
reg [31:0] n, d, q, r, shifted, partial;
reg equal_signs;



always @(posedge clk or posedge rst or posedge init or posedge stop) begin
    if(init) begin
        if(d == 0) begin
            divzero <= 1;
            rodando <= 0;
            q <= 0;
            r <= 0;
            hi <= 0;
            lo <= 0;
        end
        else begin
            rodando <= 1;
            counter <= 33;
            q <= 0;
            r <= 0;
        end

    end
    if(stop || rst) begin
        // reseta todas as variaveis
        rodando <= 1'b0;
        counter <= 0;
        q <= 0;
        r <= 0;
        hi <= 0;
        lo <= 0;
    end
    if(rodando) begin
        if(counter == 33) begin
            n <= (a[31] == 0) ? a : ~(a - 1); // abs of a
            d <= (b[31] == 0) ? b : ~(b - 1); // abs of b
            equal_signs = (a[31] == b[31]) ? 1 : 0;
            q <= 0;
            r <= 0;
            counter <= counter - 1;
        end

        else if(counter <= 32 && counter >= 1) begin
            shifted = r << 1;
            partial = {shifted[31:1], n[counter-1]};
            if(partial < d)
                r <= partial;
            else begin
                r <= partial - d;
                q[counter-1] <= 1'b1;
            end
            counter <= counter - 1;
        end
        
        else begin
            lo <= q;
            hi <= r;
            if(equal_signs == 0) begin
                if(r == 0) begin
                    lo <= (~q) + 1;  // negative
                end else begin
                    lo <= (~(q+1)) + 1; // plus 1 then negative
                    hi <= d - r;
                end
            end
            rodando <= 1'b0;
        end
    end
end
endmodule