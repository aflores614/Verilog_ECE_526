`timescale 1ns / 1ns

module Port_DIR_REG(CLK, RST, PDR_EN, DATA, DATA_OUT);

    input CLK, RST, PDR_EN;
    input DATA;

    output reg DATA_OUT;          

    always @(posedge CLK or negedge RST)                
        begin
            if(!RST)
                DATA_OUT<= 1'b0;

            else if(PDR_EN) 
                DATA_OUT <= DATA;  
   
            else                 
                DATA_OUT <= DATA_OUT
        end

endmodule