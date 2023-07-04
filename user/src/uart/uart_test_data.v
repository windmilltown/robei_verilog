//uart测试数据模块
//输入：clk,rst_n
//输出：dataout,wrsig
//功能：产生测试数据发给uarttx模块
module uart_test_data(
        input clk,
        input rst_n,
        output reg [7:0] dataout,
        output reg wrsig
    );

    reg [9:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 10'd0;
            wrsig <= 1'b0;
        end
        else begin
            if(cnt == 1016) begin
                dataout <= dataout + 8'd1; //每次数据加“1”
                wrsig <= 1'b1; //产生发送命令
                cnt <= 10'd0;
            end
            else begin
                wrsig <= 1'b0;
                cnt <= cnt + 10'd1;
            end
        end
    end
endmodule
