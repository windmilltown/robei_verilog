`timescale 1ns/1ps
module rgb_yuv_tb;

    // Parameters

    // Ports
    reg [15:0] rgb_in;
    wire [7:0] y_out;

    rgb_yuv
        rgb_yuv_dut (
            .rgb_in (rgb_in ),
            .y_out  ( y_out)
        );

    initial begin
        begin
            $dumpfile("rgb_yuv_tb.vcd");
            $dumpvars(0,rgb_yuv_tb);
            rgb_in = 16'b10000_110000_10000;
            #100
             $finish;
        end
    end

endmodule
