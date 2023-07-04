//uart接收模块
//输入：clk,rst_n,rx
//输出：dataout,rdsig,dataerror,frameerror
//功能：接收uart模式发送的数据
module uartrx(
        input clk, //采样时钟
        input rst_n, //复位信号
        input rx, //UART 数据输入
        output reg [7:0] dataout, //接收数据输出
        output reg rdsig,//接收到8位数据标志输出
        output reg dataerror, //数据出错指示
        output reg frameerror //帧出错指示
    );

    parameter paritymode = 1'b0;//奇偶校验设置，0为偶校验，1为奇校验

    reg [7:0] cnt;
    reg rxbuf;//前一个rx值
    reg rxfall;//下降沿标志位
    reg receive;//接收标志位
    reg presult;//计算得到的奇偶校验位
    reg idle;//接收ing

    //检测线路的下降沿
    always @(posedge clk) begin
        rxbuf <= rx;
        rxfall <= rxbuf & (~rx);
    end

    //启动串口接收程序
    always @(posedge clk) begin
        if (rxfall && (~idle)) begin//检测到线路的下降沿并且原先线路为空闲，启动接收数据进程
            receive <= 1'b1;
        end
        else if(cnt == 8'd168) begin //接收数据完成
            receive <= 1'b0;
        end
    end

    //串口接收程序,16个时钟接收一个bit
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            idle<=1'b0;
            cnt<=8'd0;
            rdsig <= 1'b0;
            frameerror <= 1'b0;
            dataerror <= 1'b0;
            presult<=1'b0;
        end
        else if(receive == 1'b1) begin
            case (cnt)
                8'd0: begin
                    idle <= 1'b1;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b0;
                end
                8'd24: begin //接收第 0 位数据
                    idle <= 1'b1;
                    dataout[0] <= rx;
                    presult <= paritymode^rx;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b0;
                end
                8'd40: begin //接收第 1 位数据
                    idle <= 1'b1;
                    dataout[1] <= rx;
                    presult <= presult^rx;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b0;
                end
                8'd56: begin //接收第 2 位数据
                    idle <= 1'b1;
                    dataout[2] <= rx;
                    presult <= presult^rx;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b0;
                end
                8'd72: begin //接收第 3 位数据
                    idle <= 1'b1;
                    dataout[3] <= rx;
                    presult <= presult^rx;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b0;
                end
                8'd88: begin //接收第 4 位数据
                    idle <= 1'b1;
                    dataout[4] <= rx;
                    presult <= presult^rx;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b0;
                end
                8'd104: begin //接收第 5 位数据
                    idle <= 1'b1;
                    dataout[5] <= rx;
                    presult <= presult^rx;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b0;
                end
                8'd120: begin //接收第 6 位数据
                    idle <= 1'b1;
                    dataout[6] <= rx;
                    presult <= presult^rx;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b0;
                end
                8'd136: begin //接收第 7 位数据
                    idle <= 1'b1;
                    dataout[7] <= rx;
                    presult <= presult^rx;
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b1;
                end
                8'd152: begin //接收奇偶校验位
                    idle <= 1'b1;
                    if(presult == rx)
                        dataerror <= 1'b0;
                    else
                        dataerror <= 1'b1; //如果奇偶校验位不对，表示数据出错
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b1;
                end
                8'd168: begin
                    idle <= 1'b1;
                    if(1'b1 == rx)
                        frameerror <= 1'b0;
                    else
                        frameerror <= 1'b1; //如果没有接收到停止位，表示帧出错
                    cnt <= cnt + 8'd1;
                    rdsig <= 1'b1;
                end
                default: begin
                    cnt <= cnt + 8'd1;
                end
            endcase
        end
        else begin
            cnt <= 8'd0;
            idle <= 1'b0;
            rdsig <= 1'b0;
        end
    end
endmodule
