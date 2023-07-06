`timescale 1ns/1ns
module ov7725_top_tb();

    //********************************************************************//
    //****************** Parameter and Internal Signal *******************//
    //********************************************************************//
    //parameter define
    parameter H_VALID = 10'd640 , //行有效数据
              H_TOTAL = 10'd784 ; //行扫描周期
    parameter V_SYNC = 10'd4 , //场同步
              V_BACK = 10'd18 , //场时序后沿
              V_VALID = 10'd480 , //场有效数据
              V_FRONT = 10'd8 , //场时序前沿
              V_TOTAL = 10'd510 ; //场扫描周期

    //wire define
    wire ov7725_href ; //行同步信号
    wire ov7725_vsync ; //场同步信号
    wire cfg_done ; //寄存器配置完成
    wire sccb_scl ; //SCL
    wire sccb_sda ; //SDA
    wire wr_en ; //图像数据有效使能信号
    wire [15:0] wr_data ; //图像数据
    wire ov7725_rst_n ; //模拟 ov7725 复位信号

    //reg define
    reg sys_clk ; //模拟时钟信号
    reg sys_rst_n ; //模拟复位信号
    reg ov7725_pclk ; //模拟摄像头时钟信号
    reg [7:0] ov7725_data ; //模拟摄像头采集图像数据
    reg [11:0] cnt_h ; //行同步计数器
    reg [9:0] cnt_v ; //场同步计数器

    //********************************************************************//
    //***************************** Main Code ****************************//
    //********************************************************************//
    //时钟、复位信号
    initial begin
        $dumpfile("ov7725_top_tb.vcd");
        $dumpvars(0, ov7725_top_tb);
        sys_clk = 1'b1 ;
        ov7725_pclk = 1'b1 ;
        sys_rst_n <= 1'b0 ;
        #200
        sys_rst_n <= 1'b1 ;
        #10000000
        $finish;
    end

    always #20 sys_clk = ~sys_clk;
    always #20 ov7725_pclk = ~ov7725_pclk;

    assign ov7725_rst_n = sys_rst_n && cfg_done;

    //cnt_h:行同步信号计数器
    always@(posedge sys_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            cnt_h <= 12'd0 ;
        else if(cnt_h == ((H_TOTAL * 2) - 1'b1))
            cnt_h <= 12'd0 ;
        else
            cnt_h <= cnt_h + 1'd1 ;

    //ov7725_href:行同步信号
    assign ov7725_href = (((cnt_h >= 0)
                           && (cnt_h <= ((H_VALID * 2) - 1'b1)))
                          && ((cnt_v >= (V_SYNC + V_BACK))
                              && (cnt_v <= (V_SYNC + V_BACK + V_VALID - 1'b1))))
           ? 1'b1 : 1'b0 ;

    //cnt_v:场同步信号计数器
    always@(posedge sys_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            cnt_v <= 10'd0 ;
        else if((cnt_v == (V_TOTAL - 1'b1))
                && (cnt_h == ((H_TOTAL * 2) - 1'b1)))
            cnt_v <= 10'd0 ;
        else if(cnt_h == ((H_TOTAL * 2) - 1'b1))
            cnt_v <= cnt_v + 1'd1 ;
        else
            cnt_v <= cnt_v ;

    //vsync:场同步信号
    assign ov7725_vsync = (cnt_v <= (V_SYNC - 1'b1)) ? 1'b1 : 1'b0 ;

    //ov7725_data:模拟摄像头采集图像数据
    always@(posedge sys_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            ov7725_data <= 8'd0;
        else if(ov7725_href == 1'b1)
            ov7725_data <= ov7725_data + 1'b1;
        else
            ov7725_data <= 8'd0;

    //********************************************************************//
    //*************************** Instantiation **************************//
    //********************************************************************//
    //------------- ov7725_top_inst -------------
    ov7725_top
        ov7725_top_dut(

            .sys_clk (sys_clk ), //系统时钟
            .sys_rst_n (sys_rst_n ), //复位信号
            .sys_init_done (ov7725_rst_n ), //系统初始化完成(SDRAM + 摄像头)

            .ov7725_pclk (ov7725_pclk ), //摄像头像素时钟
            .ov7725_href (ov7725_href ), //摄像头行同步信号
            .ov7725_vsync (ov7725_vsync ), //摄像头场同步信号
            .ov7725_data (ov7725_data ), //摄像头图像数据

            .cfg_done (cfg_done ), //寄存器配置完成
            .sccb_scl (sccb_scl ), //SCL
            .sccb_sda (sccb_sda ), //SDA
            .ov7725_wr_en (wr_en ), //图像数据有效使能信号
            .ov7725_data_out (wr_data ) //图像数据

        );

endmodule
