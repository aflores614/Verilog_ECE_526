`timescale 1 ns / 1ns 
module Sequence_Controller( CLK, Phase, RST, ADDR, OPCODE,  IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN, PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS);
 input CLK, RST;
 input [1:0] Phase;
 input [6:0] ADDR;
 input [3:0] OPCODE;
  
    
    output reg IR_EN;
    output reg A_EN;
    output reg B_EN;
    output reg PDR_EN;
    output reg PORT_EN;
    output reg PORT_RD;
    output reg PC_EN;
    output reg PC_LOAD;
    output reg ALU_EN;
    output reg ALU_OE;
    output reg RAM_OE;
    output reg RDR_EN;
    output reg RAM_CS;
    
    localparam[1:0] FETCH =2'b00,
                    DECODE= 2'b01,
                    EXCUTE= 2'b10,
                    UPDATE= 2'b11;
    
    localparam [3:0] OP_Load = 4'b0000,
                     OP_STORE = 4'b0001,
                     OP_ADD = 4'b0010,
                     OP_SUB = 4'b0011,
                     OP_AND = 4'b0100,
                     OP_OR = 4'b0101,
                     OP_XOR = 4'b0110,
                     OP_NOT = 4'b0111,
                     OP_B = 4'b1000,
                     OP_BZ = 4'b1001,
                     OP_BN = 4'b1010,
                     OP_BV = 4'b1011,
                     OP_BC = 4'b1100;
                     
 reg [31:0] Instruction;
 reg [31:0] MEM[63:0];
 reg DATA_PROC, LOAD, STORE, BRANCH, JUMP;
 reg [6:0] PC, ADDR_REG;

initial 
 $readmemb("MEM.data", MEM);

//always@( posedge CLK, negedge RST)
//	if(!RST)
//		Phase <= 2'b00;
//	else 
		

always@ (posedge CLK)
	case (Phase) 
		FETCH: begin	
            Instruction <= MEM[ADDR]; //address is applied to the progran memory	
			Instruction <= 	Instruction; //delay one cycle
			IR_EN <= 1'b1;
		      end

		DECODE: begin		
		  
		  case (OPCODE)
		  OP_ADD | OP_SUB | OP_AND | OP_OR | OP_XOR | OP_NOT:begin
				DATA_PROC <=1'b1;
		end
		 OP_Load: begin
				LOAD <= 1'b1;
		end				
	    OP_STORE: begin
				STORE <= 1'b1;
		end
		OP_B: begin		
			    JUMP <= 1'b1;
		end
		OP_BZ | OP_BN | OP_BV | OP_BC: begin
			 BRANCH <= 1'b1;
	   end
	   	
		default: LOAD <= 1'b0;
		
	endcase
	end	 
		 
	   EXCUTE: begin
    	if (DATA_PROC) 
		begin
		  ALU_OE <= 1'b1;
		  ALU_EN <= 1'b1;
		
		end
		
		else if (LOAD)
		begin
		  A_EN   <= 1'b1;
		  B_EN   <= 1'b1;
		  PDR_EN <= 1'b1;
		  PORT_EN<= 1'b1;
		  RDR_EN <= 1'b1;
		  RAM_CS <= 1'b0;
		
		end
		
		else if (STORE)
		begin
		  ALU_OE <=  1'b1;
		  RAM_CS <= 1'b0;
		  RAM_OE <= 1'b1;
		 
	    end
	    
		else 
		begin
		  A_EN   <= 1'b1;
		  B_EN   <= 1'b1;
		  PDR_EN <= 1'b1;
		  PORT_EN<= 1'b1;
		  RDR_EN <= 1'b1;
		  RAM_CS <= 1'b0;		 
		end		
	 
	

 end
 
    UPDATE: begin

	PC_EN <= 1'b1; //enable Program Counter Reg
	
	if (BRANCH | JUMP )
	   PC_LOAD <= 1'b1; // enable paralled load of PC
    else 
        PC_LOAD <= 1'b0;
    
	if (Phase == 2'b11) 
		if (PC_LOAD == 1'b0)
		  PC <= PC + 1;	  
		else 		
		  Instruction <=MEM[ADDR_REG];			 	
	else
	
		
 //All enables set in pervious cycles should be clear
	IR_EN   <= 1'b0;
    A_EN    <= 1'b0;
    B_EN    <= 1'b0;
   	PDR_EN  <= 1'b0;
    PORT_EN <= 1'b0;
    PORT_RD <= 1'b0;
    PC_EN   <= 1'b0;
   	PC_LOAD <= 1'b0;
    ALU_EN  <= 1'b0;
    ALU_OE  <= 1'b0;
    RAM_OE  <= 1'b0;
    RDR_EN  <= 1'b0;
    RAM_CS  <= 1'b1; 
    
    LOAD <= 1'b0;
    DATA_PROC <= 1'b0;
    BRANCH <=1'b0;
    JUMP <= 1'b0;
    
 
 end


    default: IR_EN <= IR_EN;

endcase

endmodule
		




        
   