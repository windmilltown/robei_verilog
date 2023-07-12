module LD3320WriteRead(
input clk,
input rst_n,
input ena,//
input sel,
input [7:0] address,
input [7:0] data,
inout [7:0] P,
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
reg [7:0] state;
reg [7:0] P_tmp;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= Idle;
		P_tmp <= 8'b00000000;
		A0 <= 1'b0;
		CSB <= 1'b1;
		WRB <= 1'b1;
		RDB <= 1'b1;
		data_valid <= 8'b00000000;
		data_ready <= 1'b0;
	end
	else begin
		case(state)
			Idle: begin
				state <= ena ? PrewriteAddress : Idle;
				A0 <= 1'b0;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_tmp <= 8'b00000000;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			PrewriteAddress: begin
				state <= WriteAddress;
				A0 <= 1'b1;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_tmp <= address;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			WriteAddress: begin
				state <= AddressDone;
				A0 <= 1'b1;
				CSB <= 1'b0;
				WRB <= 1'b0;
				RDB <= 1'b1;
				P_tmp <= address;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			AddressDone: begin
				state <= PrepareData;
				A0 <= 1'b1;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_tmp <= address;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			PrepareData: begin
				state <= sel ? WriteData : ReadData;
				A0 <= 1'b0;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_tmp <= sel ? data : 8'bzzzzzzzz;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			WriteData: begin
				state <= Done;
				A0 <= 1'b0;
				CSB <= 1'b0;
				WRB <= 1'b0;
				RDB <= 1'b1;
				P_tmp <= data;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end
			ReadData: begin
				state <= Done;
				A0 <= 1'b0;
				CSB <= 1'b0;
				WRB <= 1'b1;
				RDB <= 1'b0;
				P_tmp <= 8'bzzzzzzzz;
				data_valid <= P;
				data_ready <= 1'b1;
				done <= 1'b0;
			end
			Done: begin
				state <= Idle;
				A0 <= 1'b0;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_tmp <= 8'b00000000;
				data_valid <= data_valid;
				data_ready <= data_ready;
				done <= 1'b1;
			end
			default: begin
				state <= ena ? PrewriteAddress : Idle;
				A0 <= 1'b0;
				CSB <= 1'b1;
				WRB <= 1'b1;
				RDB <= 1'b1;
				P_tmp <= 8'b00000000;
				data_valid <= 8'b00000000;
				data_ready <= 1'b0;
				done <= 1'b0;
			end			
		endcase
	end
end
assign P = P_tmp;
endmodule