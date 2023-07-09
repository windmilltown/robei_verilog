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
        input flag,
        output pwm_table,
        output dir_table,

        //OLED顶层接口
        inout dht11,
        output OLED_SCL,
	    output OLED_SDA
    );

    //parameter define
    parameter [31:0] L1 = 32'h0007_6666;//单位是cm,7.4cm
    parameter [31:0] L2 = 32'h0012_0000;//18cm
    parameter [31:0] h = 32'h0005_3333;//5.2cm
    parameter IDLE = 3'b000; //空闲状态
    parameter CATCHING = 3'b001; //抓取状态
    parameter GOBACK = 3'b011; //回归状态
    parameter SET = 3'b010; //放下物品状态

    //wire define
    wire uart_valid;
    wire [31:0] x;
    wire [31:0] y;
    wire [31:0] z;

    //reg define
    reg clr;
    reg [31:0] x_reg;
    reg [31:0] y_reg;
    reg [31:0] z_reg;
    reg en1;
    reg en2;
    reg [31:0] set_xita1;
    reg [31:0] set_xita2;
    reg catch;
    reg table_start;
    reg table_back;
    reg [31:0] table_dest;
    reg [2:0] state=IDLE;
    reg [31:0] cnt;

    //module instance
    uart_top 
    uart_top_dut (
      .clk50 (clk ),
      .rst_n (rst_n ),
      .rx (rx ),
      .clr (clr ),
      .tx (tx ),
      .x (x ),
      .y (y ),
      .z (z ),
      .valid  ( uart_valid)
    );
  
    arm_model 
    arm_model_dut (
      .clk (clk ),
      .x (x_reg ),
      .y (y_reg ),
      .en1 (en1 ),
      .en2 (en2 ),
      .rst_n (rst_n ),
      .set_xita1 (set_xita1 ),
      .set_xita2 (set_xita2 ),
      .catch (catch ),
      .pwm1 (pwm1 ),
      .pwm2 (pwm2 ),
      .catch_pwm  ( catch_pwm)
    );

    pwm_fre 
    pwm_fre_dut (
      .clk (clk ),
      .start (table_start ),
      .en (flag ),
      .back (table_back ),
      .dest (table_dest ),
      .pwm_out_fre (pwm_table ),
      .dir  ( dir_table)
    );  
    
	 OLED_sensor
	 OLED_sensor_dut(	
	.sys_clk(clk),
	.rst_n(rst_n),
	
	.dht11(dht11),
	
	.OLED_SCL(OLED_SCL),
	.OLED_SDA(OLED_SDA)
	);

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            clr=1'b0;
            x_reg=1'b0;
            y_reg=L1+L2;
            z_reg=32'd0;
            en1=1'b0;
            en2=1'b0;
            set_xita1=32'd0;
            set_xita2=32'd0;
            catch=1'b0;
            table_start=1'b1;
            table_back=1'b1;
            table_dest=32'd0;
            state=IDLE;
            cnt=32'd0;
        end
        else begin
            case(state)
                IDLE:begin
                    if(uart_valid) begin
                        state<=CATCHING;
                    end
                    else begin
                        clr<=1'b0;
                        x_reg<=1'b0;
                        y_reg<=L1+L2;
                        z_reg<=32'd0;
                        en1<=1'b0;
                        en2<=1'b1;
                        set_xita1<=32'd0;
                        set_xita2<=32'd0;
                        catch<=1'b0;
                        table_start<=1'b1;
                        table_back<=1'b1;
                        table_dest<=32'd0;
                        state<=IDLE;
                        cnt<=32'd0;
                    end
                end
                CATCHING:begin
                    //cnt<=cnt+1;
                    if(cnt==32'd100) begin
                        table_back<=1'b0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd120) begin
                        table_back<=1'b1;
                        table_dest<=z;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd500_000_000) begin //回到了原点,启动
                        table_start<=1'b0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd500_000_020) begin
                        table_start<=1'b1;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd1_000_000_000) begin //到了指定位置
                        catch<=1'b0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd1_100_000_000) begin //放下手臂
                        x_reg<=x;
                        y_reg<=y;
                        en1<=1'b1;
                        en2<=1'b0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd1_500_000_000) begin //夹取
                        catch<=1'b1;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd1_700_000_000) begin //抬起手臂
                        x_reg<=0;
                        y_reg<=L1+L2;
                        en1<=1'b0;
                        en2<=1'b1;
                        set_xita1<=32'd0;
                        set_xita2<=32'd0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt>=32'd2_000_000_000) begin
                        state<=GOBACK;
                        cnt<=32'd0;
                    end
                    else begin
                        cnt<=cnt+32'd1;
                    end
                end
                GOBACK:begin
                    //cnt<=cnt+32'd1;
                    if(cnt==32'd20) begin
                        table_back<=1'b0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd30) begin
                        table_back<=1'b1;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt>=32'd500_000_000) begin //回到了起始位置
                        state<=SET;
                        cnt<=32'd0;
                    end
                    else begin
                        cnt<=cnt+32'd1;
                    end
                end
                SET:begin
                    if(cnt==32'd20) begin
                        x_reg<=x;
                        y_reg<=y;
                        en1<=1'b1;
                        en2<=1'b0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd150_000_000) begin //手臂到了放下位置
                        catch<=1'b0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd250_000_000) begin //放完了回位
                        x_reg<=0;
                        y_reg<=L1+L2;
                        en1<=1'b0;
                        en2<=1'b1;
                        set_xita1<=32'd0;
                        set_xita2<=32'd0;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt==32'd400_000_000) begin
                        clr<=1'b1;
                        cnt<=cnt+32'd1;
                    end
                    else if(cnt>=32'd400_000_020) begin
                        clr<=1'b0;
                        catch<=1'b1;
                        state<=IDLE;
                        cnt<=32'd0;
                    end
                    else begin
                        cnt<=cnt+32'd1;
                    end
                end
            endcase
        end
    end
endmodule
