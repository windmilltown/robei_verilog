`timescale  1ns / 1ps

module push_pwm_tb;

// Parameters

// Ports
reg clk = 0;
reg rst_n = 0;
reg [19:0] duty;
wire pwm_wave;

push_pwm 
push_pwm_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .duty (duty ),
  .pwm_wave  ( pwm_wave)
);

initial begin
        $dumpfile("push_pwm_tb.vcd");
        $dumpvars(0, push_pwm_tb);
        rst_n=0;
        #10 rst_n=1;
        duty=10;
        #1000
        duty=5; 
        #1000
        $finish;
end

always
  #5  clk = ! clk ;

endmodule
