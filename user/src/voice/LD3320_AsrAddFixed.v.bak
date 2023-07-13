module LD3320_AsrAddFixed(
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
parameter [5:0] 
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
S19 = 6'd19,
S20 = 6'd20,
S21 = 6'd21,
S22 = 6'd22,
S23 = 6'd23,
S24 = 6'd24,
S25 = 6'd25,
S26 = 6'd26,
S27 = 6'd27,
S28 = 6'd28,
S29 = 6'd29,
S30 = 6'd30,
S31 = 6'd31,
S32 = 6'd32,
S33 = 6'd33,
S34 = 6'd34,
S35 = 6'd35,
S36 = 6'd36,
S37 = 6'd37,
S38 = 6'd38,
S39 = 6'd39;
reg [3:0] cnt;
reg [5:0] state, previous_state, next_state;
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
        S2 : next_state = judge  ? S3  : ((cnt == 4'hA) ? S39 : S1);
        S3 : next_state = LD3320_done  ? S4  : S3;
        S4 : next_state = LD3320_done  ? S5  : S4;
        S5 : next_state = LD3320_done  ? S6  : S5;
        S6 : next_state = counter_done ? S7  : S6;
        S7 : next_state = LD3320_done  ? S8  : S7;
        S8 : next_state = counter_done ? S9  : S8;
        S9 : next_state = LD3320_done  ? S10 : S9;
        S10: next_state = LD3320_done  ? S11 : S10;
        S11: next_state = LD3320_done  ? S12 : S11;
        S12: next_state = LD3320_done  ? S13 : S12;
        S13: next_state = LD3320_done  ? S14 : S13;
        S14: next_state = LD3320_done  ? S15 : S14;
        S15: next_state = LD3320_done  ? S16 : S15;
        S16: next_state = LD3320_done  ? S17 : S16;
        S17: next_state = LD3320_done  ? S18 : S17;
        S18: next_state = LD3320_done  ? S19 : S18;
        S19: next_state = LD3320_done  ? S20 : S19;
        S20: next_state = judge  ? S21  : ((cnt == 4'hA) ? S39 : S19);
        S21: next_state = LD3320_done  ? S22 : S21;
        S22: next_state = LD3320_done  ? S23 : S22;
        S23: next_state = LD3320_done  ? S24 : S23;
        S24: next_state = counter_done ? S25 : S24;
        S25: next_state = LD3320_done  ? S26 : S25;
        S26: next_state = counter_done ? S27 : S26;
        S27: next_state = LD3320_done  ? S28 : S27;
        S28: next_state = LD3320_done  ? S29 : S28;
        S29: next_state = LD3320_done  ? S30 : S29;
        S30: next_state = LD3320_done  ? S31 : S30;
        S31: next_state = LD3320_done  ? S32 : S31;
        S32: next_state = LD3320_done  ? S33 : S32;
        S33: next_state = LD3320_done  ? S34 : S33;
        S34: next_state = LD3320_done  ? S35 : S34;
        S35: next_state = LD3320_done  ? S36 : S35;
        S36: next_state = LD3320_done  ? S37 : S36;
        S37: next_state = LD3320_done  ? S38 : S37;
        S38: next_state = LD3320_done  ? S0  : S38;
        S39: next_state = S0;
        default:next_state = S0; 
    endcase
end
always @(*) begin
    address = 8'h00;
    data = 8'h00;
    counter_ena = 1'b0;
    done = 1'b0;
    invalid = 1'b0;
    case(state)
        S0: begin//未使能
            LD3320_ena = 1'b0;
            sel = 1'b0;
            cnt = 4'h0;
        end
        S1: begin//检查是否繁忙
            LD3320_ena = (previous_state == S1) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'hB2;
            data = 8'h00;
            invalid = 1'b0;
            if(data_ready) begin
                data_tmp = data_valid;
            end
        end
        S2 : begin
            judge = (data_tmp == 8'h21) ? 1'b1 : 1'b0;
            data_tmp = 8'h00;
            cnt = cnt + 4'b1; 
        end
        S3: begin//LD_WriteReg(0xc1, pCode[0] );识别码 0
            LD3320_ena = (previous_state == S3) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hC1;
            data = 8'h00;
            cnt = 4'h0;
        end
        S4: begin//LD_WriteReg(0xc3, 0 );
            LD3320_ena = (previous_state == S4) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hC3;
            data = 8'h00;
        end
        S5: begin//LD_WriteReg(0x08, 0x04);
            LD3320_ena = (previous_state == S5) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h08;
            data = 8'h04;
        end
        S6: begin//delay(1);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
        end
        S7: begin//LD_WriteReg(0x08, 0x00);
            LD3320_ena = (previous_state == S7) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h08;
            data = 8'h00;
        end
        S8: begin//delay(1);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
        end
        //写入dian zu
        S9: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]);    d
            LD3320_ena = (previous_state == S9) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h64;
        end
        S10: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]);    i
            LD3320_ena = (previous_state == S10) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h61;
        end
        S11: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]);    a
            LD3320_ena = (previous_state == S11) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h69;
        end
        S12: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]);    n
            LD3320_ena = (previous_state == S12) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h20;
        end
        S13: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]);    space
            LD3320_ena = (previous_state == S13) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h7A;
        end
        S14: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]);    z
            LD3320_ena = (previous_state == S14) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h68;
        end
        S15: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]);    u
            LD3320_ena = (previous_state == S15) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h65;
        end
        //end
        S16: begin//LD_WriteReg(0xb9, nAsrAddLength); nAsrAddLength = 7
            LD3320_ena = (previous_state == S16) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hB9;
            data = 8'h07;
        end
        S17: begin//LD_WriteReg(0xb2, 0xff);
            LD3320_ena = (previous_state == S17) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hB2;
            data = 8'hFF;
        end
        S18: begin//LD_WriteReg(0x37, 0x04);
            LD3320_ena = (previous_state == S18) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h37;
            data = 8'h04;
            cnt = 4'h0;
        end
        //end
        S19: begin//检查是否繁忙
            LD3320_ena = (previous_state == S19) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'hB2;
            data = 8'h00;
            invalid = 1'b0;
            if(data_ready) begin
                data_tmp = data_valid;
            end
        end
        S20 : begin
            judge = (data_tmp == 8'h21) ? 1'b1 : 1'b0;
            data_tmp = 8'h00;
            cnt = cnt + 4'b1; 
        end
        //写入dian rong
        S21: begin//LD_WriteReg(0xc1, pCode[1] );
            LD3320_ena = (previous_state == S21) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hC1;
            data = 8'h01;
            cnt = 4'h0;
        end
        S22: begin//LD_WriteReg(0xc3, 0 );
            LD3320_ena = (previous_state == S22) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hC3;
            data = 8'h00;
        end
        S23: begin//LD_WriteReg(0x08, 0x04);
            LD3320_ena = (previous_state == S23) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h08;
            data = 8'h04;
        end
        S24: begin//delay(1);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
        end
        S25: begin//LD_WriteReg(0x08, 0x00);
            LD3320_ena = (previous_state == S25) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h08;
            data = 8'h00;
        end
        S26: begin//delay(1);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
        end
        //dian zu
        S27: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); d
            LD3320_ena = (previous_state == S27) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h64;
        end
        S28: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); i
            LD3320_ena = (previous_state == S28) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h69;
        end
        S29: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); a
            LD3320_ena = (previous_state == S29) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h61;
        end
        S30: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); n
            LD3320_ena = (previous_state == S30) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h6E;
        end
        S31: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); space
            LD3320_ena = (previous_state == S31) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h20;
        end
        S32: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); r
            LD3320_ena = (previous_state == S32) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h72;
        end
        S33: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); o
            LD3320_ena = (previous_state == S33) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h6F;
        end
        S34: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); n
            LD3320_ena = (previous_state == S34) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h6E;
        end
        S35: begin//LD_WriteReg(0x5, sRecog[k][nAsrAddLength]); g   
            LD3320_ena = (previous_state == S35) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h05;
            data = 8'h67;
        end
        S36: begin//LD_WriteReg(0xb9, nAsrAddLength);  nAsrAddLength = 9
            LD3320_ena = (previous_state == S36) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h09;
            data = 8'h09;
        end
        S37: begin//LD_WriteReg(0xb2, 0xff);
            LD3320_ena = (previous_state == S37) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hB2;
            data = 8'hFF;
        end
        S38: begin//LD_WriteReg(0x37, 0x04);
            LD3320_ena = (previous_state == S38) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h37;
            data = 8'h04;
            done = 1'b1;
        end
        S39: begin
            LD3320_ena = 1'b0;
            sel = 1'b1;
            address = 8'h00;
            data = 8'h00;
            done = 1'b1;
            invalid = 1'b1;
        end
        default: begin
            LD3320_ena = 1'b0;
            sel = 1'b0;
            cnt = 4'h0;
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