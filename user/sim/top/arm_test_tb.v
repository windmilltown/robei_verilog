`timescale 1ns/1ps
module arm_test_tb;

// Parameters

// Ports
reg clk = 0;
reg rst_n = 0;
wire pwm1;
wire pwm2;
wire catch_pwm;

arm_test 
arm_test_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .pwm1 (pwm1 ),
  .pwm2 (pwm2 ),
  .catch_pwm  ( catch_pwm)
);

initial begin
  begin
      $dumpfile("arm_test_tb.vcd");
      $dumpvars(0, arm_test_tb);
      rst_n=1;
      #10
      rst_n=0;
      #10
      rst_n=1;
      #40000
      $finish;
  end 
end

always
  #1  clk = ! clk ;

endmodule
