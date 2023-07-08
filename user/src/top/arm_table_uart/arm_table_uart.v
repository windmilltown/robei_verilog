module arm_table_uart(
        input clk,
        input rst_n,

        //arm顶层接口
        output pwm1,
        output pwm2,
        output catch_pwm,

        //uart顶层接口
        input rx,
        output tx,

        //滑台顶层接口
        input en,

        output pwm_table,
        output dir_table
    );
endmodule
