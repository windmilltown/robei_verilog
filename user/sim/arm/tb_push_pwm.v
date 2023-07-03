`timescale  1ns / 1ps

//`include "push_pwm.v"

module tb_push_pwm;

// push_pwm Parameters
parameter PERIOD  = 10;


// push_pwm Inputs
reg   clk                                  = 0 ;
reg [19:0]  duty                           = 0 ;

// push_pwm Outputs
wire  pwm_wave                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

push_pwm  u_push_pwm (
    .clk                     ( clk        ),
    .duty                    ( duty       ),

    .pwm_wave                ( pwm_wave   )
);

initial
begin
    $dumpfile("tb_push_pwm.vcd");
    $dumpvars(0, tb_push_pwm);
    duty=10;
    #1000
    duty=5;
    #1000
    duty=3;
    #1000
    duty=20;
    #1000
    duty=15;
    #1000
    $finish;
end

endmodule