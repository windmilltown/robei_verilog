`timescale 1ns / 1ps
module arcsin_tb;

// Parameters

// Ports
reg clk = 0;
reg rst_n = 0;
wire valid;
reg [31:0] value_sin;
wire [31:0] xita;

arcsin 
arcsin_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .valid (valid ),
  .value_sin (value_sin ),
  .xita  ( xita)
);

initial begin
  begin
      $dumpfile("arcsin_tb.vcd");
      $dumpvars(0,arcsin_tb);
      rst_n=1;
      #10
      rst_n=0;
      #10
      rst_n=1;
      value_sin=32'h0000_0000;
      #10000
      value_sin=32'd46340;
      #10000
      value_sin=32'h0000_8000;
      #10000
      value_sin=32'd56755;
      #10000
      value_sin=32'h0001_0000;
      #10000
      value_sin=32'd56754;
      #10000
      value_sin=32'd46340;
      #10000
    $finish;
  end
end

always
  #1  clk = ! clk ;

endmodule

