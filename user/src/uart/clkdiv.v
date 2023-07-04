//分频模块
//输入：系统时钟clk50,复位信号rst_n
//输出：分频后的时钟clkout
//功能：将50MHz的系统时钟326分频以实现uart通信
module clkdiv(
    input clk50,
    input rst_n,
    output reg clkout
);
    reg [15:0] cnt;
    always @(posedge clk50 or negedge rst_n)
    begin
        if(!rst_n)
        begin
            cnt <= 16'b0;
            clkout <= 1'b0;
        end
        else if(cnt == 16'd162) 
        begin
            clkout <= 1'b1;
            cnt <= cnt + 16'd1;
        end
            else if(cnt == 16'd325) 
        begin
            clkout <= 1'b0;
            cnt <= 16'd0;
        end
            else 
        begin
            cnt <= cnt + 16'd1;
        end
    end
endmodule