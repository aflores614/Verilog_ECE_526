`timescale 1ns/1ns

module TRI_buffer(IN, EN, OUT);

	parameter SIZE = 8;

	input [SIZE - 1:0] IN;
	input EN;
	output [SIZE - 1:0] OUT;

	assign OUT = EN? IN : 8'bz;
endmodule