`timescale 1ns/1ns

module Scalable_Reg(CLK, EN, IN, OUT);
    parameter SIZE = 8;
    
    input CLK, EN;
    input [SIZE - 1:0] IN;
    output reg [SIZE - 1:0] OUT;
    
    always@(posedge CLK)
    begin
        if(EN)
            OUT <= IN;
    end

endmodule