`timescale 1ns/1ps
module uart_asc_num_tb;

// Parameters

// Ports
reg clk = 0;
reg rst_n = 0;
reg [7:0] asc;
reg start = 0;
reg dataerror = 0;
reg frameerror = 0;
reg clr = 0;
wire [31:0] xdataout;
wire [31:0] ydataout;
wire [31:0] zdataout;
wire valid;

uart_asc_num 
uart_asc_num_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .asc (asc ),
  .start (start ),
  .dataerror (dataerror ),
  .frameerror (frameerror ),
  .clr (clr ),
  .xdataout (xdataout ),
  .ydataout (ydataout ),
  .zdataout (zdataout ),
  .valid  ( valid)
);

  initial begin
    begin
        $dumpfile("uart_asc_num_tb.vcd");
        $dumpvars(0, uart_asc_num_tb);
        rst_n = 0;
        #10 
        rst_n = 1;
        dataerror = 0;
        frameerror = 0;
        clr = 0;
        start=0;
        #10
        asc = 8'd48;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd48;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd48;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #100
        
        start=0;
        #10
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd48;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd48;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd97;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd65;
        start = 1;
        #100
        
        start=0;
        #10
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd48;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd48;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd49;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd97;
        start = 1;
        #10
        start = 0;
        #100
        asc = 8'd65;
        start = 1;
        #100
        $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
