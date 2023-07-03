`timescale 1ns/1ps
module arm_test_tb;

  // Parameters

  // Ports
  reg clk = 0;
  reg rst_n = 0;
  wire [31:0] pwm1;
  wire [31:0] pwm2;
  wire [31:0] catch_pwm;

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
        #10 rst_n = 0;
        #10 rst_n = 1;
        #1000000
        $finish;
    end
  end

  always
    #1  clk = ! clk ;

endmodule
