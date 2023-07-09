//uart接收到的ascii码(16进制表示)转32位定点数
//输入：uart时钟clk,复位rst_n,8位ascii码asc,上升沿启动信号start，数据错误信号dataerror,帧错误信号frameerror
//输出：32位定点数xdataout,ydataout,zdataout,完成信号valid
//功能：将uart接收到的ascii码转换为32位定点数，接收8次asc码，输出一次32位定点数
module uart_asc_num(
        input clk, //uart时钟
        input rst_n, //复位信号
        input [7:0] asc, //uart接收到的ascii码
        input start, //上升沿启动信号
        input dataerror, //数据错误信号
        input frameerror, //帧错误信号
        input clr, //清零信号
        output reg [31:0] xdataout, //32位定点数输出x
        output reg [31:0] ydataout, //32位定点数输出y
        output reg [31:0] zdataout, //32位定点数输出z
        output reg valid //完成信号
    );

    reg start_prev;
    reg [4:0] cnt=5'd0;
    reg startrs;//strat上升
    reg [3:0] num_16;//单个ascii码对应的4位数字

    //ascii码转换为数字
    always @(*) begin
        case(asc)
            8'd48:
                num_16 = 4'd0;
            8'd49:
                num_16 = 4'd1;
            8'd50:
                num_16 = 4'd2;
            8'd51:
                num_16 = 4'd3;
            8'd52:
                num_16 = 4'd4;
            8'd53:
                num_16 = 4'd5;
            8'd54:
                num_16 = 4'd6;
            8'd55:
                num_16 = 4'd7;
            8'd56:
                num_16 = 4'd8;
            8'd57:
                num_16 = 4'd9;
            8'd65:
                num_16 = 4'd10;
            8'd66:
                num_16 = 4'd11;
            8'd67:
                num_16 = 4'd12;
            8'd68:
                num_16 = 4'd13;
            8'd69:
                num_16 = 4'd14;
            8'd70:
                num_16 = 4'd15;
            8'd97:
                num_16 = 4'd10;
            8'd98:
                num_16 = 4'd11;
            8'd99:
                num_16 = 4'd12;
            8'd100:
                num_16 = 4'd13;
            8'd101:
                num_16 = 4'd14;
            8'd102:
                num_16 = 4'd15;
            default:
                num_16 = 4'd0;
        endcase
    end

    always @(posedge clk) begin
        start_prev <= start;
        startrs <= start & (~start_prev);
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            xdataout <= 32'd0;
            ydataout <= 32'd0;
            zdataout <= 32'd0;
            valid <= 1'b0;
            cnt <= 5'd0;
        end
        else if(clr | dataerror | frameerror) begin
            xdataout <= 32'd0;
            ydataout <= 32'd0;
            zdataout <= 32'd0;
            valid <= 1'b0;
            cnt <= 5'd0;
        end
        else begin
            if(startrs & !dataerror & !frameerror) begin
                case (cnt)
                    5'd0: begin
                        xdataout[31:28] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd1: begin
                        xdataout[27:24] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd2: begin
                        xdataout[23:20] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd3: begin
                        xdataout[19:16] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd4: begin
                        xdataout[15:12] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd5: begin
                        xdataout[11:8] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd6: begin
                        xdataout[7:4] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd7: begin
                        xdataout[3:0] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end

                    5'd8: begin
                        ydataout[31:28] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd9: begin
                        ydataout[27:24] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd10: begin
                        ydataout[23:20] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd11: begin
                        ydataout[19:16] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd12: begin
                        ydataout[15:12] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd13: begin
                        ydataout[11:8] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd14: begin
                        ydataout[7:4] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd15: begin
                        ydataout[3:0] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end

                    5'd16: begin
                        zdataout[31:28] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd17: begin
                        zdataout[27:24] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd18: begin
                        zdataout[23:20] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd19: begin
                        zdataout[19:16] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd20: begin
                        zdataout[15:12] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd21: begin
                        zdataout[11:8] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd22: begin
                        zdataout[7:4] <= num_16;
                        valid <= 1'b0;
                        cnt <= cnt+5'b1;
                    end
                    5'd23: begin
                        zdataout[3:0] <= num_16;
                        valid <= 1'b1;
                        cnt <= cnt+5'b1;
                    end
                endcase
            end
        end
    end
endmodule
