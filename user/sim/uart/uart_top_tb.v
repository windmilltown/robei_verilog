`timescale 1ns/1ps
module uart_top_tb;

// Parameters

// Ports
reg clk50 = 0;
reg rst_n = 0;
reg rx = 0;
reg clr = 0;
wire tx;
wire [31:0] x;
wire [31:0] y;
wire [31:0] z;
wire valid;

uart_top 
uart_top_dut (
  .clk50 (clk50 ),
  .rst_n (rst_n ),
  .rx (rx ),
  .clr (clr ),
  .tx (tx ),
  .x (x ),
  .y (y ),
  .z (z ),
  .valid  ( valid)
);

initial begin
  begin
    $finish;
  end
end

always
  #1  clk50 = ! clk50 ;

endmodule
