//θ-tanθ查找表模块
//输入：i（tanθ=1/2^i）（迭代次数）
//输出：θ（角度值）
//功能：输入1/2^i即tanθ，输出θ（角度值）
`ifndef XITA_TAN_LUT_V
`define XITA_TAN_LUT_V
module xita_tan_lut(
    input clk,
    input [4:0]i,
    output reg [31:0] xita
);
    
    always @(posedge clk) 
    begin
        case(i)
        0: begin
            xita[31:16]=45;
            xita[15:0]=0;
        end
        1: begin
            xita[31:16]=26;
            xita[15:0]=37031;
        end
        2: begin
            xita[31:16]=14;
            xita[15:0]=2375;
        end
        3: begin
            xita[30:16]=7;
            xita[15:0]=8193;
        end
        4: begin
            xita[31:16]=3;
            xita[15:0]=37770;
        end
        5: begin
            xita[31:16]=1;
            xita[15:0]=51767;
        end
        6: begin
            xita[31:16]=0;
            xita[15:0]=58666;
        end
        7: begin
            xita[31:16]=0;
            xita[15:0]=29334;
        end
        8: begin
            xita[31:16]=0;
            xita[15:0]=14667;
        end
        9: begin
            xita[31:16]=0;
            xita[15:0]=7333;
        end
        10: begin
            xita[31:16]=0;
            xita[15:0]=3666;
        end
        11: begin
            xita[31:16]=0;
            xita[15:0]=1833;
        end
        12: begin
            xita[31:16]=0;
            xita[15:0]=916;
        end
        13: begin
            xita[31:16]=0;
            xita[15:0]=458;
        end
        14: begin
            xita[31:16]=0;
            xita[15:0]=229;
        end
        15: begin
            xita[31:16]=0;
            xita[15:0]=114;
        end
        16: begin
            xita[31:16]=0;
            xita[15:0]=57;
        end
        17: begin
            xita[31:16]=0;
            xita[15:0]=28;
        end
        18: begin
            xita[31:16]=0;
            xita[15:0]=14;
        end
        19: begin
            xita[31:16]=0;
            xita[15:0]=7;
        end
        20: begin
            xita[31:16]=0;
            xita[15:0]=4;
        end
        default : xita=0;    
        endcase
    end

endmodule
`endif