`timescale 1ns / 1ns;
module RISC_Y(CLK, RST, IO);

	input CLK, RST;
	inout [7:0] IO;
	
	wire [4:0] PC_to_ROM; // PC input / output 

	wire [31:0] DATA_ROM_32; //ROM output

	//Lab 9 Squence Controller
	wire IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN, LOAD_EN;
        wire ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;

	wire ROM_OE, ROM_CS;

	wire IFLAG;

	wire SYC; //AASD to Phasor

	wire Phase; //phasor to SQ

	wire [7:0] DATA_RAM_8; //inout from RAM

	wire [7:0] DATA_MUX; //data from RAM or ROM
	
	wire [6:0] ADDR;
	
	wire P_DIR_REG_TO_TRI;
   	wire [7:0] P_DATA_REG_TO_TRI;

	wire [7:0] ROM_DATA;
    	wire [7:0] RAM_DATA;
	
	wire [7:0] A, B; // ALU

	wire [3:0] OPCODE;
	wire OF, CF, SF, ZF;
	
	PC program_counter (ADDR[4:0], CLK, PC_EN, LOAD_EN, PC_to_ROM);
	
	ROM ROM_1 (ROM_OE, ROM_CS, PC_to_ROM DATA_ROM_32);

	Scalable_Reg #(32) MEM_INST_REG (CLK, IR_EN, DATA32, {OPCODE, IFLAG, ADDR, ROM_DATA});
	
	RAM RAM_1 (ROM_DATA[4:0], RAM_OE, CLK, RAM_CS, DATA_RAM_8);
	
	Scalable_Reg #(8) RAM_Reg (CLK, RDR_EN, DATA_RAM_8, RAM_DATA);
	
	PORT_DIR_REG PDR_1 (CLK, RST, PDR_EN, DATA_MUX[0], P_DIR_REG_to_TRI);
	
	TRI_buffer t1(P_DATA_REG_TO_TRI, P_DIR_REG_TO_TRI, IO);
    
   	TRI_buffer t2(IO, PORT_RD, DATA_RAM_8);
	
	MUX mux_1(ROM_DATA, RAM_DATA, DATA_MUX, RAM_OE); 
	
	Scalable_Reg reg_A (CLK, A_EN, DATA_MUX, A);
	Scalable_Reg reg_B (CLK, B_EN, DATA_MUX, B);

	alu alu1(CLK, ALU_EN, ALU_OE, OPCODE, A, B, DATA_RAM_8, CF, OF, SF, ZF);
	
	AASD a1 (RST, CLK, SYC);
    	Phase_GEN p1(CLK, SYC, EN, Phase);
	Sequence_Controller SC (ADDR, OPCODE, Phase, {OF, SF, ZF, CF}, IFLAG, CLK, IR_EN, A_EN,B_EN, PDR_EN,PORT_EN, PORT_RD, PC_EN, LOAD_EN, ALU_EN, ALU_OE, RAM_OE,RDR_EN, RAM_CS);

	
endmodule
	
