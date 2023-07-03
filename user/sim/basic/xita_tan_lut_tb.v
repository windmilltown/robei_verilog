`timescale  1ns / 1ps  

module xita_tan_lut_tb;

// Parameters

// Ports
reg clk = 0;
reg [4:0] i;
wire [31:0] xita;

xita_tan_lut 
xita_tan_lut_dut (
  .clk (clk ),
  .i (i ),
  .xita  ( xita)
);

initial begin
  begin
    $dumpfile("xita_tan_lut_tb.vcd");
    $dumpvars(0,xita_tan_lut_tb);
    #20
    i=0;
    #20
    i=1;
    #20
    i=2;
    #20
    i=3;
    #20
    i=4;
    #20
    i=5;
    #20
    i=6;
    #20
    i=7;
    #20
    i=8;
    #20
    i=9;
    #20
    i=10;
    #20
    $finish;
  end
end

always
  #5  clk = ! clk ;

endmodule