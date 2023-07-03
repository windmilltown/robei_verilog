`timescale 1ns/1ps
module arm_model_tb;

// Parameters
localparam [31:0] L1 = 32'h0007_6666;
localparam [31:0] L2 = 32'h0012_0000;
localparam [31:0] h = 32'h0005_3333;

// Ports
reg clk = 0;
reg [31:0] x;
reg [31:0] y;
reg en1 = 0;
reg en2 = 0;
reg rst_n = 0;
reg [31:0] set_xita1;
reg [31:0] set_xita2;
reg catch = 0;
wire pwm1;
wire pwm2;
wire catch_pwm;

arm_model 
#(
  .L1(L1 ),
  .L2(L2 ),
  .h (
      h )
)
arm_model_dut (
  .clk (clk ),
  .x (x ),
  .y (y ),
  .en1 (en1 ),
  .en2 (en2 ),
  .rst_n (rst_n ),
  .set_xita1 (set_xita1 ),
  .set_xita2 (set_xita2 ),
  .catch (catch ),
  .pwm1 (pwm1 ),
  .pwm2 (pwm2 ),
  .catch_pwm  ( catch_pwm)
);

initial begin
  begin
    $dumpfile("arm_model_tb.vcd");
    $dumpvars(0, arm_model_tb);
    rst_n = 0;
    #10 
    rst_n = 1;
    #10
    rst_n = 0;
    en1=1;
    en2=0;
    #10
    rst_n=1;
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
    en1=0;
    en2=1;
    set_xita1=32'h000A_0000;
    set_xita2=32'h000A_0000;
    #10000
    set_xita1=32'h0000_0000;
    set_xita2=32'h0000_0000;
    #10000
    $finish;
  end
end

always
  #1  clk = ! clk ;

endmodule
