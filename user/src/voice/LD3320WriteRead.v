module LD3320WriteRead(
input clk,
input rst_n,
input ena,//
input sel,
input [7:0] address,
input [7:0] data,
input [7:0] P_in,
output reg P_sel,//0-in,1-out
output reg [7:0] P_out,
output reg A0,
output reg CSB,
output reg WRB,
output reg RDB,
output reg [7:0] data_valid,
output reg data_ready,
output reg done
);
parameter [7:0] Idle = 8'b00000001,
PrewriteAddress = 8'b00000010,
WriteAddress = 8'b00000100,
AddressDone = 8'b00001000,
PrepareData = 8'b00010000,
WriteData = 8'b00100000,
ReadData = 8'b01000000,
Done = 8'b10000000;
reg [7:0] previous_state, state;
reg [7:0] P_tmp;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= Idle;
		previous_state <= Idle;
		P_out <= 8'h00;
		P_sel = 1'b1;
		A0 <= 1'b0;
		CSB <= 1'b1;
		WRB <= 1'b1;
		RDB <= 1'b1;
		data_valid <= 8'h00;
		data_ready <= 1'b0;
	end
	else begin
		case(state)
			Idle: begin
				state <= ena ? PrewriteAddress : Idle;
				previous_state <= state;
				A0 <= 1'b0;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_out <= 8'h00;
				P_sel <= 1'b1;
				data_valid <= 8'h00;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			PrewriteAddress: begin
				state <= WriteAddress;
				previous_state <= state;
				A0 <= 1'b1;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_out <= address;
				P_sel <= 1'b1;
				data_valid <= 8'h00;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			WriteAddress: begin
				state <= AddressDone;
				previous_state <= state;
				A0 <= 1'b1;
				CSB <= 1'b0;
				WRB <= 1'b0;
				RDB <= 1'b1;
				P_out <= address;
				P_sel <= 1'b1;
				data_valid <= 8'h00;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			AddressDone: begin
				state <= PrepareData;
				previous_state <= state;
				A0 <= 1'b1;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_out <= address;
				P_sel <= 1'b1;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			PrepareData: begin
				state <= sel ? WriteData : ReadData;
				previous_state <= state;
				A0 <= 1'b0;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_out <= data;
				P_sel <= sel ? 1'b1 : 1'b0;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			WriteData: begin
				state <= Done;
				previous_state <= state;
				A0 <= 1'b0;
				CSB <= 1'b0;
				WRB <= 1'b0;
				RDB <= 1'b1;
				P_out <= data;
				P_sel <= 1'b1;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			ReadData: begin
				state <= Done;
				previous_state <= state;
				A0 <= 1'b0;
				CSB <= 1'b0;
				WRB <= 1'b1;
				RDB <= 1'b0;
				P_out <= 8'h00;
				P_sel <= 1'b0;
				data_valid <= 8'h00;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			Done: begin
				previous_state <= state;
				state <= Idle;
				if(previous_state == ReadData) begin
					A0 <= 1'b0;
					CSB <= 1'b0;
					WRB <= 1'b1;
					RDB <= 1'b0;
					P_out <= 8'h00;
					P_sel <= 1'b0;
					data_valid <= P_in;
					data_ready <= 1'b1;
				end
				else begin
					A0 <= 1'b0;
					CSB <= 1'b1;
					WRB <= 1'b1;
					RDB <= 1'b1;
					P_out <= 8'h00;
					P_sel <= 1'b1;
					data_valid <= 8'h00;
					data_ready <= 1'b0;
				end
				done <= 1'b1;
			end
			default: begin
				state <= ena ? PrewriteAddress : Idle;
				previous_state <= state;
				A0 <= 1'b0;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_sel <= 1'b1;
				P_tmp <= 8'h00;
				data_valid <= 8'h00;
				data_ready <= 1'b0;
				done <= 1'b0;
			end			
		endcase
	end
end
endmodule