//uart顶层模块
//输入：系统时钟clk50,复位信号rst_n,uart接收信号rx,清零信号clr
//输出：uart发送信号tx,串口输入的x,y,z坐标,有效信号valid
//功能：将串口uart输入的数据转换为x,y,z坐标输出,并通过串口uart发送
module uart_top(
        input clk50,
        input rst_n,
        input rx,
        input clr,
        output tx,
        output reg [31:0] x,
        output reg [31:0] y,
        output reg [31:0] z,
        output valid
    );

    wire clk;
    wire start;
    wire [7:0] data;
    wire dataerror;
    wire frameerror;
    wire [31:0] x_wire;
    wire [31:0] y_wire;
    wire [31:0] z_wire;

    reg [13:0] cnt;
    reg [7:0] datain;
    reg wrsig;

    clkdiv 
    clkdiv_dut (
      .clk50 (clk50 ),
      .rst_n (rst_n ),
      .clkout  ( clk)
    );

    uartrx 
    uartrx_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .rx (rx ),
      .dataout (data ),
      .rdsig (start ),
      .dataerror ( ),
      .frameerror  ( )
    );

    uart_asc_num 
    uart_asc_num_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .asc (data ),
      .start (start ),
      .dataerror ( ),
      .frameerror ( ),
      .clr (clr ),
      .xdataout (x_wire ),
      .ydataout (y_wire ),
      .zdataout (z_wire ),
      .valid  ( valid)
    );

    uarttx 
    uarttx_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .datain (datain ),
      .wrsig (wrsig ),
      .idle ( ),
      .tx  ( tx)
    );
  

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            x <= 32'd0;
            y <= 32'd0;
            z <= 32'd0;
            cnt <= 14'd0;
            datain <= 8'd0;
            wrsig <= 1'b0;
        end
        else if(clr) begin
            x <= 32'd0;
            y <= 32'd0;
            z <= 32'd0;
            cnt <= 14'd0;
            datain <= 8'd0;
            wrsig <= 1'b0;
        end
        else if(valid) begin
            x <= x_wire;
            y <= y_wire;
            z <= z_wire;
            if(cnt == 14'd1016) begin
                datain <= x[31:24]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd2033) begin
                datain <= x[23:16]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd3050) begin
                datain <= x[15:8]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd4067) begin
                datain <= x[7:0]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end

            else if(cnt == 14'd5084) begin
                datain <= y[31:24]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd6101) begin
                datain <= y[23:16]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd7118) begin
                datain <= y[15:8]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd8135) begin
                datain <= y[7:0]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end

            else if(cnt == 14'd9152) begin
                datain <= z[31:24]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd10169) begin
                datain <= z[23:16]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd11186) begin
                datain <= z[15:8]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= cnt + 14'd1;
            end
            else if(cnt == 14'd12203) begin
                datain <= z[7:0]; 
                wrsig <= 1'b1; //产生发送命令
                cnt <= 14'd0;
            end
            else begin
                wrsig <= 1'b0;
                cnt <= cnt + 14'd1;
            end
        end   
        else
        begin
            wrsig <= 1'b0;
            cnt <= 14'd0;
        end
    end
  
endmodule