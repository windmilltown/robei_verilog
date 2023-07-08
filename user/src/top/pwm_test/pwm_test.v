module pwm_test(
        input clk,
        input rst_n,
        output pwm
    );

    reg [19:0] duty_need;
    reg [31:0] cnt;
    
    parameter [11:0] duty_gap=1000;

    pwm 
    pwm_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .duty_need (duty_need ),
      .duty_gap (duty_gap ),
      .pwm_out  ( pwm)
    );

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            duty_need<=0;
            cnt<=0;
        end
        else begin
            if(cnt==0) begin
                duty_need<=100_000;
                cnt<=cnt+1;
            end
            else if(cnt==50_000_000) begin
                duty_need<=50_000;
                cnt<=cnt+1;
            end
            else if(cnt==100_000_000) begin
                duty_need<=150_000;
                cnt<=cnt+1;
            end
            else if(cnt>=150_000_000) begin
                cnt<=0;
            end
            else begin
                cnt<=cnt+1;
            end
        end
    end
  
endmodule