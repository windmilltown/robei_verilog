`timescale 1ns/1ps
module inverse_tb;

parameter [31:0] L1 = 32'h0007_6666;//单位是cm,7.4cm
parameter [31:0] L2 = 32'h0012_0000;//18cm
parameter [31:0] h = 32'h0005_3333;//5.2cm

// Ports
reg clk = 0;
reg rst_n = 0;
wire valid;
reg [31:0] x;
reg [31:0] y;
wire [31:0] xita1;
wire [31:0] xita2;

inverse 
#(
  .L1(L1 ),
  .L2(L2 ),
  .h (
      h )
)
inverse_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .valid (valid ),
  .x (x ),
  .y (y ),
  .xita1 (xita1 ),
  .xita2  ( xita2)
);

initial begin
  begin
      $dumpfile("inverse_tb.vcd");
      $dumpvars(0, inverse_tb);
      rst_n = 1;
      x=0;
      y=L1+L2;
      #10
      rst_n = 0;
      #10
      rst_n = 1;
      #10000
      x=0;
      y=L1+L2;
      #10000
      x=1277000;
      y=0;
      #10000
      x=1276000;
      y=0;
      #10000
      x=1177060;
      y=1177060;
      #10000
      x=1264088;
      y=1009817;
      #10000
      x=342923;
      y=1522571;
      #10000
      x=289057;
      y=1639325;
      #10000
      x=1277000;
      y=0;
      #10000
      $finish;
  end
end

always
  #1  clk = ! clk ;

endmodule
