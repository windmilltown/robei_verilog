`ifndef QMULTI_V
`define QMULTI_V
module qmulti(
    input [31:0] multi1,
    input [31:0] multi2,
    output [31:0] result
);

reg [63:0] tmp=0;
reg [31:0] result_out=0;

assign result=result_out;

always @(*) 
begin
    tmp=multi1[30:0]*multi2[30:0];
    if(multi1[31]==multi2[31])
    begin
        result_out={1'b0,tmp[46:16]};
    end
    else
    begin
        result_out={1'b1,tmp[46:16]};
    end
end

endmodule
`endif