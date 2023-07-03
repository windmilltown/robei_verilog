//`include "../qmulti/qmulti.v"
//`include "../qdiv/qdiv.v"
//`include "../qadd/qadd.v"
`ifndef SQRT_V
`define SQRT_V
module sqrt(
    input clk,
    input rst_n,
    output reg valid,

    input [31:0] sqrter,
    output reg [31:0] sqrted
);

    wire [31:0] iter;
    wire [31:0] two;
    wire [31:0] dived;
    wire [31:0] sum;
    wire [31:0] iter_next;
    wire valid_dived;

    reg [31:0] sqrter_reg;
    reg [31:0] iter_reg;

    integer i=0;
    
    assign iter = iter_reg;
    assign iter_next = sum>>1;

    qdiv 
    qdiv_dut1 (
        .clk (clk ),
        .rst_n (rst_n ),
        .valid(valid_dived),
        .busy(),
        .dividend (sqrter ),
        .divisor (iter ),
        .quotient (dived ),
        .warn  ( )
    );
    qadd
    qadd_dut (
        .add1 (dived ),
        .add2 (iter ),
        .sum (sum )
    );

    always @(negedge clk or negedge rst_n) 
    begin
        if(rst_n==0)
        begin
            sqrter_reg <= 0;
            sqrted <= 0;
            i <= 0;
            valid <= 0;
        end
        else
        begin
            sqrter_reg <= sqrter;
            if(sqrter_reg != sqrter)
            begin
                i <= 0;
                iter_reg <= sqrter;
                valid <= 0;
            end
            else if(i == 21)
            begin
                sqrted <= iter;
                valid <= 1;
            end
            else
            begin
                if(valid_dived)
                begin
                    iter_reg <= iter_next;
                    i <= i+1;
                end
            end
        end
    end

endmodule
`endif