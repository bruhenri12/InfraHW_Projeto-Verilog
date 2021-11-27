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
reg ab_signs;



always @(posedge clk or posedge rst or posedge init or posedge stop) begin
    if(init) begin
        rodando <= 1;
        q <= 0;
        r <= 0;
        hi <= 0;
        lo <= 0;
        counter <= 33;

    end
    if(stop || rst) begin
        // reseta todas as variaveis
        divzero <= 0;
        rodando <= 1'b0;
        counter <= 0;
        q <= 0;
        r <= 0;
        hi <= 0;
        lo <= 0;
    end
    if(divzero == 1) begin
        divzero <= 0;
    end
    if(rodando) begin
        if(b == 0) begin
            divzero <= 1;
            rodando <= 0;
        end
        if(counter == 33) begin
            n <= (a[31] == 0) ? a : ~(a - 1); // abs of a
            d <= (b[31] == 0) ? b : ~(b - 1); // abs of b
            ab_signs = {a[31], b[31]};
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
            if((ab_signs == 2'b00) || (ab_signs == 2'b11)) begin
                lo <= q;
                hi <= r;
            end
            else if(ab_signs == 2'b01) begin
                lo <= (~q) + 1;  // negative
                hi <= r;
            end
            else begin  // ab_signs == 2'b10
                if(r == 0) begin
                    lo <= (~q) + 1;
                    hi <= r;
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