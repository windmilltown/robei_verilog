//pwm娉㈡ā鍧
//杈撳叆锛氭椂閽焎lk 50MHz锛岄渶瑕佺殑楂樼數骞虫椂闀縡re_need[19:0]锛0_000浠ｈ〃1ms锛夛紙涓婇檺1_000_000鍗0ms锛夛紝
// 聽 聽 聽fre_out鍔犱竴鐨勯棿闅旀椂閽熸部娆℃暟fre_gap[9:0]锛000浠ｈ〃杞80搴︾敤2绉掞級
//杈撳嚭锛氶€愭笎鍙樺寲鍒伴渶姹傜殑楂樼數骞虫椂闀跨殑pwm娉wm_out
//鍔熻兘锛氭牴鎹粰瀹氱殑fre_need杈撳嚭閫愭笎鍙樺寲鍒伴渶姹傚€肩殑pwm娉

//`include "set_fre.v"
//`include "push_pwm_fre.v"

module pwm_fre(
    input clk,//杈撳叆鏃堕挓50MHz
    input en,
	 input direction,
    //input [19:0] fre_need,
    //input [19:0] fre_gap,
    output pwm_out_fre,
	 output dir
  );
 // wire [19:0] fre;
  wire pwm_tmp;
//parameter [19:0] fre_gap=500_000;
 // parameter [19:0] fre_gap=100;
  
reg [31:0] count=0;
  //reg [19:0] fre_need_reg=0;
 // wire[19:0] fre_need;


 // set_fre my_set_fre(
    //        .clk(clk),
     //       .fre_need(fre_need),
     //       .fre_gap(fre_gap),
      //      .fre_out(fre)
      //    );

  push_pwm_fre push_pwm_fre(
             .clk(clk),
             .fre(20'd6800),
				 //.fre(fre),
             .pwm_wave_fre(pwm_tmp)
           );

         //  assign fre_need = fre_need_reg;
	assign dir = direction;
	assign pwm_out_fre = pwm_tmp & en;

			
		
		
		
		

              /* begin

                   count<=count+1;
                   if(count==0)
                   begin
                    fre_need_reg<=1600;
             
            
                   end
                   else if(count==199_999_999)
                   begin
                    fre_need_reg<=0;
                
                   end
                   
               end*/
           
         

endmodule


