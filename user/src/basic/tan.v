`ifndef TAN_V
`define TAN_V
//`include "../arctan/xita_tan_lut.v"
//`include "../qdiv/qdiv.v"
module tan(
    input clk,
    input rst_n,
    output reg valid,

    input [31:0] xita,
    output reg [31:0] tan
);

    parameter K=39796;

    wire valid_div;
    wire [31:0] tan_c;//当前正切值
    wire [31:0] xita_c;//当前旋转角

    reg [31:0] x;
    reg [31:0] y;
    reg [31:0] z;
    reg [31:0] xita_reg;
    reg [1:0] cnt;

    integer i=0;

    qdiv 
    qdiv_dut (
        .clk (clk ),
        .rst_n (rst_n ),
        .valid ( valid_div),
        .dividend (y ),
        .divisor (x ),
        .quotient (tan_c ),
        .warn ( ),
        .busy ( )
    );
    xita_tan_lut 
    xita_tan_lut_dut (
        .clk(clk ),
        .i (i ),
        .xita  ( xita_c)
    );

    always @(negedge clk or negedge rst_n) 
    begin
        if(!rst_n)
        begin
            valid<=0;
            x<=0;
            y<=0;
            z<=0;
            i<=0;
            xita_reg<=xita;
            tan<=0;
        end
        else
        begin
            xita_reg<=xita;
            if(xita_reg!=xita)
            begin
                i<=0;
                x<=K;
                y<=0;
                z<=0;
                valid<=0;
                cnt<=0;
            end
            else
            begin
                if(i==20)
                begin
                    valid<=1;
                    tan<=tan_c;
                    cnt<=0;
                end
                else
                begin
                    if(valid_div==1)
                    begin
                       cnt<=cnt+1;
                    end
                    else
                    begin
                        cnt<=0;
                    end
                    if(valid_div==1 && cnt==2)
                    begin
                        i<=i+1;
                        if(z<xita)
                        begin
                            z<=z+xita_c;
                            x<=x-(y>>i);
                            y<=y+(x>>i);
                        end
                        else if(z>xita)
                        begin
                            z<=z-xita_c;
                            x<=x+(y>>i);
                            y<=y-(x>>i);
                        end
                        else
                        begin
                            z<=z;
                            x<=x;
                            y<=y;
                        end
                    end
                end
            end
        end      
    end

endmodule
`endif