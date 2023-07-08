//机械臂测试顶层
//输入：时钟clk,低电平复位rst_n
//输出：舵机1控制信号pwm1,舵机2控制信号pwm2,抓取舵机catch_pwm
//功能：让机械臂根据程序内定义的坐标点和角度运动
module arm_test(
    input clk,
    input rst_n,
    output wire pwm1,
    output wire pwm2,
    output wire catch_pwm
);

reg [31:0] x;
reg [31:0] y;
reg en1;
reg en2;
reg catch;
reg [31:0] set_xita1;
reg [31:0] set_xita2;
reg [31:0] count;

parameter [31:0] L1 = 32'h0007_6666;//单位是cm,7.4cm
parameter [31:0] L2 = 32'h0012_0000;//18cm
parameter [31:0] h = 32'h0005_3333;//5.2cm

arm_model 
#(
  .L1(L1 ),
  .L2(L2 ),
  .h (
      h )
)
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



always @(posedge clk or negedge rst_n) 
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
        if(count==0)
        begin
            en1=0;
            en2=1;
            set_xita1=0;
            set_xita2=0;
            count<=count+1;
        end
        //else if(count==150000)//仅仿真
        else if(count==150_000_000)
        begin
            en1=1;
            en2=0;
            x=1276000;
            y=0;
            catch=1'b1;
            count<=count+32'd1;
        end
        //else if(count==300000)//仅仿真
        else if(count==300_000_000)
        begin
            en1=0;
            en2=1;
            set_xita1=0;
            set_xita2=0;
            catch=1'b0;
            count<=count+32'd1;
        end
        //else if(count==450000)//仅仿真
        else if(count==450_000_000)
        begin
            en1=1;
            en2=0;
            x=289057;
            y=1639325;
            count<=count+32'd1;
        end
        //else if(count>=600000)//仅仿真
        else if(count>=600_000_000)
        begin
            count<=0;
        end
        else
        begin
            count<=count+1;  
        end
    end
end
endmodule