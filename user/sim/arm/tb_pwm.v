`timescale  1ns / 1ps

//`include "pwm.v"

module tb_pwm;

// pwm Parameters
parameter PERIOD  = 10;


// pwm Inputs
reg   clk                                  = 0 ;
reg   [19:0]  duty_need                    = 0 ;
reg   [9:0]  duty_gap                      = 5 ;

// pwm Outputs
wire  pwm_out                              ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

pwm  u_pwm (
    .clk                     ( clk               ),
    .duty_need               ( duty_need  [19:0] ),
    .duty_gap                ( duty_gap   [9:0]  ),

    .pwm_out                 ( pwm_out           )
);

initial
begin
    $dumpfile("tb_pwm.vcd");
    $dumpvars(0, tb_pwm);
    #100
    duty_need=20;
    #10000
    duty_need=10;
    #10000
    $finish;
end

endmodule