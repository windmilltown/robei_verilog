`timescale  1ns / 1ps  

//`include "qadd.v"

module tb_qadd;       

// qadd Inputs
reg   [31:0]  add1                         = 0 ;
reg   [31:0]  add2                         = 0 ;

// qadd Outputs
wire  [31:0]  sum                          ;

qadd  u_qadd (
    .add1                    ( add1  [31:0] ),
    .add2                    ( add2  [31:0] ),

    .sum                     ( sum   [31:0] )
);

initial
begin
    $dumpfile("tb_qadd.vcd");
    $dumpvars(0, tb_qadd);
    #1 
        add1 = 32'h0000000f;
        add2 = 32'h0000000f;
    #50
        add1 = 32'h8000000f;
        add2 = 32'h0000000f;
    #50
        add1 = 32'h8000000f;
        add2 = 32'h8000000f;
    #50
        add1 = 32'hc010000f;
        add2 = 32'h80f00000;
    #50
        add1 = 32'hc000000f;
        add2 = 32'hc0000000;
    #50$finish;
end

endmodule