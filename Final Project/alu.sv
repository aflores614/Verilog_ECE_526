`timescale 1 ns / 100 ps
module alu(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);
	parameter WIDTH=9;
	localparam [3:0] OPcode_ADD = 4'b0010, 
	                 OPcode_SUB = 4'b0011,
	                 OPcode_AND = 4'b0100,
	                 OPcode_OR  = 4'b0101,
	                 OPcode_XOR = 4'b0110,
	                 OPcode_NOT = 4'b0111;
	
	output reg [WIDTH - 1 : 0 ] ALU_OUT;
	output reg CF, OF, SF, ZF;
	input[3:0] OPCODE;
	input [WIDTH - 1: 0] A, B;
	input CLK, EN, OE;

always @(posedge CLK)
begin

if (EN ==1'b1) //enable input

	if (OE ==1'b1) // enable output
	
		case(OPCODE)
//--------------------------------------------------------		
			OPcode_ADD: begin
			ALU_OUT <= A+B; //addition			
			ZF <= (ALU_OUT == 9'b0);
			CF <= ALU_OUT[WIDTH-1];
			SF = 1'b0 ? (ALU_OUT[WIDTH-1] == 1'b0): 1'b1;		
			OF = 1'b1 ? ( A[WIDTH-1] == B[WIDTH-1] && A[WIDTH-1] != ALU_OUT[WIDTH-1]): 1'b0; 
			end        
//--------------------------------------------------------			
			OPcode_SUB:begin
			ALU_OUT <= A-B; //subraction
			ZF <= (ALU_OUT == 9'b0);
			CF <= (A < B);
			SF = 1'b0 ? (ALU_OUT[WIDTH-1] == 1'b0): 1'b1;		
			OF = 1'b1 ? ( A[WIDTH-1] == B[WIDTH-1] && A[8] != ALU_OUT[8] ) : 1'b0;
			  
			end
//--------------------------------------------------------			
			OPcode_AND:begin
			ALU_OUT <= A & B; //AND
			ZF <= (ALU_OUT == 9'b0);
			OF <= 1'b0;
			CF <= 1'b0;
			SF = 1'b0 ? (ALU_OUT[WIDTH-1] == 1'b0): 1'b1;			         		
			end
			
//--------------------------------------------------------			
			OPcode_OR:begin
			ALU_OUT <= A | B; //OR
			ZF <= (ALU_OUT == 9'b0);
			OF <= 1'b0;
			CF <= 1'b0;
			SF = 1'b0 ? (ALU_OUT[WIDTH-1] == 1'b0): 1'b1;
			        
			end
//--------------------------------------------------------			
			OPcode_XOR:begin
			ALU_OUT <= ~(A | B); //XOR
			ZF <= (ALU_OUT == 9'b0);
			OF <= 1'b0;
			CF <= 1'b0;
			SF = 1'b0 ? (ALU_OUT[WIDTH-1] == 1'b0): 1'b1;
			end
//--------------------------------------------------------			
			OPcode_NOT:begin
			ALU_OUT <= ~A;  //NOT
			ZF <= (ALU_OUT == 9'b0);
			OF <= 1'b0;
			CF <= 1'b0;
			SF = 1'b0 ? (ALU_OUT[WIDTH-1] == 1'b0): 1'b1;
			end
//--------------------------------------------------------			

		default: ALU_OUT <= ALU_OUT;
		
	endcase
	
    else 
        ALU_OUT <= 9'bz; // if output is disable it will go high impedance 
 else 
	ALU_OUT <= ALU_OUT;	 // input disable the output will be stay the same
end
endmodule