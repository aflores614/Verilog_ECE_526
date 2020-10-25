`timescale 1ns / 1ns

module Phase_Gen( EN, CLK, RST, PHASE);
    input EN, CLK, RST;
    output reg [1:0] PHASE;
 
 always @( posedge CLK, negedge RST)
 
    if (!RST) 
        PHASE <= 2'b00;
    else 
    begin
        if (PHASE <= 2'b11 )
           PHASE <= PHASE + 1'b1;
          else
            PHASE <= 2'b00;
     end  
  
//Sequence_Controller P1(.Phase(PHASE));

    
endmodule
