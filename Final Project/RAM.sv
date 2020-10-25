`timescale 1ns / 1ns
module RAM(ADDR, RAM_OE, WS, RAM_CS, DATA);

	parameter width = 8;
	parameter depth = 32;
	
	inout [width -1 :0] DATA;

	input  [depth -1 :0] ADDR;

	input RAM_OE, RAM_CS, WS;

	reg [width-1:0] MEMORY [depth - 1 : 0];  // declcaration of register file
	reg [width-1:0] MY_BYTE;   //register to store data

	assign DATA = RAM_CS ? MEMORY[ADDR]: 8'bz;

	always @(posedge WS)
		begin
    		if (RAM_OE) 
       			 MEMORY[ADDR] <= DATA; 
   		 else 
   			 MEMORY[ADDR] <=  MEMORY[ADDR];
   		end 
	
endmodule


