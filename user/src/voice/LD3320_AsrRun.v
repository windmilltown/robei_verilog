module LD3320_AsrRun(
    input clk,
    input sys_rstn,
    input ena,//
    inout [7:0] P,
    output A0,
    output CSB,
    output WRB,
    output RDB,
    output reg done,
    output reg invalid
);
parameter [4:0] 
S0  = 6'd0 ,
S1  = 6'd1 ,
S2  = 6'd2 ,
S3  = 6'd3 ,
S4  = 6'd4 ,
S5  = 6'd5 ,
S6  = 6'd6 ,
S7  = 6'd7 ,
S8  = 6'd8 ,
S9  = 6'd9 ,
S10 = 6'd10,
S11 = 6'd11,
S12 = 6'd12,
S13 = 6'd13,
S14 = 6'd14,
S15 = 6'd15,
S16 = 6'd16,
S17 = 6'd17,
S18 = 6'd18,
S19 = 6'd19;
reg [3:0] cnt;
reg [4:0] state, previous_state, next_state;
reg LD3320_ena, counter_ena, sel;
reg [7:0] address, data;
reg [7:0] div_num;
wire data_ready;
wire [7:0] data_valid;
reg [7:0] data_tmp;
reg judge;
wire LD3320_done, counter_done;
always@(posedge clk or negedge sys_rstn) begin
    if(!sys_rstn) begin
        state <= S0;
    end
    else begin
        state <= next_state;
        previous_state <= state;
    end
end
always @(*) begin
    case(state) 
        S0 : next_state = ena ? S1 : S0;
        S1 : next_state = LD3320_done  ? S2  : S1;
        S2 : next_state = LD3320_done  ? S3  : S2;
        S3 : next_state = LD3320_done  ? S4  : S3;
        S4 : next_state = LD3320_done  ? S5  : S4;
        S5 : next_state = counter_done ? S6  : S5;
        S6 : next_state = LD3320_done  ? S7  : S6;
        S7 : next_state = counter_done ? S8  : S7;
        S8 : next_state = LD3320_done  ? S9  : S8;
        S9 : next_state = judge ? S10 : ((cnt ==4'hA) ? S19 : S8);
        S10: next_state = LD3320_done  ? S11 : S10;
        S11: next_state = LD3320_done  ? S12 : S11;
        S12: next_state = counter_done ? S13 : S12;
        S13: next_state = LD3320_done  ? S14 : S13;
        S14: next_state = counter_done ? S15 : S14;
        S15: next_state = LD3320_done  ? S16 : S15;
        S16: next_state = counter_done ? S17 : S16;
        S17: next_state = LD3320_done  ? S18 : S17;
        S18: next_state = LD3320_done  ? S0 : S18;
        S19: next_state = S0;
        default:next_state = S0; 
    endcase
end
always @(*) begin
    address = 8'h00;
    data = 8'h00;
    counter_ena = 1'b0;
    done = 1'b0;
    case(state)
        S0: begin//未使能
            LD3320_ena = 1'b0;
            sel = 1'b0;
        end
        S1: begin//LD_WriteReg(0x35, MIC_VOL); MIC_VOL = 0x43
            LD3320_ena = (previous_state == S1) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h35;
            data = 8'h43;
        end
        S2: begin//LD_WriteReg(0x1C, 0x09);
            LD3320_ena = (previous_state == S2) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h1C;
            data = 8'h09;
        end
        S3: begin//LD_WriteReg(0xBD, 0x20);
            LD3320_ena = (previous_state == S3) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hBD;
            data = 8'h20;
        end
        S4: begin//LD_WriteReg(0x08, 0x01); 
            LD3320_ena = (previous_state == S4) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h08;
            data = 8'h01;
        end
        S5: begin//delay( 1 );
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
        end
        S6: begin//LD_WriteReg(0x08, 0x00);
            LD3320_ena = (previous_state == S6) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h08;
            data = 8'h00;
        end
        S7: begin//delay( 1 );
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
            cnt = 4'h0;
        end
        S8: begin//判断是否空闲
            LD3320_ena = (previous_state == S8) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'hB2;
            data =8'h00;
            invalid = 1'b0;
            if(data_ready) begin
                data_tmp = data_valid;
            end
        end
        S9: begin
            judge = (data_tmp == 8'h21) ? 1'b1 : 1'b0;
            data_tmp = 8'h00;
            cnt = cnt + 4'h1;
        end
        S10: begin//LD_WriteReg(0x1C, 0x0b); 配置麦克风做为输入信号
            LD3320_ena = (previous_state == S10) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h1C;
            data = 8'h0b;
            cnt = 4'h0;
        end
        S11: begin//LD_WriteReg(0xB2, 0xff);
            LD3320_ena = (previous_state == S11) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hB2;
            data = 8'hff;
        end
        S12: begin//delay( 1);	
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
        end
        S13: begin//LD_WriteReg(0x37, 0x06);
            LD3320_ena = (previous_state == S13) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h37;
            data = 8'h06;
        end
        S14: begin//delay( 1 );
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
        end
        S15: begin//LD_WriteReg(0x37, 0x06);
            LD3320_ena = (previous_state == S15) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h37;
            data = 8'h06;
        end
        S16: begin//delay( 5 );
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd13;
        end
        S17: begin//LD_WriteReg(0x29, 0x10);
            LD3320_ena = (previous_state == S17) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h1B;
            data = 8'h18;
        end
        S18: begin//LD_WriteReg(0xBD, 0x00);
            LD3320_ena = (previous_state == S18) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hBD;
            data = 8'h00;
            done = 1'b1;
        end
        S19: begin
            LD3320_ena = 1'b0;
            sel = 1'b1;
            address = 8'h00;
            data = 8'h00;
            done = 1'b1;
            invalid = 1'b1;
        end
        default: begin

        end 
    endcase
end
LD3320WriteRead LD3320WriteRead_dut (
  .clk (clk ),
  .rst_n (sys_rstn),
  .ena (LD3320_ena ),
  .sel (sel ),//1为写0为读
  .address (address ),
  .data (data ),
  .P (P ),
  .A0 (A0 ),
  .CSB (CSB ),
  .WRB (WRB ),
  .RDB (RDB ),
  .data_valid (data_valid ),
  .data_ready (data_ready ),
  .done  (LD3320_done)
);
counter counter_inst(
    .clk(clk),
    .sys_rstn(sys_rstn),
    .ena(counter_ena),
    .div_num(div_num),
    .done(counter_done)
);
endmodule