`timescale 1ns / 1ns
module ROM( ROM_OE, ROM_CS, ADDR, DATA);
	
	parameter depth = 32;
	reg OUT;

	output reg [width - 1 :0] DATA;
	
	input  [4 :0] ADDR;
	input ROM_OE, ROM_CS;

	reg [depth-1:0] ROM_MEMORY [0: depth-1];  // declcaration of register file   
 
	always @(ROM_OE, ROM_CS, ADDR)
	begin
   		 if (ROM_OE)       
       			 DATA <= OUT;
        	 if (ROM_CS)			
        		DATA <= ROM_MEMORY[ADDR];
		else
			DATA<<= 32'bz;
	end
 
endmodule

