`timescale  1ns / 1ps

//`include "pwm_fre.v"



module pwm_fre_tb;

  // Parameters

  // Ports
  reg clk = 0;
  reg en = 0;
  reg direction = 0;
  wire pwm_out_fre;
  wire dir;

  pwm_fre 
  pwm_fre_dut (
    .clk (clk ),
    .en (en ),
    .direction (direction ),
    .pwm_out_fre (pwm_out_fre ),
    .dir  ( dir)
  );

  initial begin
    begin
      $dumpfile("tb_pwm_fre.vcd");
      $dumpvars;
//      fre_need=1600;
    //  fre_gap=500_000;

      en=1;
      #1000000;
      en=0;
      #1000000
    $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
