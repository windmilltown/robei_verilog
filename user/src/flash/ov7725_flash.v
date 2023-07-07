module ov7725_flash(
        input clk, //50MHz时钟
        input rst_n, //复位
        input clk24M, //24MHz时钟

        output sck, //SPI clock
        output cs, //spi片选信号
        output mosi, //spi数据输给flash
        input miso, //flash spi数据输出

        input [7:0] pixel,//输入像素(灰度)
        input start //上升沿触发起始信号
    );

    //parameter define//
    parameter IDLE=3'b000;
    parameter RN_SEND=3'b001;
    parameter SE_ERASE=3'b011;
    parameter FL_WAIT=3'b010;
    parameter PG_WRITE=3'b110;
    parameter SE_WAIT=3'b111;
    parameter PG_WAIT=3'b101;

    //wire define//
    wire startrs;
    wire done_sign;
    wire [7:0] mydata_o;
    wire myvalid_o;
    wire [2:0] spi_state;

    //reg define//
    reg start_prev;
    reg [2:0] state;
    reg [3:0] cmd_type;
    reg [7:0] cmd;
    reg [23:0] addr;
    reg [12:0] time_delay;
    reg [7:0] cnt_se_erase;
    reg [10:0] cnt_page;
    reg se_done;

    //assign define//
    assign startrs=(~start_prev) & start;

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

    //start信号上升沿检测
    always @(posedge clk24M) begin
        start_prev<=start;
    end

    always @(posedge clk24M or negedge rst_n) begin
        if(!rst_n) begin
            state<=IDLE;
            cmd_type<=4'b0;
            cmd<=8'b0;
            addr<=24'b0;
            time_delay<=13'b0;
            cnt_se_erase<=8'b0;
            cnt_page<=11'b0;
        end
        else begin
            case(state)
                IDLE: begin
                    if(startrs) begin
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
                    if(done_sign) begin
                        if(!se_done)
                            state<=SE_ERASE;
                        else
                            state<=PG_WRITE;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_page<=11'b0;
                    end
                    else begin
                        state<=RN_SEND;
                        cmd_type<=4'b1001;
                        cmd<=8'h06;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_page<=11'b0;
                    end
                end
                SE_ERASE: begin
                    if(cnt_se_erase<8'd75) begin
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
                            addr<=24'b0+{16'd0,cnt_se_erase}*24'd4096;
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
                    end
                end
                PG_WRITE: begin
                    if(cnt_page<11'd1200) begin
                        if(done_sign) begin
                            state<=PG_WAIT;
                            cnt_page<=cnt_page+11'b1;
                            cmd_type<=4'b0000;
                            cmd<=8'h00;
                            addr<=24'b0;
                            time_delay<=13'b0;
                            cnt_se_erase<=8'b0;
                        end
                        else begin
                            state<=PG_WRITE;
                            cmd<=8'h02;
                            addr<=24'd0+cnt_page*24'd256;
                            cmd_type <= 4'b1101;
                            time_delay<=13'b0;
                            cnt_se_erase<=8'b0;
                        end
                    end
                    else begin
                        state<=IDLE;
                        cmd_type<=4'b0000;
                        cmd<=8'h00;
                        addr<=24'b0;
                        time_delay<=13'b0;
                        cnt_se_erase<=8'b0;
                        cnt_page<=11'b0;
                    end
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
                        state<=RN_SEND;
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
