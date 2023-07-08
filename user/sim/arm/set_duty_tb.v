`timescale  1ns / 1ps

module set_duty_tb;

// Parameters

// Ports
reg clk = 0;
reg rst_n = 0;
reg [19:0] duty_need;
reg [11:0] duty_gap;
wire [19:0] duty_out;

set_duty 
set_duty_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .duty_need (duty_need ),
  .duty_gap (duty_gap ),
  .duty_out  ( duty_out)
);

initial begin
  begin
    $dumpfile("set_duty_tb.vcd");
    $dumpvars(0, set_duty_tb);
    duty_gap=5;
    rst_n=0;
    #10 rst_n=1;
    duty_need=100;
    #10000 
    $finish;
  end
end

always
  #5  clk = ! clk ;

endmodule
