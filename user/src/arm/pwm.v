//pwm波模块
//输入：时钟clk 50MHz，需要的高电平时长duty_need[19:0]（50_000代表1ms）（上限1_000_000即20ms），
//      duty_out加一的间隔时钟沿次数duty_gap[9:0]（1000代表转180度用2秒）
//输出：逐渐变化到需求的高电平时长的pwm波pwm_out
//功能：根据给定的duty_need输出逐渐变化到需求值的pwm波

//`include "./set_duty/set_duty.v"
//`include "./push_pwm/push_pwm.v"

module pwm(
    input clk,//输入时钟50MHz
    input [19:0] duty_need,
    input [11:0] duty_gap,
    output pwm_out
);

    wire [19:0] duty;

    set_duty my_set_duty(
        .clk(clk),
        .duty_need(duty_need),
        .duty_gap(duty_gap),
        .duty_out(duty)
    );

    push_pwm push_pwm(
        .clk(clk),
        .duty(duty),
        .pwm_wave(pwm_out)
    );

endmodule