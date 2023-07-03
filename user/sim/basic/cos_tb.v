`timescale 1ns/1ps
module cos_tb;

// Parameters

// Ports
reg [31:0] clk;
reg [31:0] rst_n;
wire valid;
reg [31:0] xita;
wire [31:0] cos;

cos 
cos_dut (
  .clk (clk ),
  .rst_n (rst_n ),
  .valid (valid ),
  .xita (xita ),
  .cos  ( cos)
);

initial begin
  begin
      $dumpfile("cos_tb.vcd");
      $dumpvars(0, cos_tb);
      clk=0;
      rst_n=1;
      #10
      rst_n=0;
      #10
      rst_n=1;
      #10
      xita=0;
      #10000
      xita=32'h001E_0000;
      #10000
      xita=32'h003C_0000;
      #10000
      xita=32'h002D_0000;
      #10000
      xita=0;
      #10000
    $finish;
  end
end

always
  #1  clk = ! clk ;

endmodule
