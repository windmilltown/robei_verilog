//占空比输入缓冲器
//输入：时钟clk 50MHz，高电平持续时间fre_need[19:0]（50_000代表1ms）（上限1_000_000即20ms），
//      fre_out加160的间隔时钟沿次数fre_gap[9:0]（1000代表转180度用2秒）
//输出：fre_out[19:0] 随时间逐渐变化到need值的高电平持续时间
//功能：根据给定的fre_need输出逐渐变化到需求值的fre_out
module set_fre(
    input clk,//输入时钟50MHz
    input [19:0] fre_need,
    input [19:0] fre_gap,
    output reg [19:0] fre_out
  );

  initial
  begin
    fre_out=0;
  end

  reg [9:0] count=0;

  always @(negedge clk)
  begin
    if(fre_out<fre_need)
    begin
      count<=count+1;
      if(count==fre_gap-1)
      begin
        count<=0;
        fre_out<=fre_out+160;
      end
    end
    else if (fre_out>fre_need)
    begin
      count<=count+1;
      if(count==fre_gap-1)
      begin
        count<=0;
        fre_out<=fre_out-160;
      end
    end
  end
endmodule

