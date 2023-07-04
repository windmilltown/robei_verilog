//`include "../arctan/arctan.v"
//`include "../arctan/xita_tan_lut.v"
//`include "../sqrt/sqrt.v"
//`include "../qdiv/qdiv.v"
//`include "../qmulti/qmulti.v"
//`include "../qadd/qadd.v"
module arcsin(
    input clk,
    input rst_n,
    output reg valid,

    input [31:0] value_sin,
    output reg [31:0] xita
);
    wire[31:0] den;
    wire[31:0] radian;
    wire[31:0] radian_tan;
    wire[31:0] radian_2;
    wire[31:0] one_rad;
    wire[31:0] den_tan;

    wire valid_sqrt;
    wire valid_div;
    wire valid_arctan;

    reg [31:0] value_sin_reg;
    reg [31:0] den_reg;
    reg [31:0] radian_tan_reg;
    reg [31:0] radian_reg;

    reg valid_sqrt_prev;
    reg valid_div_prev;
    reg valid_arctan_prev;

    assign radian= (value_sin_reg<=32'h0001_0000)? value_sin_reg : 32'h0001_0000;
    qmulti
    qmulti_dut1(
        .multi1(radian),
        .multi2(radian),
        .result(radian_2)
    );
    qadd
    qadd_dut(
        .add1(32'h0001_0000),
        .add2({~radian_2[31],radian_2[30:0]}),
        .sum(one_rad)
    );
    sqrt
    sqrt_dut(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid_sqrt),
        .sqrter(one_rad),
        .sqrted(den)
    );
    qdiv
    qdiv_dut(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid_div),
        .dividend(radian_reg),
        .divisor(den_reg),
        .quotient(radian_tan),
        .warn()
    );

    wire[31:0] xita_sharp;
    arctan
    arctan_dut(
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid_arctan),
        .tan(radian_tan_reg),
        .xita(xita_sharp)
    );

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            valid <= 0;
            value_sin_reg <= 0;
            den_reg<=0;
            radian_tan_reg<=0;
            radian_reg<=0;

            valid_sqrt_prev<=0;
            valid_div_prev<=0;
            valid_arctan_prev<=0;
        end
        else
        begin
            valid_sqrt_prev <= valid_sqrt;
            valid_div_prev <= valid_div;
            valid_arctan_prev <= valid_arctan;
            
            value_sin_reg <= value_sin;

            if(value_sin >= 32'h0001_0000)
            begin
                valid <= 1;
                xita <= 32'h005A_0000;
            end
            else
            begin
                if(value_sin_reg != value_sin)
                begin
                    valid <= 0;
                end
                else
                begin
                    if(!valid_sqrt_prev && valid_sqrt)//上升沿
                    begin
                        den_reg <= den;
                        radian_reg <= radian;
                    end

                    if(!valid_div_prev && valid_div)//上升沿
                    begin
                        radian_tan_reg <= radian_tan;
                    end

                    if(!valid_arctan_prev && valid_arctan)//上升沿
                    begin
                        valid <= 1;
                        xita <= xita_sharp;
                    end
                end
            end
            
        end 
    end
    
endmodule