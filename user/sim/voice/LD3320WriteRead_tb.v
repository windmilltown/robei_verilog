`timescale 1ns/1ps
module LD3320WriteRead_tb;

  // Parameters
  localparam [2:0] IDLE = 3'b000;

  // Ports
  reg clk = 0;
  reg rst_n = 0;
  reg ena = 0;
  reg sel = 1;
  reg [7:0] address;
  reg [7:0] data;
  wire [7:0] P;
  wire A0;
  wire CSB;
  wire WRB;
  wire RDB;
  wire [7:0] data_valid;
  wire data_ready;
  LD3320WriteRead 
  #(
    .IDLE (
        IDLE )
  )
  LD3320WriteRead_dut (
    .clk (clk ),
    .rst_n (rst_n ),
    .ena (ena ),
    .sel (sel ),
    .address (address ),
    .data (data ),
    .P (P ),
    .A0 (A0 ),
    .CSB (CSB ),
    .WRB (WRB ),
    .RDB (RDB ),
    .data_valid (data_valid ),
    .data_ready  ( data_ready)
  );

  initial begin
    begin
      $dumpfile("LD3320WriteRead_tb.vcd");
      $dumpvars;
      //$dumpflie("LD3320WriteRead_tb.vcd");
      //$dumpvar;
      #100
      rst_n = 1;
      ena = 1;
      sel =1;
      #200
      ena = 0;
      #300
      ena = 1;
      sel = 0;
      force P = 8'h28;
      #400
      $finish;
    end
  end

  always
    #5  clk = ! clk ;
  always
    #5 address = {$random}%255;
  always
    #5 data = {$random}%255;
endmodule
