`timescale 1ns / 1ps

`include "set_fre.v"

module tb_set_fre;

  // set_fre Parameters
  parameter PERIOD = 10;

  // set_fre Inputs
  reg  clk = 0 ;
  reg  [19:0] fre_need = 0 ;
  reg  [19:0] fre_gap = 0 ;

  // set_fre Outputs
  wire [19:0] fre_out  ;

  initial
  begin
    forever
      #(PERIOD/2) clk=~clk;
  end

  set_fre u_set_fre (
            .clk  ( clk  ),
            .fre_need  ( fre_need [19:0] ),
            .fre_gap ( fre_gap  [19:0] ),

            .fre_out ( fre_out  [19:0] )
          );

  initial
  begin
    $dumpfile("tb_set_fre.vcd");
    $dumpvars(0, tb_set_fre);
    fre_gap=10;
    fre_need=1600;
    #12000
    fre_gap=10;
    fre_need=800;
    #12000
     $finish;
  end

endmodule
