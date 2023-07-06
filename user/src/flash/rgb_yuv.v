//rgb转yuv模块(仅有y分量)
module rgb_yuv(
        input [15:0] rgb_in,
        output [7:0] y_out
    );


    wire [15:0] R;
    wire [15:0] G;
    wire [15:0] B;
    wire [15:0] R_p;
    wire [15:0] G_p;
    wire [15:0] B_p;
    wire [15:0] sum;

    assign R = {11'b0,rgb_in[15:11]};
    assign G = {10'b0,rgb_in[10:5]};
    assign B = {11'b0,rgb_in[4:0]};

    assign R_p=((R<<6)+(R<<1));
    assign G_p=((G<<7)+G);
    assign B_p=((B<<4)+(B<<3)+B);
    assign sum = R_p + G_p + B_p;
    assign y_out = 8'd16 + (sum>>8);
endmodule
