`timescale 1 ns/1 ns

module PC(ADDR, CLK, PC_EN, LOAD_EN, ADDR_OUT);

	input CLK, PC_EN, LOAD_EN;
	input [4:0]  ADDR;

	output reg [4:0] ADDR_OUT; 
			

	always @(posedge CLK)				
		begin
			if(PC_EN) 
			begin
				if (LOAD_EN) 
					ADDR_OUT <= ADDR;
				else
					ADDR_OUT = ADDR_OUT + 5'b1; 	
			end		
			else 					
				ADDR_OUT <= ADDR_OUT 
		end
endmodule