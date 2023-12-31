module counter(
    input clk,
    input sys_rstn,
    input ena,
    input [11:0] div_num,
    output reg done
);
reg ena_pre;
reg [11:0] cnt;
wire ena_rise;
always@(posedge clk) begin
    ena_pre <= ena;
end
always @(posedge clk or negedge sys_rstn) begin
    if(!sys_rstn) begin
        cnt <= 12'h00;
        done <= 1'b0;
    end
    else if(ena_rise) begin
        cnt <= div_num - 1;
    end
    else if (cnt == 12'h01) begin
        cnt <= 12'h00;
        done <= 1'b1;
    end
    else if (cnt == 12'h00) begin
        cnt <= 12'h00;
        done <= 1'b0;
    end
    else begin
        cnt <= cnt - 12'd1;
    end
end
assign ena_rise = ~ena_pre & ena;
endmodule