//根据角度控制机械臂
//输入：舵机1角度xita1,舵机2角度xita2,夹手信号catch
//输出：舵机1pwm波pwm1,舵机2pwm波pwm2,夹手pwm波pwm_catch
//功能：根据输入的角度控制舵机转动到相应角度，夹手信号为1时夹手，为0时松手
/*`include "../xita_to_duty/xita_to_duty.v"
`include "../pwm/pwm.v"
`include "../pwm/push_pwm/push_pwm.v"
`include "../pwm/set_duty/set_duty.v"*/

module arm_angle(
    input clk,
    input [31:0] xita1,
    input [31:0] xita2,
    input catch,
    output pwm1,
    output pwm2,
    output pwm_catch
);
    wire [19:0] duty1;
    xita_to_duty 
    xita_to_duty_dut (
    .xita (xita1 ),
    .duty  ( duty1)
    );
    wire [19:0] duty2;
    xita_to_duty 
    xita_to_duty_dut1 (
    .xita (xita2 ),
    .duty  ( duty2)
    );

    parameter [11:0] duty_gap1 = 3000;
    parameter [11:0] duty_gap2 = 1000;
    pwm 
    pwm_dut (
      .clk (clk ),
      .duty_need (duty1 ),
      .duty_gap (duty_gap1 ),
      .pwm_out  ( pwm1)
    );
    pwm
    pwm_dut1 (
      .clk (clk ),
      .duty_need (duty2 ),
      .duty_gap (duty_gap2 ),
      .pwm_out  ( pwm2)
    );
  
    wire[19:0] catch_duty;
    assign catch_duty = (catch==1) ? 25_000 : 125_000;
    pwm
    pwm_dut2 (
      .clk (clk ),
      .duty_need (catch_duty ),
      .duty_gap (duty_gap2 ),
      .pwm_out  ( pwm_catch)
    );

endmodule