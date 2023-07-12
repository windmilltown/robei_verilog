module LD3320_Interrupt(
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
S20 = 6'd20;
reg [5:0] state, previous_state, next_state;
reg LD3320_ena, sel;
reg [7:0] address, data;
reg [7:0] div_num;
wire data_ready;
wire LD3320_done;
wire [7:0] data_valid;
reg [7:0] data_tmp;
reg judge;
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
        S2 : next_state = judge        ? S3  : S11;
        S3 : next_state = LD3320_done  ? S4  : S3;
        S4 : next_state = LD3320_done  ? S5  : S4;
        S5 : next_state = LD3320_done  ? S6  : S5;
        S6 : next_state = judge        ? S7  : S11;
        S7 : next_state = LD3320_done  ? S8  : S7;
        S8 : next_state = judge        ? S9  : S11;
        S9 : next_state = LD3320_done  ? S10 : S9;
        S10: next_state = judge        ? S11 : S11;
        S11: next_state = LD3320_done  ? S12 : S11;
        S12: next_state = LD3320_done  ? S13 : S12;
        S13: next_state = LD3320_done  ? S14 : S13;
        S14: next_state = LD3320_done  ? S15 : S14;
        S15: next_state = LD3320_done  ? S16 : S15;
        S16: next_state = LD3320_done  ? S17 : S16;
        S17: next_state = LD3320_done  ? S18 : S17;
        S18: next_state = LD3320_done  ? S19 : S18;
        S19: next_state = LD3320_done  ? S20 : S19;
        S20: next_state = LD3320_done  ? S0 : S20;
        default:next_state = S0; 
    endcase
end
always @(*) begin
    address = 8'h00;
    data = 8'h00;
    done = 1'b0;
    case(state)
        S0: begin//未使能
            LD3320_ena = 1'b0;
            sel = 1'b0;
            invalid = 1'b0;
        end
        S1: begin//LD_ReadReg(0x2B);  
            LD3320_ena = (previous_state == S1) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'h06;
            data = 8'h00;
            invalid = 1'b0;
            if(data_ready) begin
                data_tmp = data_valid;
            end
        end
        S2: begin//判断
            judge = data_tmp[4] ? 1'b1 : 1'b0;
            invalid = ~judge;
            data_tmp = 8'h00;
        end
        S3: begin//LD_WriteReg(0x29,0) ;
            LD3320_ena = (previous_state == S3) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h29;
            data = 8'h00;
        end
        S4: begin//LD_WriteReg(0x02,0) ;
            LD3320_ena = (previous_state == S4) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h02;
            data = 8'h00;
        end
        S5: begin//LD_ReadReg(0xb2)
            LD3320_ena = (previous_state == S5) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'hb2;
            data = 8'h00;
            if(data_ready) begin
                data_tmp = data_valid;
            end
        end
        S6: begin//判断
            judge = (data_tmp == 8'h21);
            invalid = ~judge;
            data_tmp = 8'h00;
        end
        S7: begin//LD_ReadReg(0xbf);
            LD3320_ena = (previous_state == S7) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'hBF;
            data = 8'h00;
            if(data_ready) begin
                data_tmp = data_valid;
            end
        end
        S8: begin//判断
            judge = (data_tmp == 8'h35);
            invalid = ~judge;
            data_tmp = 8'h00;
        end
        S9: begin//LD_ReadReg(0xba);
            LD3320_ena = (previous_state == S9) ? 1'b0 : 1'b1;
            sel = 1'b0;
            address = 8'hBA;
            data = 8'h00;
            if(data_ready) begin
                data_tmp = data_valid;
            end
        end
        S10: begin//判断
            judge = ((data_tmp > 8'h00) && (data_tmp <= 8'h02));
            invalid = ~judge;
            data_tmp = 8'h00;
        end
        S11: begin//LD_WriteReg(0x2b, 0);
            LD3320_ena = (previous_state == S11) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h2B;
            data = 8'h00;
        end
        S12: begin//LD_WriteReg(0x1C,0);
            LD3320_ena = (previous_state == S12) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h1C;
            data = 8'h00;
        end
        S13: begin//LD_WriteReg(0x29,0) ;
            LD3320_ena = (previous_state == S13) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h29;
            data = 8'h00;
        end
        S14: begin//LD_WriteReg(0x02,0) ;
            LD3320_ena = (previous_state == S14) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h02;
            data = 8'h00;
        end
        S15: begin//LD_WriteReg(0x2B,  0);
            LD3320_ena = (previous_state == S15) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h2B;
            data = 8'h00;
        end
        S16: begin//LD_WriteReg(0xBA, 0);
            LD3320_ena = (previous_state == S16) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hBA;
            data = 8'h00;
        end
        S17: begin//LD_WriteReg(0xBC,0);
            LD3320_ena = (previous_state == S17) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hBC;
            data = 8'h00;
        end
        S18: begin//LD_WriteReg(0x08,1);	 /*清除FIFO_DATA*/
            LD3320_ena = (previous_state == S18) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h08;
            data = 8'h01;
        end
        S19: begin//LD_WriteReg(0xB9, 0x00);
            LD3320_ena = (previous_state == S19) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'hB9;
            data = 8'h00;
        end
        S20: begin//LD_WriteReg(0x08,0);	/*清除FIFO_DATA后 再次写0*/
            LD3320_ena = (previous_state == S20) ? 1'b0 : 1'b1;
            sel = 1'b1;
            address = 8'h08;
            data = 8'h00;
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
endmodule