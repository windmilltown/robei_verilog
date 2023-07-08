`timescale 1ns / 1ps
//`include "arm_angle.v"

module arm_angle_tb;

  // Parameters
  localparam [11:0] duty_gap = 1000;

  // Ports
  reg clk = 0;
  reg [31:0] xita1;
  reg [31:0] xita2;
  wire pwm1;
  wire pwm2;

  arm_angle 
  arm_angle_dut (
    .clk (clk ),
    .xita1 (xita1 ),
    .xita2 (xita2 ),
    .pwm1 (pwm1 ),
    .pwm2  ( pwm2)
  );

  initial begin
    begin
      $dumpfile("arm_angle_tb.vcd");
      $dumpvars(0, arm_angle_tb);
      #10
      xita1=0;
      xita2=0;
      #10000
      xita1=32'h002D_0000;
      xita2=32'h005A_0000;
      #10000
      $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
