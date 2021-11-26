module mult (
    input wire [31:0] a,b;
    input wire init,stop;
    input wire clk, rst;
    output reg [31:0] hi,lo;
);

parameter nbits = 32;

reg [5:0] counter;
reg [64:0] A,S,P;
reg rodando;

always @(posedge clk || posedge rst || posedge init || posedge stop) begin
    if(init) 
        rodando <= 1;
        
    if(rst || stop) begin
        curstate <= 33;    
    end
    if(stop) 
        rodando <= 1'b0;

    if(rodando || init) begin
        if(counter == 33) begin
            A <= {a,{33{1'b0}}};
            S <= {~a+1, {33{1'b0}}};
            P <= {{{32{1'b0}},b},1'b0};
            counter <= counter - 1;
        end

        else if(counter <= 32 && counter >= 1) begin
            if(P[1:0] == 2'b01) 
                P <= (P + A) >> 1;
            else 
                P <= (P + S) >> 1;     
            counter <= counter - 1;
        end
        
        else begin
            hi <= P[65:33];
            lo <= P[32:1];
            rodando <= 1'b0;
        end
    end
end
endmodule