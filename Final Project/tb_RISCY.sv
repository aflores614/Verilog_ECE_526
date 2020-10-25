`timescale 1 ns/1ns
module tb_RISCY();
	reg CLK, RST;
	wire [7:0] IO;

RISC_Y UUT ( CLK, RST, IO);

	initial begin
	CLK=1'b0l; RST=1'b1;
	#10 RST=1'b0;
	#10 RST=1'b1;
	end

	always
	CLK=!CLK;

endmodule

//vcs -debug -full64 RISC_Y.sv AASD.sv alu.sv MUX.sv PC.sv Phase_Gen.sv Port_DIR_REG.sv RAM.sv ROM.sv Scalable_Reg.sv Sequence_Controller.sv TRI_buffer.sv tb_RISCY.sv