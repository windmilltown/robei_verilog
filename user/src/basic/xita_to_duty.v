//角度->占空比转换
//输入：32位定点数角度xita[31:0]
//输出：20位占空比duty[19:0]
//功能：根据给定的角度输出对应的占空比
module xita_to_duty(
    input [31:0] xita,
    output reg [19:0] duty
);
    wire [50:0] temp;

    assign temp=xita[30:0]*50_000/(90*65536);

    always @(*) 
    begin
        if(xita[31]==1'b0)
        begin
            if(xita[31:0]<=32'h005A_0000)
                duty=75_000+temp[19:0];
            else
                duty=125_000;
        end
        else //if(xita[31]==1'b1)
        begin
            if({1'b0,xita[30:0]}<=32'h005A_0000)
                duty=75_000-temp[19:0];
            else
                duty=25_000;
        end
    end
endmodule