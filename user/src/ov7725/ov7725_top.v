//ov7725顶层模块
//输入：sys_clk,sys_rst_n,sys_init_done,ov7725_pclk,ov7725_href,ov7725_vsync,ov7725_data
//输出：cfg_done,sccb_scl,sccb_sda,ov7725_wr_en,ov7725_data_out
//功能：ov7725初始化配置，图像数据输出
module ov7725_top
    (
        input wire sys_clk , //系统时钟
        input wire sys_rst_n , //复位信号
        input wire sys_init_done , //系统初始化完成

        input wire ov7725_pclk , //摄像头像素时钟
        input wire ov7725_href , //摄像头行同步信号
        input wire ov7725_vsync , //摄像头场同步信号
        input wire [ 7:0] ov7725_data , //摄像头图像数据

        output wire cfg_done , //寄存器配置完成
        output wire sccb_scl , //SCL
        output wire sccb_sda , //SDA
        output wire ov7725_wr_en , //图像数据有效使能信号
        output wire [15:0] ov7725_data_out //图像数据
    );

    //********************************************************************//
    //****************** Parameter and Internal Signal *******************//
    //********************************************************************//
    //parameter define
    parameter SLAVE_ADDR = 7'h21 ; // 器件地址(SLAVE_ADDR)
    parameter BIT_CTRL = 1'b0 ; // 字地址位控制参数(16b/8b)
    parameter CLK_FREQ = 26'd50_000_000; // i2c_dri 模块的驱动时钟频率(CLK_FREQ)
    parameter I2C_FREQ = 18'd250_000 ; // I2C 的 SCL 时钟频率

    //wire define
    wire cfg_end ;
    wire cfg_start ;
    wire [23:0] cfg_data ;
    wire cfg_clk ;

    //********************************************************************//
    //*************************** Instantiation **************************//
    //********************************************************************//
    //------------- i2c_ctrl_inst -------------//
    sccb
        #(
            .DEVICE_ADDR (SLAVE_ADDR ), //i2c 设备器件地址
            .SYS_CLK_FREQ (CLK_FREQ ), //i2c_ctrl 模块系统时钟频率
            .SCL_FREQ (I2C_FREQ ) //i2c 的 SCL 时钟频率
        )
        sccb_dut
        (
            .sys_clk (sys_clk ), //输入系统时钟,50MHz
            .sys_rst_n (sys_rst_n ), //输入复位信号,低电平有效
            .wr_en (1'b1 ), //输入写使能信号
            .rd_en ( ), //输入读使能信号
            .i2c_start (cfg_start ), //输入 i2c 触发信号
            .addr_num (BIT_CTRL ), //输入 i2c 字节地址字节数
            .byte_addr (cfg_data[15:8]), //输入 i2c 字节地址
            .wr_data (cfg_data[7:0] ), //输入 i2c 设备数据

            .rd_data ( ), //输出 i2c 设备读取数据
            .i2c_end (cfg_end ), //i2c 一次读/写操作完成
            .i2c_clk (cfg_clk ), //i2c 驱动时钟
            .i2c_scl (sccb_scl ), //输出至 i2c 设备的串行时钟信号 scl
            .i2c_sda (sccb_sda ) //输出至 i2c 设备的串行数据信号 sda
        );

    //------------- ov7725_cfg_inst -------------//
    ov7725_cfg
        ov7725_cfg_dut(

            .sys_clk (cfg_clk ), //系统时钟,由 i2c 模块传入
            .sys_rst_n (sys_rst_n ), //系统复位,低有效
            .cfg_end (cfg_end ), //单个寄存器配置完成

            .cfg_start (cfg_start ), //单个寄存器配置触发信号
            .cfg_data (cfg_data ), //ID,REG_ADDR,REG_VAL
            .cfg_done (cfg_done ) //寄存器配置完成
        );

    //------------- ov7725_data_inst -------------//
    ov7725_data
        ov7725_data_dut(

            .sys_rst_n (sys_rst_n & sys_init_done ), //复位信号
            .ov7725_pclk (ov7725_pclk ), //摄像头像素时钟
            .ov7725_href (ov7725_href ), //摄像头行同步信号
            .ov7725_vsync (ov7725_vsync ), //摄像头场同步信号
            .ov7725_data (ov7725_data ), //摄像头图像数据

            .ov7725_wr_en (ov7725_wr_en ), //图像数据有效使能信号
            .ov7725_data_out (ov7725_data_out) //图像数据

        );

endmodule
