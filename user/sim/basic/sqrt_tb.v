`timescale 1ns / 1ps
module sqrt_tb;

// Parameters

// Ports
reg clk = 0;
reg rst_n = 0;
reg [31:0] sqrter;
wire [31:0] sqrted;

sqrt 
sqrt_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .sqrter (sqrter ),
  .sqrted  ( sqrted)
);

initial begin
  begin
      $dumpfile("sqrt_tb.vcd");
      $dumpvars(0, sqrt_tb);
      rst_n=0;
      #10
      rst_n=1;
      sqrter=32'h00040000;
      #10000
      sqrter=32'h00070000;
      #10000
      sqrter=32'h00100000;
      #10000
      $finish;
  end
end

always
  #1  clk = ! clk ;

endmodule

