//`include "xita_to_duty.v"
`timescale 1ns/1ps
module xita_to_duty_tb;

  // Parameters

  // Ports
  reg [31:0] xita;
  wire [19:0] duty;

  xita_to_duty 
  xita_to_duty_dut (
    .xita (xita ),
    .duty  ( duty)
  );

  initial begin
    begin
        $dumpfile("xita_to_duty_tb.vcd");
        $dumpvars(0, xita_to_duty_tb);
        xita=32'h0000_0000;
        #100
        xita=32'h002D_0000;
        #100
        xita=32'h0000_0000;
        #100
        xita=32'h005A_0000;
        #100
        xita=32'h0060_0000;
        #100
        xita=32'h8064_0000;
        #100
        xita=32'h802D_0000;
        #100
        xita=32'h805A_0000;
        #100
      $finish;
    end
  end


endmodule
