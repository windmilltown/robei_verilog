//滑台顶层
//`include "set_fre.v"
//`include "push_pwm_fre.v"

module pwm_fre(
  input clk, //系统时钟50MHz
  input start, //开始标志,低电平触发,保持一个时钟周期
  input en, //非停止信号,低电平时停止移动，需要接到滑台限位器上,不影响start移动滑台
  input back, //回到滑台最左侧限位处,低电平触发,保持一个时钟周期
  input [31:0] dest, //要移动到的位置,单位是cm,请勿超过32'h0013_0000
  //input [19:0] fre_need,
  //input [19: 0] fre_gap,
  output  reg pwm_out_fre, //输出的pwm波,通过调频控制滑台速度
  output reg dir //输出的方向信号,0为向右,1为向左
);
reg biao=1'b1;
wire pwm_tmp;
reg [31:0]cha=32'h00000000;
reg backn=1'b1;
reg [31:0] locat=32'h00000000;
push_pwm_fre p(
               .clk(clk),
               //.fre(fre),
               .pwm_wave_fre(pwm_tmp)
             );

//  assign fre_need = fre_need_reg;


always @(posedge clk) begin
 if(!start)begin
  biao<=0;
  backn<=1;
  
  if (locat>dest) begin
    cha<=((locat-dest)<<7)*3;

    dir<=1;
  end
  else begin 
    cha<=((dest-locat)<<7)*3;
    dir<=0;
  end
end
  
    if(!back)begin
      backn<=0;
      biao<=1;
    end

    if(backn==0&&biao==1&&en)begin
      dir<=1;
      pwm_out_fre = pwm_tmp&en;
    end else if(en==0) begin
      backn<=1;
      locat<=32'h00000000;
      
    end
    
    if (biao==0&&cha<32'h80000000&&backn==1) begin
        cha<=cha-32'h00000001;
        pwm_out_fre = pwm_tmp;
    end else if(biao==0&&cha>=32'h80000000) begin
       biao<=1; 
       locat<=dest;
    end
end


endmodule









