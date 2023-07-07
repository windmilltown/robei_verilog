//pwm波输出器
//输入：时钟clk 50MHz，高电平持续时间duty（50_000代表1ms）（上限1_000_000即20ms）
//输出：周期20ms的pwm波pwm_wave
//功能：根据给定的duty输出pwm波
module push_pwm(
    input clk,//输入时钟50MHz
    input [19:0] duty,
    output reg pwm_wave
);

    reg [19:0] count=0;

    always @(posedge clk) 
    begin
        count<=count+1;
        //if(count==19)//仅用于仿真
        if(count==999_999)//20ms
        begin
            count<=0;
        end
        if(count<duty)//duty输入50_000时，高电平1ms
        begin
            pwm_wave<=1;
        end
        else
        begin
            pwm_wave<=0;
        end
    end
endmodule