module LD3320_Init(
    input clk,
    input sys_rstn,
    input ena,//
    inout [7:0] P,
    output A0,
    output CSB,
    output WRB,
    output RDB,
    output reg done
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
S33 = 6'd33;
reg [5:0] state, previous_state, next_state;
reg LD3320_ena, counter_ena, sel;
reg [7:0] address, data;
reg [7:0] div_num;
wire data_valid, data_ready;
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
        S3 : next_state = counter_done ? S4  : S3;
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
        S15: next_state = counter_done ? S16 : S15;
        S16: next_state = LD3320_done  ? S17 : S16;
        S17: next_state = LD3320_done  ? S18 : S17;
        S18: next_state = counter_done ? S19 : S18;
        S19: next_state = LD3320_done  ? S20 : S19;
        S20: next_state = LD3320_done  ? S21 : S20;
        S21: next_state = LD3320_done  ? S22 : S21;
        S22: next_state = LD3320_done  ? S23 : S22;
        S23: next_state = LD3320_done  ? S24 : S23;
        S24: next_state = counter_done ? S25 : S24;
        S25: next_state = LD3320_done  ? S26 : S25;
        S26: next_state = LD3320_done  ? S27 : S26;
        S27: next_state = LD3320_done  ? S28 : S27;
        S28: next_state = LD3320_done  ? S29 : S28;
        S29: next_state = LD3320_done  ? S30 : S29;
        S30: next_state = LD3320_done  ? S31 : S30;
        S31: next_state = LD3320_done  ? S32 : S31;
        S32: next_state = LD3320_done  ? S33 : S32;
        S33: next_state = counter_done ? S0 : S33;
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
        S1: begin//LD_ReadReg(0x06);  
            LD3320_ena = (previous_state == S1) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'h06;
            data = 8'h00;
        end
        S2: begin//LD_WriteReg(0x17, 0x35); 
            LD3320_ena = (previous_state == S2) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h17;
            data = 8'h35;
        end
        S3: begin//delay(10);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd26;
        end
        S4: begin//LD_ReadReg(0x06); 
            LD3320_ena = (previous_state == S4) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'h06;
            data = 8'h00;
        end
        S5: begin//LD_WriteReg(0x89, 0x03);
            LD3320_ena = (previous_state == S5) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h89;
            data = 8'h03;
        end
        S6: begin//delay(5);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd13;
        end
        S7: begin//LD_WriteReg(0xCF, 0x43);
            LD3320_ena = (previous_state == S7) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hCF;
            data = 8'h43;
        end
        S8: begin//delay(5);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd13;
        end
        S9: begin//LD_WriteReg(0xCB, 0x02);
            LD3320_ena = (previous_state == S9) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hCB;
            data = 8'h02;
        end
        S10: begin//LD_WriteReg(0x11, LD_PLL_11);  LD_PLL_11 = 10 0x0A
            LD3320_ena = (previous_state == S10) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h11;
            data = 8'h0A;
        end
        S11: begin//LD_WriteReg(0x1E,0x00);
            LD3320_ena = (previous_state == S11) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h1E;
            data = 8'h00;
        end
        S12: begin//LD_WriteReg(0x19, LD_PLL_ASR_19);  LD_PLL_ASR_19 = 64
            LD3320_ena = (previous_state == S12) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h19;
            data = 8'h40;
        end
        S13: begin//LD_WriteReg(0x1B, LD_PLL_ASR_1B);  LD_PLL_ASR_1B = 18
            LD3320_ena = (previous_state == S13) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h1B;
            data = 8'h18;
        end
        S14: begin//LD_WriteReg(0x1D, LD_PLL_ASR_1D);;  LD_PLL_ASR_1D = 31 0x1F
            LD3320_ena = (previous_state == S14) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h1D;
            data = 8'h1F;
        end
        S15: begin//delay(10);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd26;
        end
        S16: begin//LD_WriteReg(0xCD, 0x04);
            LD3320_ena = (previous_state == S16) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hCD;
            data = 8'h04;
        end
        S17: begin//LD_WriteReg(0x17, 0x4c); 
            LD3320_ena = (previous_state == S17) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h17;
            data = 8'h4C;
        end
        S18: begin//delay(5);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd13;
        end
        S19: begin//LD_WriteReg(0xB9, 0x00);
            LD3320_ena = (previous_state == S19) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hB9;
            data = 8'h00;
        end
        S20: begin//LD_WriteReg(0xCF, 0x4F); 
            LD3320_ena = (previous_state == S20) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hCF;
            data = 8'h4F;
        end
        S21: begin//LD_WriteReg(0x6F, 0xFF); 
            LD3320_ena = (previous_state == S21) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h6F;
            data = 8'hFF;
        end
        //LD_Init_ASR()
        S22: begin//LD_WriteReg(0xBD, 0x00);
            LD3320_ena = (previous_state == S22) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hBD;
            data = 8'h00;
        end
        S23: begin//LD_WriteReg(0x17, 0x48);
            LD3320_ena = (previous_state == S23) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h17;
            data = 8'h48;
        end
        S24: begin//delay(10);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd26;
        end
        S25: begin//LD_WriteReg(0x3C, 0x80);    
            LD3320_ena = (previous_state == S25) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h3C;
            data = 8'h80;
        end
        S26: begin//LD_WriteReg(0x3E, 0x07);
            LD3320_ena = (previous_state == S26) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h3E;
            data = 8'h07;
        end
        S27: begin//LD_WriteReg(0x38, 0xff);    
            LD3320_ena = (previous_state == S27) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h38;
            data = 8'hff;
        end
        S28: begin//LD_WriteReg(0x3A, 0x07);
            LD3320_ena = (previous_state == S28) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h3A;
            data = 8'h07;
        end
        //
        S29: begin//LD_WriteReg(0x40, 0);  
            LD3320_ena = (previous_state == S29) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h40;
            data = 8'h00;
        end
        S30: begin//LD_WriteReg(0x42, 8);
            LD3320_ena = (previous_state == S30) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h42;
            data = 8'h08;
        end
        S31: begin//LD_WriteReg(0x44, 0);    
            LD3320_ena = (previous_state == S31) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h44;
            data = 8'h00;
        end
        S32: begin//LD_WriteReg(0x46, 8);
            LD3320_ena = (previous_state == S32) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h46;
            data = 8'h08;
        end
        S33: begin//delay(1);
            LD3320_ena = 1'b0;
            counter_ena = 1'b1;
            sel = 1'b0;
            div_num = 8'd03;
            done = 1'b1;
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