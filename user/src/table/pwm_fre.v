//滑台顶层
//`include "set_fre.v"
//`include "push_pwm_fre.v"

module pwm_fre(
  input clk,//杈撳叆鏃堕挓50MHz
  input start,
  input en,
  input back,
  input [31:0]dest,
  //input [19:0] fre_need,
  //input [19: 0] fre_gap,
  output  reg pwm_out_fre,
  output reg dir
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









