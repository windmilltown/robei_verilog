//机械臂模块
//输入：50MHz时钟clk，相对于关节1x坐标[31:0]x，相对于关节1y坐标[31:0]y，逆解法工作使能en1，角度法工作使能en2
//复位信号rst_n，置位舵机信号[31:0]set_xita1，set_xita2，夹取信号catch
//输出：舵机1pwm波pwm1，舵机2pwm波pwm2，夹取舵机pwm波catch_pwm
//功能：en1为1时，根据输入的x，y坐标，计算出舵机1和舵机2的角度，输出pwm给舵机模块，若en2为1，
//则强制舵机转到置位角度。若catch为1，则夹取，否则放开。
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
    input [31:0] x,
    input [31:0] y,
    input en1,
    input en2,
    input rst_n,
    input [31:0] set_xita1,
    input [31:0] set_xita2,
    input catch,
    output pwm1,
    output pwm2,
    output catch_pwm
);

    parameter [31:0] L1 = 32'h0007_6666;//单位是cm,7.4cm
    parameter [31:0] L2 = 32'h0012_0000;//18cm
    parameter [31:0] h = 32'h0005_3333;//5.2cm

    wire [31:0] xita1_inver;
    wire [31:0] xita2_inver;
    wire valid;

    reg [31:0] xita1;
    reg [31:0] xita2;
    reg [31:0] valid_prev;

    inverse 
    #(
      .L1(L1 ),
      .L2(L2 ),
      .h (
          h )
    )
    inverse_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .valid ( valid),
      .x (x ),
      .y (y ),
      .xita1 ( xita1_inver),
      .xita2  ( xita2_inver)
    );

    arm_angle 
    arm_angle_dut (
      .clk (clk ),
      .xita1 (xita1 ),
      .xita2 (xita2 ),
      .catch (catch ),
      .pwm1 (pwm1 ),
      .pwm2 (pwm2 ),
      .pwm_catch  ( pwm_catch)
    );  

    always @(posedge clk or negedge rst_n) 
    begin
        if(rst_n==0)
        begin
          xita1<=0;
          xita2<=0;
          valid_prev<=0;
        end
        else
        begin
          valid_prev<=valid;
          if(en2==1)
          begin
            xita1<=set_xita1;
            xita2<=set_xita2;
          end
          else if(en1==1 && valid==1 && valid_prev==0)
          begin
            xita1<=xita1_inver;
            xita2<=xita2_inver;
          end
        end
    end

endmodule