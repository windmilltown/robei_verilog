//机械臂测试顶层
//输入：时钟clk,低电平复位rst_n
//输出：舵机1控制信号pwm1,舵机2控制信号pwm2,抓取舵机catch_pwm
//功能：让机械臂根据程序内定义的坐标点和角度运动
module arm_test(
    input clk,
    input rst_n,
    output [31:0] pwm1,
    output [31:0] pwm2,
    output [31:0] catch_pwm
);

reg [31:0] x;
reg [31:0] y;
reg en1;
reg en2;
reg catch;
reg [31:0] set_xita1;
reg [31:0] set_xita2;
reg [31:0] count;

arm_model 
arm_model_dut (
  .clk (clk ),
  .x (x ),
  .y (y ),
  .en1 (en1 ),
  .en2 (en2 ),
  .rst_n (rst_n ),
  .set_xita1 (set_xita1 ),
  .set_xita2 (set_xita2 ),
  .catch (catch ),
  .pwm1 (pwm1 ),
  .pwm2 (pwm2 ),
  .catch_pwm  ( catch_pwm)
);

always @(negedge clk or negedge rst_n) 
begin
    if(!rst_n)
    begin
        en1<=0;
        en2<=0;
        catch<=0;
        set_xita1<=0;
        set_xita2<=0;
        count<=0;
    end
    else
    begin
        count<=count+1;
        //if(count>=60000)//仅用于仿真
        if(count>=600_000_000)
            count<=0;
        if(count==0)
        begin
            en1=0;
            en2=1;
            set_xita1=0;
            set_xita2=0;
        end
        //if(count==15000)//仅用于仿真
        if(count==150_000_000)
        begin
            en1=1;
            en2=0;
            x=1276000;
            y=0;
        end
        //if(count==30000)//仅用于仿真
        if(count==300_000_000)
        begin
            en1=0;
            en2=1;
            set_xita1=0;
            set_xita2=0;
        end
        //if(count==45000)//仅用于仿真
        if(count==450_000_000)
        begin
            en1=1;
            en2=0;
            x=289057;
            y=1639325;
        end
    end
end
endmodule