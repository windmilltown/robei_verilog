module LD3320_test(
        input sys_clk,
        input sys_rstn,
        //input ena,
        input interrupt,
        inout [7:0] P,
        output A0,
        output CSB,
        output WRB,
        output RDB,
        output LD3320_RST,

        output reg led1,
        output reg led2
    );

    //parameter define

    //wire define
    wire [7:0] result_valid;
    wire result_ready;
    wire ready_rs;

    //reg define
    reg [7:0] cnt=8'd0;
    reg ld3320_clk=1'b1;
    reg ready_prev;

    //assign define
    assign ready_rs = result_ready & (~ready_prev);

    //instance define
    LD3320_Top 
    LD3320_Top_dut (
      .clk (ld3320_clk ),
      .sys_rstn (sys_rstn ),
      .ena (1'b1 ),
      .interrupt (interrupt ),
      .P (P ),
      .A0 (A0 ),
      .CSB (CSB ),
      .WRB (WRB ),
      .RDB (RDB ),
      .result_valid (result_valid ),
      .result_ready (result_ready ),
      .LD3320_RST  ( LD3320_RST)
    );
  

    //鍒嗛
    always @(posedge sys_clk or negedge sys_rstn) begin
        if(!sys_rstn) begin
            cnt <= 8'h00;
            ld3320_clk <= 1'b1;
        end
        else begin
            if(cnt == 8'd24) begin
                cnt <= 8'h00;
                ld3320_clk <= ~ld3320_clk;
            end
            else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    //ready涓婂崌娌挎娴
    always @(posedge ld3320_clk or negedge sys_rstn) begin
        if(!sys_rstn) begin
            ready_prev <= 1'b0;
        end
        else begin   
            ready_prev <= result_ready;
        end
    end

    //ready鎷夐珮涓€娆★紝valid鏁版嵁鏈夋晥涓€娆
    always @(posedge ld3320_clk or negedge sys_rstn) begin
        if(!sys_rstn) begin
            led1 <= 1'b0;
            led2 <= 1'b0;
        end
        else if(ready_rs)begin
            if(result_valid == 8'h00) begin
                led1 <= ~led1;
            end
            else begin
                led2 <= ~led2;
            end
        end
    end

endmodule