module div (
    input wire [31:0] n,d,
    input wire init,stop,
    input wire clk, rst,
    output reg [31:0] hi,lo,
    output reg divzero
);



reg [6:0] counter, state;
reg rodando;
reg [31:0] q,r;
reg sinal;



always @(posedge clk or posedge rst or posedge init or posedge stop) begin
    if(init) begin
        if(d == 0) 
            divzero <= 1;
            q <= 0;
            r <= 0;
            hi <= 0;
            lo <= 0;

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
            q <= 0;
            r <= 0;
            counter <= counter - 1;
        end

        else if(counter <= 32 && counter >= 1) begin
            if(d < r) begin
                r <= {(r << 1)[31:1], n[counter-1]};
            end
            else begin
                r <= {(r << 1)[31:1], n[counter-1]} - d;
                q[counter-1] <= 1'b1;
            end
            counter <= counter - 1;
        end
        
        else begin
           hi <= r;
           lo <= q;
           rodando <= 1'b0;
        end
    end
end
endmodule