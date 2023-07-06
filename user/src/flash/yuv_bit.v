module yuv_bit(
        input [7:0] y,
        output b
    );
    assign b=(y>=8'd128)? 1'b0:1'b1;
endmodule
