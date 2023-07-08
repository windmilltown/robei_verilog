module arm_angle_test(
        input clk,
        input rst_n,
        output pwm1,
        output pwm2,
        output catch_pwm
    );

    reg [31:0] xita1;
    reg [31:0] xita2;

    arm_angle
        arm_angle_dut (
            .clk (clk ),
            .rst_n (rst_n ),
            .xita1 (xita1 ),
            .xita2 (xita2 ),
            .catch (catch ),
            .pwm1 (pwm1 ),
            .pwm2 (pwm2 ),
            .pwm_catch  ( pwm_catch)
        );

endmodule
