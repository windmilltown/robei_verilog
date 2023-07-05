module uart_top_test(
        input clk50,
        input rst_n,
        input rx,
        output tx
    );

    uart_top 
    uart_top_dut (
      .clk50 (clk50 ),
      .rst_n (rst_n ),
      .rx (rx ),
      .clr ( ),
      .tx (tx ),
      .x ( ),
      .y ( ),
      .z ( ),
      .valid  ( )
    );
  
endmodule