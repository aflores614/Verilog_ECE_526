`timescale 1ns/1ns

module aasd(RST, CLK, SYNC);
	input RST, CLK;
	output reg SYNC;
	reg A;
	
	always @(posedge CLK or negedge RST)
	begin
		if(!RST) 
		begin
			A<= 1'b0;
			SYNC <= 1'b0;
		end
		else
		begin
			A<= 1'b1;
			SYNC <= A;
		end
	
	end
	
endmodule