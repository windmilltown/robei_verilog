//小数加法器，32位数据，31位为符号位，30-16位为整数位，15-0位为小数位
//输入：加数32位的add1,add2
//输出：和数32位的sum
`ifndef QADD_V
`define QADD_V
module qadd
(
    input [31:0] add1,
    input [31:0] add2,
    output [31:0] sum
);
    reg[31:0] res=0;//暂存加的结果

    assign sum = res;

    always @(*) 
    begin
        if(add1[31]==add2[31])//同号相加
        begin
            res[31] = add1[31];
            if(add1[30:0]+add2[30:0]>=2**31)//判断是否溢出
            begin
                res[30:0] = add1[30:0]+add2[30:0]-2**31;
            end
            else
            begin
                res[30:0] = add1[30:0]+add2[30:0];
            end
        end
        else//异号则数字位相减
        begin
            if(add1[30:0]>add2[30:0])
            begin
                res[31] = add1[31];
                res[30:0] = add1[30:0]-add2[30:0];
            end
            else if(add1[30:0]<add2[30:0])
            begin
                res[31] = add2[31];
                res[30:0] = add2[30:0]-add1[30:0];
            end
            else
            begin
                res[31] = 1'b0;
                res[30:0] = 0;
            end
        end
    end
endmodule
`endif
