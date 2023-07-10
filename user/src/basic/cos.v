`ifndef COS_V
`define COS_V

//`include "../tan/tan.v"
//`include "../qdiv/qdiv.v"
//`include "../qmulti/qmulti.v"
//`include "../qadd/qadd.v"
//`include "../sqrt/sqrt.v"
//`include "../arctan/xita_tan_lut.v"
module cos(
    input clk,
    input rst_n,
    output reg valid,

    input [31:0] xita,
    output reg [31:0] cos
);
    wire [31:0] tan;
    wire [31:0] tan_2;
    wire [31:0] tan_2_add_1;
    wire [31:0] deno;
    wire valid_tan;
    wire valid_sqrt;
    wire valid_qdiv;
    wire [31:0] cos_sharp;

    reg [31:0] xita_reg;
    reg [31:0] tan_2_add_1_reg;
    reg [31:0] deno_reg;
    reg valid_tan_prev;
    reg valid_sqrt_prev;
    reg valid_qdiv_prev;

    tan 
    tan_dut (
      .clk  (clk ),
      .rst_n  (rst_n ),
      .valid  (valid_tan ),
      .xita (xita_reg ),
      .tan  ( tan)
    );
    qmulti
    qmulti_dut (
      .multi1 (tan ),
      .multi2 (tan ),
      .result  ( tan_2)
    );
    qadd
    qadd_dut (
      .add1 (tan_2 ),
      .add2 (32'h0001_0000 ),
      .sum  ( tan_2_add_1)
    );
    sqrt
    sqrt_dut (
      .clk  (clk ),
      .rst_n  (rst_n ),
      .valid  (valid_sqrt ),
      .sqrter (tan_2_add_1_reg ),
      .sqrted ( deno)
    );
    qdiv
    qdiv_dut (
      .clk  (clk ),
      .rst_n  (rst_n ),
      .valid  (valid_qdiv ),
      .busy  ( ),
      .dividend (32'h0001_0000 ),
      .divisor (deno_reg ),
      .quotient  ( cos_sharp),
      .warn  ( )
    );

    always @(posedge clk or negedge rst_n) 
    begin
      if(!rst_n)
      begin
        valid <= 1'b0;
        xita_reg<=0;
        tan_2_add_1_reg<=0;
        deno_reg<=0;
        valid_tan_prev<=0;
        valid_sqrt_prev<=0;
        valid_qdiv_prev<=0;
        cos <= 32'h0000_0000;
      end
      else
      begin
        xita_reg <= xita;
        valid_tan_prev <= valid_tan;
        valid_sqrt_prev <= valid_sqrt;
        valid_qdiv_prev <= valid_qdiv;
        if(xita_reg!=xita)
        begin
          valid <= 1'b0;
        end
        else
        begin
          if(valid_tan_prev==1'b0 && valid_tan==1'b1)
          begin
            tan_2_add_1_reg <= tan_2_add_1;
          end

          if(valid_sqrt_prev==1'b0 && valid_sqrt==1'b1)
          begin
            deno_reg <= deno;
          end

          if(valid_qdiv_prev==1'b0 && valid_qdiv==1'b1)
          begin
            valid <= 1'b1;
            cos <= cos_sharp;
          end
        end
      end
    end
endmodule
`endif 