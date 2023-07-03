`timescale  1ns / 1ps

//`include "set_duty.v"

module tb_set_duty;

// set_duty Parameters
parameter PERIOD  = 10;


// set_duty Inputs
reg   clk                                  = 0 ;
reg   [19:0]  duty_need                    = 0 ;
reg   [9:0]  duty_gap                      = 0 ;

// set_duty Outputs
wire  [19:0]  duty_out                     ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

set_duty  u_set_duty (
    .clk                     ( clk               ),
    .duty_need               ( duty_need  [19:0] ),
    .duty_gap                ( duty_gap   [9:0]  ),

    .duty_out                ( duty_out   [19:0] )
);

initial
begin
    $dumpfile("tb_set_duty.vcd");
    $dumpvars(0, tb_set_duty);
    duty_gap=10;
    duty_need=100;
    #12000
    duty_need=50;
    #10000
    $finish;
end

endmodule