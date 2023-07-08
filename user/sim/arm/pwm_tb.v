`timescale  1ns / 1ps

module pwm_tb;

// Parameters

// Ports
reg clk = 0;
reg rst_n = 0;
reg [19:0] duty_need;
reg [11:0] duty_gap;
wire pwm_out;

pwm 
pwm_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .duty_need (duty_need ),
  .duty_gap (duty_gap ),
  .pwm_out  ( pwm_out)
);

initial
begin
    $dumpfile("pwm_tb.vcd");
    $dumpvars(0, pwm_tb);
    rst_n=0;
    #10
    rst_n=1;
    #100
    duty_gap=10;
    duty_need=20;
    #10000
    duty_need=10;
    #10000
    $finish;
end

always
  #5  clk = ! clk ;

endmodule
