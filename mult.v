module mult (
    input wire [31:0] a,b,
    input wire init,stop,
    input wire clk, rst,
    output reg [31:0] hi,lo
);

parameter nbits = 32;

reg [6:0] counter;
reg signed [64:0] A,S,P;
reg rodando;

always @(posedge clk or posedge rst or posedge init or posedge stop) begin
    if(init) begin
        rodando <= 1;
        counter <= 33;
    end
    if(stop || rst) begin
        rodando <= 1'b0;
        counter <= 0;
        A <= 0;
        S <= 0;
        P <= 0;
        hi <= 0;
        lo <= 0;
    end
    if(rodando) begin
        if(counter == 33) begin
            A <= {a,{33{1'b0}}};
            S <= {-a, {33{1'b0}}};
            P <= {{{32{1'b0}},b},1'b0};
            counter <= counter - 1;
        end

        else if(counter <= 32 && counter >= 1) begin
            if(P[1:0] == 2'b01) 
                P <= (P + A) >>> 1;
            else if(P[1:0] == 2'b10)
                P <= (P + S) >>> 1;     
            counter <= counter - 1;
        end
        
        else begin
            hi <= P[64:33];
            lo <= P[32:1];
            rodando <= 1'b0;
        end
    end
end
endmodule