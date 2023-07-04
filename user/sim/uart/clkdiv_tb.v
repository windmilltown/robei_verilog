`timescale 1ns/1ps
module clkdiv_tb;

// Parameters

// Ports
reg clk50 = 0;
reg rst_n = 0;
wire clkout;

clkdiv 
clkdiv_dut (
  .clk50 (clk50 ),
  .rst_n (rst_n ),
  .clkout  ( clkout)
);

initial begin
  begin
    $dumpfile("clkdiv_tb.vcd");
    $dumpvars(0, clkdiv_tb);
    rst_n = 0;
    #10
    rst_n = 1;
    #100000
    $finish;
  end
end

always
  #5  clk50 = ! clk50 ;

endmodule
