module LD3320_ctrl(
    input clk_1M,
    input sys_rstn,
    output reg valid,
    output [7:0] data,
    output CSB,
    output WRB,
    output RDB,
    output A0,
    output reg RST,
    inout [7:0] P
);
parameter [7:0]
S0 = 8'd0,
S1 = 8'd1,
S2 = 8'd2,
S3 = 8'd3,
S4 = 8'd4,
S5 = 8'd5,
S6 = 8'd6,
S7 = 8'd7,
S8 = 8'd8,
S9 = 8'd9,
S10 = 8'd10,
S11 = 8'd11,
S12 = 8'd12,
S13 = 8'd13,
S14 = 8'd14,
S15 = 8'd15,
S16 = 8'd16,
S17 = 8'd17,
S18 = 8'd18,
S19 = 8'd19
;
reg [7:0] state, next_state;
reg counter_done,LD3320_done,counter_ena,LD3320_ena;
reg data_ready;
reg [7:0] data_out, address, div_num;
reg sel;
reg CSB1, CSB2;
reg CSB_sel;
always @(posedge clk_1M or negedge sys_rstn) begin
    if(!sys_rstn) begin
        state <= S0;
        valid <= 1'b0;
    end
    else begin
        state <= next_state;
    end
end
always @(*) begin
    case(state)
        //LD_Reset
        S0 : next_state = S1;
        S1 : next_state = counter_done ? S2 : S1;
        S2 : next_state = S3;
        S3 : next_state = counter_done ? S4 : S3;
        S4 : next_state = S5;
        S5 : next_state = counter_done ? S6 : S5;
        S6 : next_state = S7;
        S7 : next_state = counter_done ? S8 : S7;
        S8 : next_state = S9;
        S9 : next_state = counter_done ? S10: S9;
        //
        S10: next_state = LD3320_done ? S11: S10;
        S11: next_state = LD3320_done ? S12: S11;
        S12: next_state = LD3320_done ? S13: S12;
        S13: next_state = LD3320_done ? S14: S13;
        S14: next_state = LD3320_done ? S15: S14;
        S15: next_state = LD3320_done ? S16: S15;
        S16: next_state = LD3320_done ? S17: S16;
        S17: next_state = LD3320_done ? S18: S17;
        S18: next_state = LD3320_done ? S19: S18;
        S19: next_state = LD3320_done ? S19: S19;
        default:next_state = S0; 
    endcase
end
always@(*) begin
    RST = 1'b1;
    data_out = 8'h00;
    address = 8'h00;
    LD3320_ena = 1'b0;
    sel = 1'b0;
    CSB1 = 1'b0;
    CSB_sel = 1'b0;
    case (state)
        S0 : begin
            RST = 1'b1;
            counter_ena = 1'b0;
            CSB_sel = 1'b1;
        end
        S1 : begin
            RST = 1'b1;
            counter_ena = 1'b1;
            div_num <= 8'h2;
            CSB_sel = 1'b1;
        end
        S2 : begin
            RST = 1'b0;
            counter_ena = 1'b0;
            CSB_sel = 1'b1;
        end 
        S3 : begin
            RST = 1'b0;
            counter_ena = 1'b1;
            div_num <= 8'h2;
            CSB_sel = 1'b1;
        end 
        S4 : begin
            RST = 1'b1;
            counter_ena = 1'b0;
            CSB_sel = 1'b1;
        end 
        S5 : begin
            RST = 1'b1;
            counter_ena = 1'b1;
            div_num <= 8'h2;
            CSB_sel = 1'b1;
        end 
        S6 : begin
            RST = 1'b1;
            CSB1 = 1'b0;
            counter_ena = 1'b0;
            CSB_sel = 1'b1;
        end 
        S7 : begin
            RST = 1'b1;
            CSB1 = 1'b0;
            counter_ena = 1'b1;
            div_num <= 8'h2;
            CSB_sel = 1'b1;
        end
        S8 : begin
            RST = 1'b1;
            CSB1 = 1'b1;
            counter_ena = 1'b0;
            CSB_sel = 1'b1;
        end 
        S9 : begin
            RST = 1'b1;
            CSB1 = 1'b1;
            counter_ena = 1'b1;
            div_num <= 8'h2;
            CSB_sel = 1'b1;
        end  
        //default: 
    endcase
end
counter counter_inst(
    .clk(clk_1M),
    .sys_rstn(sys_rstn),
    .ena(counter_ena),
    .div_num(div_num),
    .done(counter_done)
);
LD3320WriteRead LD3320WriteRead_dut (
  .clk (clk_1M),
  .rst_n (sys_rstn),
  .ena (LD3320_ena ),
  .sel (sel ),
  .address (address ),
  .data (data_out ),
  .P (P ),
  .A0 (A0 ),
  .CSB (CSB2 ),
  .WRB (WRB ),
  .RDB (RDB ),
  .data_valid (data ),
  .data_ready (data_ready ),
  .done      (LD3320_done )
);
assign CSB = CSB_sel ? CSB1 : CSB2;
endmodule