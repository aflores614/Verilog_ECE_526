`timescale 1ns/1ns 
module MUX(A, B, SEL, OUT);

	parameter SIZE = 2;

	output reg [SIZE - 1: 0]  OUT;

	input[SIZE - 1: 0] A, B;
	input SEL;
	reg [SIZE-1:0] count;

	always @(A,B, SEL) 
		if (SEL == 1) begin
			OUT = B;		
		else 
			OUT = A;

endmodule
