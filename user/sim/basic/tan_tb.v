`timescale 1ns/1ps
module tan_tb;

// Parameters
localparam  K = 39796;

// Ports
reg clk = 0;
reg rst_n = 0;
wire valid;
reg [31:0] xita;
wire [31:0] tan;

tan 
#(
  .K (
      K )
)
tan_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .valid (valid ),
  .xita (xita ),
  .tan  ( tan)
);

initial begin
  begin
      $dumpfile("tan_tb.vcd");
      $dumpvars(0,tan_tb);
      rst_n=1;
      //xita=32'h0000_0000;
      #10
      rst_n=0;
      #10
      rst_n=1;
      #10
      xita=32'h001E_0000;
      #10000
      xita=32'h0000_0000;
      #10000
      xita=32'h003C_0000;
      #10000
      xita=32'h002D_0000;
      #10000
    $finish;
  end
end

always
  #1  clk = ! clk ;

endmodule
