`timescale 1ns / 1ns
module SPI_Slave(rst,sclk, clk, mosi, ssn, rdata, miso, wstrobe, wdata, addr);
	input sclk, mosi, ssn, clk, rst;
	input [15:0] rdata;
	output reg miso, wstrobe;
	output reg [6:0] addr;
	output reg [15:0] wdata;   	
	reg [15:0] rdata_temp_reg;
	reg spi_clk_falling_edge, spi_clk_rising_edge;  
	reg spi_clk, max_count;
	reg [23:0] mosi_slave_reg;
	reg [4:0] counter;
 
	
 //edge detection	
  always@(posedge clk) begin
	spi_clk <= sclk;
 	spi_clk_falling_edge <= ~sclk & spi_clk;
 	spi_clk_rising_edge <= sclk & ~spi_clk;
	end
  //---------------------------------------------------------------------
  always@(posedge rst) //reset all the outputs to zero
  if(rst ) begin
	mosi_slave_reg<=0;
	addr <= 0;
	wdata<=0;
	wstrobe<=0;
	miso <= 0;
	rdata_temp_reg<= rdata;
	end
 	
	always@(posedge clk) begin  // count the number of bits coming in from miso	
    	if (counter == 5'b11010)
        	max_count <= 1'b1;        	
    	else
        	max_count <= 1'b0;
    	end
 
 //----------------------------------------------------------------------  
	always@(posedge clk) begin
	if(spi_clk_rising_edge) begin
   	if(max_count| rst) begin
       	counter <= 0;
       	mosi_slave_reg<=0;
      	end
    	else  
        	counter <= counter + 1'b1;
    	end
 	end
  //------------------------------------------------------------------
   always@(posedge clk) begin //shift miso msb to miso_reg lsb
	if(spi_clk_rising_edge  & !ssn) begin
    	mosi_slave_reg <= {mosi_slave_reg[22:0],1'b0};
    	mosi_slave_reg[0] <= mosi;
    	if(counter < 3'd7) begin
        	addr <= mosi_slave_reg[6:0];
        	wstrobe<= mosi_slave_reg[7];
    	end
 	end
	end
 //----------------------------------------------------------------	
   always@(posedge clk) begin
	if (spi_clk_rising_edge)
 	if(wstrobe )                	
        	wdata <= mosi_slave_reg[15:0];  
 	else
    	begin
        	miso <= rdata_temp_reg[0];
        	rdata_temp_reg <= {1'b0, rdata_temp_reg[15:1]}; 
    	end    	
   end 
endmodule
