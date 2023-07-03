//pwm波输出器
//输入：时钟clk 50MHz，高电平持续时间duty（50_000代表1ms）（上限1_000_000即20ms）
//输出：周期0.625ms，1600hz的pwm波pwm_wave
//功能：根据给定的fre输出pwm波
module push_pwm_fre(
    input clk,//输入时钟50MHz
    input [19:0] fre,
    output reg pwm_wave_fre
);

   reg [19:0] count=0;
wire [19:0] T;//50_000_000/fre; 
assign  T=6_250;
//assign  T=50_000_000/fre; //仿真
 // assign  T=1280/fre;
    always @(negedge clk) 
    begin
        count<=count+1;
      //if(count==19)//仅用于仿真
    if(count>=T)//1600Hz T=0.625ms
        begin
            count<=0;
        end
        if(count<T/2)//duty输入50_000时，高电平1ms duty=15625，T=0.3125ms
        begin
            pwm_wave_fre<=1;
        end
        else
        begin
            pwm_wave_fre<=0;
        end
    end
endmodule