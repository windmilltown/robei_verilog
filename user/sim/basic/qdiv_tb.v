`timescale 1ns/1ps
module qdiv_tb;

  // Parameters
  localparam  WIDTH = 31;
  localparam  FBITS = 16;

  // Ports
  reg clk = 0;
  reg rst_n = 0;
  reg [31:0] dividend;
  reg [31:0] divisor;
  wire [31:0] quotient;
  wire valid;
  wire warn;
  wire busy;

  qdiv 
  #(
    .WIDTH(WIDTH ),
    .FBITS (
        FBITS )
  )
  qdiv_dut (
    .clk (clk ),
    .rst_n (rst_n ),
    .dividend (dividend ),
    .divisor (divisor ),
    .quotient (quotient ),
    .valid (valid ),
    .warn (warn ),
    .busy  ( busy)
  );

  initial begin
    begin
        $dumpfile("qdiv_tb.vcd");
        $dumpvars(0, qdiv_tb);
        rst_n=0;
        #10
        rst_n=1;
        dividend=32'h00080000;
        divisor=32'h00020000;
        #1000
        dividend=32'h00070000;
        divisor=32'h00030000;
        #1000
        $finish;
    end
  end

  always
    #1  clk = ! clk ;

endmodule
