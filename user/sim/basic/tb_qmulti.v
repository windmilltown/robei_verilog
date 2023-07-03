`timescale  1ns / 1ps  

//`include "qmulti.v"

module tb_qmulti;      

// qmulti Parameters   
parameter PERIOD  = 10;


// qmulti Inputs
reg   [31:0]  multi1                       = 0 ;
reg   [31:0]  multi2                       = 0 ;

// qmulti Outputs
wire  [31:0]  result                       ;

qmulti  u_qmulti (
    .multi1                  ( multi1  [31:0] ),
    .multi2                  ( multi2  [31:0] ),

    .result                  ( result  [31:0] )
);

initial
begin
    $dumpfile("tb_qmulti.vcd");
    $dumpvars(0, tb_qmulti);
    #1
        multi1 = 32'h00040000;
        multi2 = 32'h00040000;
    #50
        multi1 = 32'h00048000;
        multi2 = 32'h00048000;
    #50
        multi1 = 32'h80058000;
        multi2 = 32'h80058000;
    #50
        multi1 = 32'h80058000;
        multi2 = 32'h00058000;
    #50$finish;
end

endmodule