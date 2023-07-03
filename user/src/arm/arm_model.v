//机械臂模块
//输入：50MHz时钟clk，相对于底座x坐标[31:0]x，相对于底座y坐标[31:0]y，工作使能en，
//复位信号rst，置位舵机信号[31:0]set_xita1，set_xita2，夹取信号catch
//输出：舵机1pwm波pwm1，舵机2pwm波pwm2，夹取舵机pwm波catch_pwm
//功能：en为1时，根据输入的x，y坐标，计算出舵机1和舵机2的角度，输出pwm给舵机模块，若置位信号不为0，
//则强制舵机转到那个角度。若catch为1，则夹取，否则放开。
/*`include "../basic/arctan/arctan.v"
`include "../basic/arctan/xita_tan_lut.v"
`include "../basic/arcsin/arcsin.v"
`include "../basic/qadd/qadd.v"
`include "../basic/qdiv/qdiv.v"
`include "../basic/qmulti/qmulti.v"
`include "../basic/sqrt/sqrt.v"
`include "../inverse/inverse.v"
`include "../pwm/pwm.v"
`include "../pwm/push_pwm/push_pwm.v"
`include "../pwm/set_duty/set_duty.v"
`include "../xita_to_duty/xita_to_duty.v"
`include "../basic/cos/cos.v"
`include "../basic/tan/tan.v"*/

module arm_model(
    input clk,
    input[31:0] x,
    input[31:0] y,
    input en,
    input rstn,
    input[31:0] set_xita1,
    input[31:0] set_xita2,
    input catch,
    output pwm1,
    output pwm2,
    output catch_pwm
);

    parameter [31:0] L1 = 32'h0007_6666;//单位是cm,7.4cm
    parameter [31:0] L2 = 32'h0012_0000;//18cm
    parameter [31:0] h = 32'h0005_3333;//5.2cm

    wire [31:0] x_in;
    wire [31:0] y_in;
    assign x_in = (en == 0) ? 0 : x;
    assign y_in = (en == 0) ? L1+L2+h : y;

    wire [31:0] xita1_inver;
    wire [31:0] xita2_inver;
    wire [31:0] xita1;
    wire [31:0] xita2;
    inverse 
    inverse_dut (
    .x (x_in ),
    .y (y_in ),
    .xita1 (xita1_inver ),
    .xita2  ( xita2_inver)
    );
    assign xita1 = (en==0)? 0:((set_xita1 == 0) ? xita1_inver : set_xita1);
    assign xita2 = (en==0)? 0:((set_xita2 == 0) ? xita2_inver : set_xita2);

    wire [19:0] duty1;
    wire [19:0] duty2;
    xita_to_duty 
    xita_to_duty_dut1 (
      .xita (xita1 ),
      .duty  ( duty1)
    );
    xita_to_duty 
    xita_to_duty_dut2 (
      .xita (xita2 ),
      .duty  ( duty2)
    );
    
    parameter [11:0] gap = 1000;
    pwm 
    pwm_dut1 (
      .clk (clk ),
      .duty_need (duty1 ),
      .duty_gap (gap ),
      .pwm_out  ( pwm1)
    );
    pwm 
    pwm_dut2 (
      .clk (clk ),
      .duty_need (duty2 ),
      .duty_gap (gap ),
      .pwm_out  ( pwm2)
    );
  
    wire [19:0] catch_duty;
    reg [19:0] catch_duty_reg;
    assign catch_duty = catch_duty_reg;
    pwm 
    pwm_dut3 (
      .clk (clk ),
      .duty_need (catch_duty ),
      .duty_gap (gap ),
      .pwm_out  ( catch_pwm)
    );
  

    always @(negedge clk or negedge rstn) 
    begin
        if(rstn==0)
        begin
            catch_duty_reg<=125_000;
        end
        else
        begin
            if(catch==1)
                catch_duty_reg<=25_000;
            else
                catch_duty_reg<=125_000;
        end
    end

endmodule