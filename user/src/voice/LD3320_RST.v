module LD3320_RST(
    input clk_d3,
    input sys_rstn,
    input ena,
    output reg CSB,
    output reg RST,
    output done
    );
parameter [2:0]
S0 = 3'o0,
S1 = 3'o1,
S2 = 3'o2,
S3 = 3'o3,
S4 = 3'o4;
reg [2:0] state, next_state;
always@(posedge clk_d3 or negedge sys_rstn) begin
    if(!sys_rstn) begin
        state <= S0;
    end
    else begin
        state <= next_state;
    end
end
always @(posedge clk_d3 or negedge sys_rstn) begin
    case(state) 
        S0: next_state = ena ? S1 : S0;
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S4;
        S4: next_state = S0;
        default:next_state = S0; 
    endcase
end
always @(*) begin
    case(state)
        S0: begin
            RST = 1'b1;
            CSB = 1'b0;
        end
        S1: begin
            RST = 1'b0;
            CSB = 1'b0;
        end
        S2: begin
            RST = 1'b1;
            CSB = 1'b0;
        end
        S3: begin
            RST = 1'b1;
            CSB = 1'b1;
        end
        S3: begin
            RST = 1'b1;
            CSB = 1'b1;
        end
        default: begin
            RST = 1'b1;
            CSB = 1'b0;
        end 
    endcase
end
assign done = state == S3;
endmodule