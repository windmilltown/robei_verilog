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
  #(
    .duty_gap (
        duty_gap )
  )
  arm_angle_dut (
    .clk (clk ),
    .xita1 (xita1 ),
    .xita2 (xita2 ),
    .pwm1 (pwm1 ),
    .pwm2  ( pwm2)
  );

  initial begin
    begin
      $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
