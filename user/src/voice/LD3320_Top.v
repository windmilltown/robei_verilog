module LD3320_Top(
    input clk,
    input sys_rstn,
    input ena,
    input interrupt,
    input [7:0] P_in,
    output reg P_sel,
    output reg [7:0] P_out,
    output reg A0,
    output reg CSB,
    output reg WRB,
    output reg RDB,
    output reg [7:0] result_valid,
    output reg result_ready,
    output LD3320_RST
);
parameter [3:0] 
Idle =4'd0,
RST = 4'd1,
Delay_1 = 4'd2,
AsrInit = 4'd3,
Delay_2 = 4'd4,
AsrAddFixed = 4'd5,
Delay_3 = 4'd6,
AsrRun = 4'd7,
WaitForData = 4'd8,
Interrupt = 4'd9,
GetResult = 4'd10,
SendResult = 4'd11;
reg [2:0] cnt;
reg [3:0] previous_state, state, next_state;/*synthesis noprune*/
reg RST_ena, Init_ena, AddFixed_ena, Run_ena, Interrupt_ena, GetResult_ena, counter_ena;
wire RST_done, Init_done, AddFixed_done, Run_done, Interrupt_done, GetResult_done, counter_done;
wire AddFixed_invalid, Run_invalid, Interrupt_invalid;
reg [11:0] div_num;
wire [7:0] Init_P_out, AddFixed_P_out, Run_P_out, Interrupt_P_out, GetResult_P_out;
wire Init_P_sel, AddFixed_P_sel, Run_P_sel, Interrupt_P_sel, GetResult_P_sel;
wire Init_A0, AddFixed_A0, Run_A0, Interrupt_A0, GetResult_A0;
wire RST_CSB, Init_CSB, AddFixed_CSB, Run_CSB, Interrupt_CSB, GetResult_CSB;
wire Init_WRB, AddFixed_WRB, Run_WRB, Interrupt_WRB, GetResult_WRB;
wire Init_RDB, AddFixed_RDB, Run_RDB, Interrupt_RDB, GetResult_RDB;
wire [7:0] data_valid;
wire data_ready;
always@(posedge clk or negedge sys_rstn)begin
    if(~sys_rstn) begin
		  previous_state <= Idle;
        state <= Idle;
    end
    else begin
        state <= next_state;
        previous_state <= state;
    end
end
always @(*) begin
    case (state)
        Idle        : next_state = ena            ? RST       : Idle;
        RST         : next_state = RST_done       ? Delay_1     : RST;
        Delay_1     : next_state = counter_done   ? AsrInit     : Delay_1;
        AsrInit     : next_state = Init_done      ? Delay_2     : AsrInit;
        Delay_2     : next_state = counter_done   ? AsrAddFixed : Delay_2;
        AsrAddFixed : next_state = AddFixed_done  ? (AddFixed_invalid ? RST : Delay_3) : AsrAddFixed;
        Delay_3     : next_state = counter_done   ? AsrRun      : Delay_3;
        AsrRun      : next_state = Run_done       ? (Run_invalid ? RST : WaitForData)  : AsrRun;
        WaitForData : next_state = ~interrupt      ? Interrupt   :  WaitForData;
        Interrupt   : next_state = Interrupt_done ? (Interrupt_invalid ? RST : GetResult) : Interrupt;
        GetResult   : next_state = GetResult_done ? SendResult  : GetResult;
        SendResult  : next_state = RST;
        default: state = Idle;
    endcase
end
always @(*) begin
	A0 = 1'b0;
    CSB = 1'b1;
    WRB = 1'b1;
    RDB = 1'b1;
    RST_ena = 1'b0;
    Init_ena = 1'b0;
    AddFixed_ena = 1'b0;
    Run_ena = 1'b0;
    Interrupt_ena = 1'b0;
    GetResult_ena = 1'b0;
    counter_ena = 1'b0;
    result_ready = 1'b0;
    case(state)
        Idle:begin
            P_out = 8'h00;
            P_sel = 1'b0;
            A0 = 1'b0;
            CSB = 1'b1;
            WRB = 1'b1;
            RDB = 1'b1;
            result_valid = 8'h00;
            result_ready = 1'b0;
        end
        RST:begin
            P_out = 8'h00;
            P_sel = 1'b0;
            RST_ena = 1'b1;
            A0 = 1'b0;
            CSB = RST_CSB;
            WRB = 1'b1;
            RDB = 1'b1;
            result_valid = 8'h00;
            result_ready = 1'b0;
        end
        Delay_1:begin
            P_out = 8'h00;
            P_sel = 1'b0;
            counter_ena = 1'b1;
            div_num = 12'd700;
        end
        AsrInit:begin
            P_out = Init_P_out;
            P_sel = Init_P_sel;
            Init_ena = 1'b1;
            A0 = Init_A0;
            CSB = Init_CSB;
            WRB = Init_WRB;
            RDB = Init_RDB;
            result_valid = 8'h00;
            result_ready = 1'b0;
        end
        Delay_2:begin
            P_out = 8'h00;
            P_sel = 1'b0;
            counter_ena = 1'b1;
            div_num = 12'd700;
        end
        AsrAddFixed:begin
            P_out = AddFixed_P_out;
            P_sel = AddFixed_P_sel;
            AddFixed_ena = 1'b1;
            A0 = AddFixed_A0;
            CSB = AddFixed_CSB;
            WRB = AddFixed_WRB;
            RDB = AddFixed_RDB;
            result_valid = 8'h00;
            result_ready = 1'b0;
        end
        Delay_3:begin
            P_out = 8'h00;
            P_sel = 1'b0;
            counter_ena = 1'b1;
            div_num = 12'd900;
        end
        AsrRun:begin
            P_out = Run_P_out;
            P_sel = Run_P_sel;
            Run_ena = 1'b1;
            A0 = Run_A0;
            CSB = Run_CSB;
            WRB = Run_WRB;
            RDB = Run_RDB;
            result_valid = 8'h00;
            result_ready = 1'b0;
        end
        WaitForData:begin
            P_out = 8'h00;
            P_sel = 1'b0;
            A0 = 1'b0;
            CSB = 1'b1;
            WRB = 1'b1;
            RDB = 1'b1;
            result_valid = 8'h00;
            result_ready = 1'b0;
        end
        Interrupt:begin
            P_out = Interrupt_P_out;
            P_sel = Interrupt_P_sel;
            Interrupt_ena = 1'b1;
            A0 = Interrupt_A0;
            CSB = Interrupt_CSB;
            WRB = Interrupt_WRB;
            RDB = Interrupt_RDB;
            result_valid = 8'h00;
            result_ready = 1'b0;
        end
        GetResult:begin
            P_out = GetResult_P_out;
            P_sel = GetResult_P_sel;
            GetResult_ena = 1'b1;
            A0 = GetResult_A0;
            CSB = GetResult_CSB;
            WRB = GetResult_WRB;
            RDB = GetResult_RDB;
            result_ready = 1'b0;
            if(data_ready) begin
                result_valid = data_valid;
            end
        end
        SendResult:begin
            P_out = 8'h00;
            P_sel = 1'b0;
            result_valid = result_valid;
            result_ready = 1'b1;
        end
        default:begin
            P_out = 8'h00;
            P_sel = 1'b0;
            A0 = 1'b0;
            CSB = 1'b1;
            WRB = 1'b1;
            RDB = 1'b1;
            result_valid = 8'h00;
            result_ready = 1'b0;
        end
    endcase
end

LD3320_RST LD3320_RST_dut (
  .clk_d3 (clk ),
  .sys_rstn (sys_rstn ),
  .ena (RST_ena ),
  .CSB (RST_CSB ),
  .RST (LD3320_RST ),
  .done  ( RST_done)
);
counter counter_dut (
  .clk (clk ),
  .sys_rstn (sys_rstn ),
  .ena (counter_ena ),
  .div_num (div_num ),
  .done  ( counter_done)
);
LD3320_Init LD3320_Init_dut (
  .clk (clk ),
  .sys_rstn (sys_rstn ),
  .ena (Init_ena ),
  .P_in (P_in ),
  .P_out (Init_P_out ),
  .P_sel (Init_P_sel ),
  .A0 (Init_A0 ),
  .CSB (Init_CSB ),
  .WRB (Init_WRB ),
  .RDB (Init_RDB ),
  .done  ( Init_done)
);
LD3320_AsrAddFixed LD3320_AsrAddFixed_dut (
  .clk (clk ),
  .sys_rstn (sys_rstn ),
  .ena (AddFixed_ena ),
  .P_in (P_in ),
  .P_sel (AddFixed_P_sel ),
  .P_out (AddFixed_P_out ),
  .A0 (AddFixed_A0 ),
  .CSB (AddFixed_CSB ),
  .WRB (AddFixed_WRB ),
  .RDB (AddFixed_RDB ),
  .done (AddFixed_done ),
  .invalid  ( AddFixed_invalid)
);
LD3320_AsrRun LD3320_AsrRun_dut (
  .clk (clk ),
  .sys_rstn (sys_rstn ),
  .ena (Run_ena ),
  .P_in (P_in ),
  .P_sel (Run_P_sel ),
  .P_out (Run_P_out ),
  .A0 (Run_A0 ),
  .CSB (Run_CSB ),
  .WRB (Run_WRB ),
  .RDB (Run_RDB ),
  .done (Run_done ),
  .invalid  ( Run_invalid)
);
LD3320_Interrupt LD3320_Interrupt_dut (
  .clk (clk ),
  .sys_rstn (sys_rstn ),
  .ena (Interrupt_ena ),
  .P_in (P_in ),
  .P_sel (Interrupt_P_sel ),
  .P_out (Interrupt_P_out ),
  .A0 (Interrupt_A0 ),
  .CSB (Interrupt_CSB ),
  .WRB (Interrupt_WRB ),
  .RDB (Interrupt_RDB ),
  .done (Interrupt_done ),
  .invalid  ( Interrupt_invalid)
);
LD3320WriteRead LD3320WriteRead_dut (
  .clk (clk ),
  .rst_n (sys_rstn ),
  .ena (GetResult_ena ),
  .sel (1'b0 ),
  .address (8'hC5 ),
  .data (8'h00 ),
  .P_in (P_in ),
  .P_sel (GetResult_P_sel ),
  .P_out (GetResult_P_out ),
  .A0 (GetResult_A0 ),
  .CSB (GetResult_CSB ),
  .WRB (GetResult_WRB ),
  .RDB (GetResult_RDB ),
  .data_valid (data_valid ),
  .data_ready (data_ready ),
  .done  ( GetResult_done)
);
endmodule