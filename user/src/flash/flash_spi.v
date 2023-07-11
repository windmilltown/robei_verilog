//spi协议与flash通信模块
//输入：flash_cmd,flash_addr,cmd_type,flash_rstn,clock24M
//输出：flash_clk,flash_cs,flash_datain,mydata_o,myvalid_o,Done_Sig
//功能：发送命令、地址、读写数据，读写flash数据
module flash_spi(
        output flash_clk, //SPI clock
        output reg flash_cs, //spi片选信号
        output reg flash_datain, //spi数据输给flash
        input flash_dataout, //spi数据输出flash
        input clock24M, //24M时钟
        input flash_rstn, //复位信号
        input [3:0] cmd_type, //命令类型
        output reg Done_Sig, //发送完成信号
        input [7:0] flash_cmd, //命令内容
        input [23:0] flash_addr, //读写地址
        output reg [7:0] mydata_o, //读到的数据(单字节)
        output myvalid_o, //读完一个字节数据
        output reg [2:0] spi_state //状态机变量
    );

    //parameter define//
    parameter idle=3'b000;
    parameter cmd_send=3'b001;
    parameter address_send=3'b010;
    parameter read_wait=3'b011;
    parameter write_data=3'b101;
    parameter finish_done=3'b110;

    //reg define//
    reg myvalid;
    reg [7:0] mydata;
    reg spi_clk_en=1'b0;
    reg data_come;
    reg [7:0] cmd_reg;
    reg [23:0] address_reg;
    reg [7:0] cnta;
    reg [8:0] write_cnt;
    reg [7:0] cntb;
    reg [8:0] read_cnt;
    reg [8:0] read_num;
    reg read_finish;

    //assign define//
    assign myvalid_o=myvalid;
    assign flash_clk=spi_clk_en?clock24M:0;

    //发送读 flash 命令//
    always @(negedge clock24M) begin
        if(!flash_rstn) begin
            flash_cs<=1'b1;
            spi_state<=idle;
            cmd_reg<=0;
            address_reg<=0;
            spi_clk_en<=1'b0; //SPI clock 输出不使能
            cnta<=0;
            write_cnt<=0;
            read_num<=0;
            address_reg<=0;
            Done_Sig<=1'b0;
        end
        else begin
            case(spi_state)
                idle: begin
                    spi_clk_en<=1'b0;
                    flash_cs<=1'b1;
                    flash_datain<=1'b1;
                    cmd_reg<=flash_cmd;
                    address_reg<=flash_addr;
                    Done_Sig<=1'b0;
                    if(cmd_type[3]==1'b1) begin //如果 flash 操作命令请求
                        spi_state<=cmd_send;
                        cnta<=7;
                        write_cnt<=0;
                        read_num<=0;
                    end
                end
                cmd_send: begin
                    spi_clk_en<=1'b1; //flash 的 SPI clock 输出
                    flash_cs<=1'b0; //cs 拉低
                    if(cnta>0) begin //如果 cmd_reg 还没有发送完
                        flash_datain<=cmd_reg[cnta]; //发送 bit7~bit1 位
                        cnta<=cnta-1'b1;
                    end
                    else begin //发送 bit0
                        flash_datain<=cmd_reg[0];
                        if ((cmd_type[2:0]==3'b001) | (cmd_type[2:0]==3'b100)) begin //如果是Write Enable/disable instruction
                            spi_state<=finish_done;
                        end
                        else if (cmd_type[2:0]==3'b011) begin //如果是 read register1
                            spi_state<=read_wait;
                            cnta<=7;
                            read_num<=1; //接收一个数据
                        end
                        else begin //如果是 sector erase, page program,read data,read device ID
                            spi_state<=address_send;
                            cnta<=23;
                        end
                    end
                end
                address_send: begin
                    if(cnta>0) begin //如果 cmd_reg 还没有发送完
                        flash_datain<=address_reg[cnta]; //发送 bit23~bit1 位
                        cnta<=cnta-1;
                    end
                    else begin //发送 bit0
                        flash_datain<=address_reg[0];
                        if(cmd_type[2:0]==3'b010) begin //如果是 sector erase
                            spi_state<=finish_done;
                        end
                        else if (cmd_type[2:0]==3'b101) begin //如果是 page program
                            spi_state<=write_data;
                            cnta<=7;
                        end
                        else if (cmd_type[2:0]==3'b000) begin //如果是读 Device ID
                            spi_state<=read_wait;
                            read_num<=2; //接收 2 个数据的 Device ID
                        end
                        else begin
                            spi_state<=read_wait;
                            read_num<=256; //接收 256 个数据
                        end
                    end
                end
                read_wait: begin
                    if(read_finish) begin
                        spi_state<=finish_done;
                        data_come<=1'b0;
                    end
                    else
                        data_come<=1'b1;
                end
                write_data: begin
                    if(write_cnt<256) begin // program 256 byte to flash
                        if(cnta>0) begin //如果 data 还没有发送完
                            flash_datain<=write_cnt[cnta]; //发送 bit7~bit1 位
                            cnta<=cnta-1'b1;
                        end
                        else begin
                            flash_datain<=write_cnt[0]; //发送 bit0
                            cnta<=7;
                            write_cnt<=write_cnt+1'b1;
                        end
                    end
                    else begin
                        spi_state<=finish_done;
                        spi_clk_en<=1'b0;
                    end
                end
                finish_done: begin
                    flash_cs<=1'b1;
                    flash_datain<=1'b1;
                    spi_clk_en<=1'b0;
                    Done_Sig<=1'b1;
                    spi_state<=idle;
                end
                default:
                    spi_state<=idle;
            endcase
        end
    end
    //接收 flash 数据
    always @(posedge clock24M) begin
        if(!flash_rstn) begin
            read_cnt<=0;
            cntb<=0;
            read_finish<=1'b0;
            myvalid<=1'b0;
            mydata<=0;
            mydata_o<=0;
        end
        else
            if(data_come) begin
                if(read_cnt<read_num) begin //接收数据
                    if(cntb<7) begin //接收一个 byte 的 bit0~bit6
                        myvalid<=1'b0;
                        mydata<={mydata[6:0],flash_dataout};
                        cntb<=cntb+1'b1;
                    end
                    else begin
                        myvalid<=1'b1; //一个 byte 数据有效
                        mydata_o<={mydata[6:0],flash_dataout}; //接收 bit7
                        cntb<=0;
                        read_cnt<=read_cnt+1'b1;
                    end
                end
                else begin
                    read_cnt<=0;
                    read_finish<=1'b1;
                    myvalid<=1'b0;
                end
            end
            else begin
                read_cnt<=0;
                cntb<=0;
                read_finish<=1'b0;
                myvalid<=1'b0;
                mydata<=0;
            end
    end
endmodule
