//flash写入图片模块
//输入：clk, rst_n, clk24M, pixel, start, matrix
//输出：sck, cs, mosi, flash_init
//功能：将ov7725采集到的图像数据一列一列地写入flash
module ov7725_flash(
        input clk, //50MHz时钟
        input rst_n, //复位
        input clk24M, //24MHz时钟

        output sck, //SPI clock
        output cs, //spi片选信号
        output mosi, //spi数据输给flash
        input miso, //flash spi数据输出

        input [7:0] pixel,//输入像素(灰度)
        input start, //上升沿触发起始信号
        input matrix, //上升沿触发帧有效信号

        output reg flash_init //初始化完成,请和ov7725_top.v中的cfg_done相与,后连接sys_init_done
    );

    //parameter define//
    parameter IDLE=3'b000; //空闲状态
    parameter RN_SEND=3'b001; //写入写使能状态
    parameter SE_ERASE=3'b011; //扇区擦除状态
    parameter FL_WAIT=3'b010; //擦除后等待状态
    parameter PG_WRITE=3'b110; //写入状态
    parameter SE_WAIT=3'b111; //扇区擦除等待状态
    parameter PG_WAIT=3'b101; //写入等待状态

    //wire define//
    wire matrixrs; //帧有效信号,上升沿标志位
    wire startrs; //起始信号,上升沿标志位
    wire done_sign; //flash操作完成标志位
    wire [7:0] mydata_o; //flash输出数据
    wire myvalid_o; //flash输出数据有效信号
    wire [2:0] spi_state; //flash状态机状态

    //reg define//
    reg matrix_prev;
    reg start_prev;
    reg [2:0] state; //flash状态机状态
    reg [3:0] cmd_type; //命令类型,可根据此类型判断要写入哪些数据
    reg [7:0] cmd; //写入的命令
    reg [23:0] addr; //写入地址
    reg [12:0] time_delay; //延时计数器
    reg [7:0] cnt_se_erase; //擦除扇区计数器
    reg [10:0] cnt_page; //写入页计数器
    reg se_done; //擦除完成标志位
    reg [9:0] cnt_line=0; //当前列数
    reg [9:0] cnt_col_now=0; //当前应该采集的列数
    reg [9:0] cnt_raw=0; //当前行数

    //assign define//
    assign startrs=(~start_prev) & start;
    assign matrixrs=(~matrix_prev) & matrix;

    flash_spi
        flash_spi_dut (
            .flash_clk (sck ),
            .flash_cs (cs ),
            .flash_datain (mosi ),
            .flash_dataout (miso ),
            .clock24M (clk24M ),
            .flash_rstn (rst_n ),
            .cmd_type (cmd_type ),
            .Done_Sig (done_sign ),
            .flash_cmd (cmd ),
            .flash_addr (addr ),
            .mydata_o (mydata_o ),
            .myvalid_o (myvalid_o ),
            .spi_state  ( spi_state)
        );

    //start和matrix信号上升沿检测
    always @(posedge clk24M) begin
        start_prev<=start;
        matrix_prev<=matrix;
    end

    //列数行数和当前采集列的计数器
    always @(posedge clk24M or negedge rst_n) begin
        if(!rst_n) begin
            cnt_line<=10'b0;
            cnt_raw<=10'b0;
            cnt_col_now<=10'b0;
        end
        else if(matrixrs) begin
            if(cnt_line<10'd639)
                cnt_line<=cnt_line+10'b1;
            else begin
                cnt_line<=10'b0;
                if(cnt_raw<10'd479)
                    cnt_raw<=cnt_raw+10'b1;
                else begin
                    cnt_raw<=10'b0;
                    if(cnt_col_now<10'd639)
                        cnt_col_now<=cnt_col_now+10'b1;
                    else
                        cnt_col_now<=10'b0;
                end
            end
        end
    end

    //flash状态机
    always @(posedge clk24M or negedge rst_n) begin
        if(!rst_n) begin
            state<=IDLE;
            cmd_type<=4'b0;
            cmd<=8'b0;
            addr<=24'b0;
            time_delay<=13'b0;
            cnt_se_erase<=8'b0;
            cnt_page<=11'b0;
            se_done<=1'b0;
            flash_init<=1'b0;
        end
        else begin
            case(state)
                IDLE: begin
                    if(startrs) begin //起始信号上升沿，启动
                        state<=RN_SEND;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_se_erase<=8'b0;
                        cnt_page<=11'b0;
                        se_done<=1'b0;
                    end
                    else begin
                        state<=IDLE;
                        cmd_type<=4'b0;
                        cmd<=8'b0;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_se_erase<=8'b0;
                        cnt_page<=11'b0;
                        se_done<=1'b0;
                    end
                end
                RN_SEND: begin
                    if(done_sign) begin //写完了命令,选择下一步,擦过进写入状态,否则进擦除状态
                        if(!se_done)
                            state<=SE_ERASE;
                        else
                            state<=PG_WRITE;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                    end
                    else begin
                        state<=RN_SEND;
                        cmd_type<=4'b1001;
                        cmd<=8'h06;
                        addr<=24'b0;
                        time_delay<=13'b0;
                    end
                end
                SE_ERASE: begin
                    if(cnt_se_erase<8'd75) begin //要擦除75个扇区才够用
                        if(done_sign) begin
                            state<=SE_WAIT;
                            cmd_type<=4'b0000;
                            cmd<=8'h00;
                            addr<=24'b0;
                            time_delay<=13'b0;
                            cnt_se_erase<=cnt_se_erase+8'b1;
                            cnt_page<=11'b0;
                        end
                        else begin
                            state<=SE_ERASE;
                            cmd_type<=4'b1001;
                            cmd<=8'h20;
                            addr<=24'b0+{16'd0,cnt_se_erase}*24'd4096; //擦除扇区地址
                            time_delay<=13'b0;
                            cnt_page<=11'b0;
                        end
                    end
                    else begin
                        state<=FL_WAIT;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_se_erase<=8'b0;
                        cnt_page<=11'b0;
                        se_done<=1'b1;
                    end
                end
                SE_WAIT: begin
                    if(time_delay<13'd100) begin
                        state<=SE_WAIT;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=time_delay+13'b1;
                        cnt_page<=11'b0;
                    end
                    else begin
                        state<=SE_ERASE;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_page<=11'b0;
                    end
                end
                FL_WAIT: begin
                    if(time_delay<13'd100) begin
                        state<=FL_WAIT;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=time_delay+13'b1;
                        cnt_se_erase<=8'b0;
                        cnt_page<=11'b0;
                    end
                    else begin
                        state<=PG_WRITE;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_se_erase<=8'b0;
                        cnt_page<=11'b0;
                        flash_init<=1'b1;
                    end
                end
                PG_WRITE: begin
                    if(done_sign) begin
                        state<=PG_WAIT;
                        cnt_page<=cnt_page+11'b1;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_se_erase<=8'b0;
                    end
                    else if(cnt_line==cnt_col_now) begin //到了采集列，开始写入
                        state<=PG_WRITE;
                        cmd<=8'h02;
                        addr<=24'd0+cnt_line+cnt_raw*24'd640;
                        cmd_type <= 4'b1101;
                        time_delay<=13'b0;
                        cnt_se_erase<=8'b0;
                    end
                    /*else begin
                        state<=IDLE;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_se_erase<=8'b0;
                        cnt_page<=11'b0;
                    end*/
                end
                PG_WAIT: begin
                    if(time_delay<13'd100) begin
                        state<=PG_WAIT;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=time_delay+13'b1;
                    end
                    else begin
                        if(cnt_col_now==10'd639 && cnt_raw==10'd479) begin //经过一列一列的写入,写完了一张图,休息一下吧
                            state<=IDLE;
                        end
                        else begin //没写完,继续写
                            state<=RN_SEND;
                        end
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                    end
                end
            endcase
        end
    end
endmodule
