//占空比输入缓冲器
//输入：时钟clk 50MHz，高电平持续时间duty_need[19:0]（50_000代表1ms）（上限1_000_000即20ms），
//      duty_out加一的间隔时钟沿次数duty_gap[9:0]（1000代表转180度用2秒）
//输出：duty_out[19:0] 随时间逐渐变化到need值的高电平持续时间
//功能：根据给定的duty_need输出逐渐变化到需求值的duty_out
module set_duty(
        input clk,//输入时钟50MHz
        input rst_n,//复位信号，低电平有效
        input [19:0] duty_need,
        input [11:0] duty_gap,
        output reg [19:0] duty_out
    );

    initial begin
        duty_out=0;
    end

    reg [11:0] count=0;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            duty_out<=0;
            count<=0;
        end
        else begin
            if(duty_out<duty_need) begin
                if(count==duty_gap-1) begin
                    count<=0;
                    duty_out<=duty_out+1;
                end
                else begin
                    count<=count+1;
                end
            end
            else if (duty_out>duty_need) begin
                if(count==duty_gap-1) begin
                    count<=0;
                    duty_out<=duty_out-1;
                end
                else begin
                    count<=count+1;
                end
            end
        end
    end
endmodule
