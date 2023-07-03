//反正切模块
//输入：正切值tan
//输出：角度值xita
//功能：求反正切
//`include "../qdiv/qdiv.v"
//`include "xita_tan_lut.v"
module arctan(
    input clk,
    input rst_n,
    output reg valid,

    input [31:0] tan,
    output reg [31:0] xita
);

    parameter K=39796;

    wire [31:0] tan_abs;
    wire [31:0] xita_abs;
    wire [31:0] xita_c;//当前该次旋转角
    wire [31:0] tan_c;//当前正切值
    wire valid_div;
    wire warn;

    reg [31:0] tan_abs_reg;
    reg [31:0] x;
    reg [31:0] y;
    reg [31:0] z;
    reg [1:0] cnt;//时序约束延时

    integer i=0;

    assign tan_abs={1'b0,tan[30:0]};

    qdiv 
    qdiv_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .dividend (y ),
      .divisor (x ),
      .quotient ( tan_c),
      .valid ( valid_div),
      .warn ( ),
      .busy  ( )
    );

    xita_tan_lut 
    xita_tan_lut_dut (
      .clk (clk ),
      .i (i ),
      .xita  ( xita_c)
    );  

    always @(negedge clk or negedge rst_n) 
    begin
        if(!rst_n)
        begin
            i <= 0;
            x <= K;
            y <= 0;
            z <= 0;
            valid <= 0;
            cnt <= 0;
        end
        else
        begin
            tan_abs_reg <= tan_abs;
            if(tan_abs_reg != tan_abs)
            begin
                i <= 0;
                x <= K;
                y <= 0;
                z <= 0;
                valid <= 0;
                cnt <= 0;
            end
            else
            begin
                if(i==20)
                begin
                    cnt <= 0;
                    valid <= 1;
                    if(tan[31]==1)
                    begin
                        xita <= 32'h00b40000 - {1'b0,z[30:0]};
                    end
                    else
                    begin
                        xita <= {1'b0,z[30:0]};
                    end
                end
                else
                begin
                    if(valid_div==1)
                        cnt <= cnt+1;
                    else
                        cnt <= 0;
                    if(valid_div==1 && cnt==2'b10)
                    begin
                        i <= i+1;
                        if(tan_c > tan_abs_reg)
                        begin
                            x <= x+(y>>i);
                            y <= y-(x>>i);
                            z <= z-xita_c;
                        end
                        else if(tan_c < tan_abs_reg)
                        begin
                            x <= x-(y>>i);
                            y <= y+(x>>i);
                            z <= z+xita_c;
                        end
                        else
                        begin
                            x <= x;
                            y <= y;
                            z <= z;
                        end
                    end
                end
            end
        end
    end
        
endmodule

