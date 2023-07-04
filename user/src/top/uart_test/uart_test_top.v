module uart_test_top(
        input clk50,
        input rst_n,
        output tx
    );

    wire [7:0] data;
    wire wrsig;
    wire clk;

    clkdiv
        clkdiv_dut (
            .clk50 (clk50 ),
            .rst_n (rst_n ),
            .clkout  ( clk)
        );

    uart_test_data
        uart_test_data_dut (
            .clk (clk ),
            .rst_n (rst_n ),
            .dataout (data ),
            .wrsig  ( wrsig)
        );

    uarttx
        uarttx_dut (
            .clk (clk ),
            .rst_n (rst_n ),
            .datain (data ),
            .wrsig (wrsig ),
            .idle ( ),
            .tx  ( tx)
        );


endmodule
