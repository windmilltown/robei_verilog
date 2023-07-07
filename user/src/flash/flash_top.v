//ov7725写入flash的顶层模块
//输入：sys_clk,sys_rst_n,ov7725_pclk,ov7725_href,ov7725_vsync,ov7725_data
//输出：sccb_scl,sccb_sda,sck,cs,mosi,miso
//功能：将ov7725采集到的图像数据转化为灰度图像后写入flash
module flash_top(
        input wire sys_clk , //系统时钟
        input wire sys_rst_n , //复位信号

        input wire ov7725_pclk , //摄像头像素时钟
        input wire ov7725_href , //摄像头行同步信号
        input wire ov7725_vsync , //摄像头场同步信号
        input wire [7:0] ov7725_data , //摄像头图像数据

        output wire sccb_scl , //SCL
        output wire sccb_sda , //SDA
        
        output wire sck, //SPI clock
        output wire cs, //spi片选信号
        output wire mosi, //spi数据输给flash
        input wire miso, //flash spi数据输出

        input wire start //上升沿触发起始信号
    );

    //wire define
    wire cfg_done;
    wire flash_init;
    wire [15:0] ov7725_data_out;
    wire [7:0] pixel;
    wire init_done;
    wire ov7725_wr_en;

    //assign define
    assign init_done=cfg_done & flash_init;//所有初始化完成信号

    ov7725_top 
    ov7725_top_dut (
      .sys_clk (sys_clk ),
      .sys_rst_n (sys_rst_n ),
      .sys_init_done (init_done ),
      .ov7725_pclk (ov7725_pclk ),
      .ov7725_href (ov7725_href ),
      .ov7725_vsync (ov7725_vsync ),
      .ov7725_data (ov7725_data ),
      .cfg_done (cfg_done ),
      .sccb_scl (sccb_scl ),
      .sccb_sda (sccb_sda ),
      .ov7725_wr_en (ov7725_wr_en ),
      .ov7725_data_out  ( ov7725_data_out)
    );

    ov7725_flash 
    ov7725_flash_dut (
      .clk (sys_clk ),
      .rst_n (sys_rst_n ),
      .clk24M (ov7725_pclk ),
      .sck (sck ),
      .cs (cs ),
      .mosi (mosi ),
      .miso (miso ),
      .pixel (pixel ),
      .start (start ),
      .matrix (ov7725_wr_en ),
      .flash_init  ( flash_init)
    );

    rgb_yuv 
    rgb_yuv_dut (
      .rgb_in (ov7725_data_out ),
      .y_out  ( pixel)
    );  
  
endmodule