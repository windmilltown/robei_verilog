`timescale 1ns/1ps
//`include "arm_model.v"
module arm_model_tb;

  // Parameters
  localparam [31:0] L1 = 32'h0007_6666;
  localparam [31:0] L2 = 32'h0012_0000;
  localparam [31:0] h = 32'h0005_3333;
  localparam [9:0] gap = 1000;

  // Ports
  reg clk = 0;
  reg [31:0] x;
  reg [31:0] y;
  reg en = 0;
  reg rstn = 0;
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
    .h(h ),
    .gap (
        gap )
  )
  arm_model_dut (
    .clk (clk ),
    .x (x ),
    .y (y ),
    .en (en ),
    .rstn (rstn ),
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
        #1
        rstn=0;
        x=0;
        y=L1+L2+h;
        catch=1;
        set_xita1=0;
        set_xita2=0;
        #100
        rstn=1;
        #100
        en=1;
        #1000
        x=L1+L2;
        y=h;
        catch=0;
        #1000
        x=1275445;
        y=h;
        #1000
        set_xita1=32'h001E_0000;
        set_xita2=32'h003C_0000;
        #1000
      $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
