`timescale  1ns / 1ps
module arctan_tb;

// Parameters
localparam  K = 39796;

// Ports
reg clk = 0;
reg rst_n = 0;
wire valid;
reg [31:0] tan;
wire [31:0] xita;

arctan 
#(
  .K (
      K )
)
arctan_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .valid (valid ),
  .tan (tan ),
  .xita  ( xita)
);

initial begin
  begin
      $dumpfile("arctan_tb.vcd");
      $dumpvars(0,arctan_tb);
      rst_n=1;
      #10 
      rst_n=0;
      #10
      rst_n=1;
      tan=32'h0001_0000;
      #10000
      tan=113512;
      #10000
      tan=37837;
      #10000
      tan=32'h8001_0000;
      #10000
      tan=32'h0002_0000;
      #10000
      tan=32'h0036_9AAA;
      #10000
      $finish;
  end
end

always
  #1  clk = ! clk ;

endmodule
