`timescale  1ns / 1ps

//`include "push_pwm_fre.v"

module push_pwm_fre_tb;

 // push_pwm Parameters
parameter PERIOD  = 10;

  // Ports
  reg clk = 0;
  reg [19:0] fre;
  wire pwm_wave_fre;

  push_pwm_fre 
  push_pwm_fre_dut (
    .clk (clk ),
    .fre (fre ),
    .pwm_wave_fre  ( pwm_wave_fre)
  );
  always begin
    #(PERIOD/2)  clk=~clk;
end
  initial begin
    begin
      $dumpfile("tb_push_pwm_fre.vcd");
      $dumpvars;
      fre=160;
      #1000
      fre=320;
      #1000
      fre=480;
      #1000
      fre=640;
      #4000
      fre=800;
      #4000
      fre=960;
      #4000
      fre=1120;
      #4000
      fre=1280;
      #4000
      fre=1440;
      #4000
      fre=1600;
      #4000
      $finish;
    end
  end



endmodule
