module uart_rx_test(
        input clk50,
        input rst_n,
        input rx,
        output tx
    );

    wire clk;
    wire send;
    wire [7:0] data;

    clkdiv 
    clkdiv_dut (
      .clk50 (clk50 ),
      .rst_n (rst_n ),
      .clkout  ( clk)
    );

    uartrx 
    uartrx_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .rx (rx ),
      .dataout (data ),
      .rdsig (send ),
      .dataerror ( ),
      .frameerror  ( )
    );
  
    uarttx 
    uarttx_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .datain (data ),
      .wrsig (send ),
      .idle ( ),
      .tx  ( tx)
    );
  
endmodule