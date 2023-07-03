`timescale 1ns/1ps

module testbench();

    reg  clk;
    reg  rst;
    wire  SDA;
    wire  SCL;
    reg IICWriteReq;
    reg IICReadReq;
    wire IICWriteDone;
    wire IICReadDone;
    always # 50 clk = ~clk;
    initial begin
        $dumpfile("testbeach.vcd");
        $dumpvars(0, testbench);
        clk = 1'b1;
        rst = 1'b1;

        IICWriteReq = 1'b0;
        IICReadReq = 1'b1;
        #100   /*�ֶ���λ*/
        rst = 1'b0;
        #100
        rst = 1'b1;
    end
    
    always@(posedge clk)
        if(IICReadDone == 1'b1)   /*����ɺ�readReqΪ0��ֻ����һ�ζ�д����*/
            IICReadReq <= 1'b0;
        else
            IICReadReq <= IICReadReq;

IIC_Driver  IIC_DriverHP(
    .sys_clk            (clk),           /*ϵͳʱ��*/
    .rst_n              (rst),             /*ϵͳ��λ*/

    .IICSCL             (SCL),            /*IIC ʱ�����*/
    .IICSDA             (SDA),             /*IIC ������*/

    .IICSlave           ('h1234),

    .IICWriteReq        (IICWriteReq),       /*IICд�Ĵ�������*/
    .IICWriteDone        (IICWriteDone),      /*IICд�Ĵ������*/
    .IICWriteData        ('h5a),      /*IIC�������� 8bit�Ĵӻ���ַ + 8bit�ļĴ�����ַ + 8bit������(�����ԣ���Ĭ��Ϊ0)*/

    .IICReadReq         (IICReadReq),        /*IIC���Ĵ�������*/
    .IICReadDone        (IICReadDone),       /*IIC���Ĵ������*/
    .IICReadData        ()/*IIC��ȡ��ַ*/
);

endmodule
