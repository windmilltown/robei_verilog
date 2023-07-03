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
output reg data_ready
);
parameter [2:0] IDLE = 3'b000,
ADDRESS_WRITE = 3'b001,
ADDRESS_WRITEDONE = 3'b011,
DATA_READ = 3'b010,
DATA_WRITE= 3'b110,
DATA_WRITEDONE = 3'b111,
DATA_READDONE = 3'b101;
reg [2:0] state, next_state;
reg [7:0] P_tmp;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= IDLE;
	end 
	else begin
		state <= next_state;
	end
end
always@(*) begin
	case(state) 
		IDLE: next_state = ena ? ADDRESS_WRITE : IDLE;
		ADDRESS_WRITE: next_state = ADDRESS_WRITEDONE;
		ADDRESS_WRITEDONE: next_state =  sel ? DATA_WRITE : DATA_READ ;
		DATA_READ: next_state = DATA_READDONE;
		DATA_READDONE: next_state = IDLE;
		DATA_WRITE: next_state = DATA_WRITEDONE;
		DATA_WRITEDONE: next_state = IDLE;
	endcase
end
always@(*) begin
	case(state)
		IDLE: begin
			P_tmp[7:0] = 8'h00;
			A0 = 1'b0;
			CSB = 1'b1;
			WRB = 1'b1;
			RDB = 1'b1;
			data_valid[7:0] = 8'h00;
			data_ready = 1'b0;
		end
		ADDRESS_WRITE: begin
			P_tmp[7:0] = address;
			A0 = 1'b1;
			CSB = 1'b0;
			WRB = 1'b0;
			RDB = 1'b1;
			data_valid[7:0] = 8'h00;
			data_ready = 1'b0;
		end
		ADDRESS_WRITEDONE: begin
			P_tmp[7:0] = address;
			A0 = 1'b1;
			CSB = 1'b1;
			WRB = 1'b1;
			RDB = 1'b1;
			data_valid[7:0] = 8'h00;
			data_ready = 1'b0;
		end
		DATA_WRITE: begin
			P_tmp[7:0] = data[7:0];
			A0 = 1'b0;
			CSB = 1'b0;
			WRB = 1'b0;
			RDB = 1'b1;
			data_valid[7:0] = 8'h00;
			data_ready = 1'b0;
		end
		DATA_WRITEDONE: begin
			P_tmp[7:0] = data[7:0];
			A0 = 1'b1;
			CSB = 1'b1;
			WRB = 1'b1;
			RDB = 1'b1;
			data_valid[7:0] = 8'h00;
			data_ready = 1'b0;
		end
		DATA_READ: begin
			P_tmp[7:0] = 8'h00;
			A0 = 1'b0;
			CSB = 1'b0;
			WRB = 1'b1;
			RDB = 1'b0;
			data_valid[7:0] = P;
			data_ready = 1'b1;
		end
		DATA_READDONE: begin
			P_tmp[7:0] = 8'h00;
			A0 = 1'b1;
			CSB = 1'b1;
			WRB = 1'b1;
			RDB = 1'b1;
			data_valid[7:0] = 8'h00;
			data_ready = 1'b0;
		end
	endcase
end
assign P = (state == DATA_READ) ? 8'bzzzzzzzz : P_tmp;
endmodule