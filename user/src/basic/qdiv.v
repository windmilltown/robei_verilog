`ifndef QDIV_V
`define QDIV_V

        module qdiv(
                input clk,
                input rst_n,
                input [31:0] dividend,
                input [31:0] divisor,
                output reg [31:0] quotient,
                output reg valid,//运算完成信号
                output reg warn,//除数为0警告
                output reg busy//运算中信号
            );

            parameter WIDTH = 31;
            parameter  FBITS = 16;

            wire [WIDTH-1:0] dividend_unsigned;
            wire [WIDTH-1:0] divisor_unsigned;

            integer i=0;

            reg [WIDTH-1:0] dividend_reg;//被除数寄存器(不带符号)
            reg [WIDTH-1:0] divisor_reg;//除数寄存器(不带符号)
            reg [WIDTH:0] acc;//单次被除数
            reg [WIDTH-1:0] quo;//实际使用中移位的被除数和商(复用)

            reg [WIDTH:0] acc_next;//单次被除数下一个
            reg [WIDTH-1:0] quo_next;//实际使用中移位的被除数下一个

            assign dividend_unsigned=dividend[WIDTH-1:0];
            assign divisor_unsigned=divisor[WIDTH-1:0];

            always @(*) begin
                if (acc >= {1'b0, divisor_reg}) begin
                    acc_next = acc - divisor_reg;
                    {acc_next, quo_next} = {acc_next[WIDTH-1:0], quo, 1'b1};
                end
                else begin
                    {acc_next, quo_next} = {acc, quo} << 1;
                end
            end

            always @(posedge clk or negedge rst_n) begin
                if(!rst_n) begin
                    dividend_reg <= 0;
                    divisor_reg <= 0;
                    quotient <= 0;
                    valid <= 0;
                    warn <= 0;
                    acc <= 0;
                    quo <= 0;
                    busy <= 0;

                    //acc_next <= 0;
                    //quo_next <= 0;
                end
                else if(divisor==0) begin
                    warn <= 1;
                    valid <= 0;
                    quotient <= 0;
                    busy <= 0;
                end
                else begin
                    dividend_reg <= dividend_unsigned;
                    divisor_reg <= divisor_unsigned;
                    if(dividend_unsigned!=dividend_reg||divisor_unsigned!=divisor_reg)//输入变化，重新计算
                    begin
                        i <= 0;
                        valid <= 0;
                        {acc, quo} <= {{WIDTH{1'b0}}, dividend_unsigned, 1'b0};
                        busy <= 1'b1;
                    end
                    else begin
                        if(i==WIDTH+FBITS-1) begin
                            valid<=1;
                            busy <= 1'b0;
                            if(dividend[WIDTH]==divisor[WIDTH])
                                quotient<={1'b0,quo_next[WIDTH-1:0]};
                            else
                                quotient<={1'b1,quo_next[WIDTH-1:0]};
                        end
                        else begin
                            i<=i+1;
                            {acc, quo} <= {acc_next, quo_next};
                        end
                    end
                end
            end
        endmodule
`endif
