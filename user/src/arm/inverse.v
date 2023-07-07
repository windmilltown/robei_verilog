//逆运动学求解舵机角度
//输入：距机械臂水平距离x（mm）,距底盘垂直距离y（mm）
//输出：舵机1角度xita1，舵机2角度xita2
//功能：根据输入的x，y坐标，计算出舵机1和舵机2的角度
/*`include "../basic/qadd/qadd.v"
`include "../basic/qmulti/qmulti.v"
`include "../basic/qdiv/qdiv.v"
`include "../basic/sqrt/sqrt.v"
`include "../basic/arcsin/arcsin.v"
`include "../basic/arctan/arctan.v"
`include "../basic/arctan/xita_tan_lut.v"
`include "../basic/cos/cos.v"
`include "../basic/tan/tan.v"*/

module inverse(
    input clk,
    input rst_n,
    output reg valid,
    input [31:0] x,
    input [31:0] y,
    output reg [31:0] xita1,//下面舵机角度
    output reg [31:0] xita2 //上面舵机角度
);

    parameter [31:0] L1 = 32'h0007_6666;//单位是cm,7.4cm
    parameter [31:0] L2 = 32'h0012_0000;//18cm
    parameter [31:0] h = 32'h0005_3333;//5.2cm

    reg [31:0] x_reg;
    reg [31:0] y_reg;

    wire [31:0] k_mol;
    wire [31:0] k_den;
    wire [31:0] k;
    wire [31:0] x_2;
    wire [31:0] y_2;
    wire [31:0] x_2_add_y_2;
    wire [31:0] L1_2;
    wire [31:0] L2_2;
    wire [31:0] L1_2_red_L2_2;
    wire valid_k;

    reg valid_k_prev;
    reg valid1;
    reg valid2;

    qadd 
    qadd_dut00 (
      .add1 (L1 ),
      .add2 (L1 ),
      .sum  ( k_den)
    );
    qadd 
    qadd_dut01 (
      .add1 (x_2 ),
      .add2 (y_2 ),
      .sum  ( x_2_add_y_2)
    );
    qadd 
    qadd_dut02 (
      .add1 (L1_2 ),
      .add2 ({1'b1,L2_2[30:0]} ),
      .sum  ( L1_2_red_L2_2)
    );
    qadd 
    qadd_dut03 (
      .add1 (x_2_add_y_2 ),
      .add2 (L1_2_red_L2_2 ),
      .sum  ( k_mol)
    );
  
    qmulti 
    qmulti_dut00 (
      .multi1 (x_reg ),
      .multi2 (x_reg ),
      .result  ( x_2)
    );
    qmulti 
    qmulti_dut01 (
      .multi1 (y_reg ),
      .multi2 (y_reg ),
      .result  ( y_2)
    ); 
    qmulti 
    qmulti_dut02 (
      .multi1 (L1 ),
      .multi2 (L1 ),
      .result  ( L1_2)
    );
    qmulti 
    qmulti_dut03 (
      .multi1 (L2 ),
      .multi2 (L2 ),
      .result  ( L2_2)
    );

    qdiv 
    qdiv_dut00 (
      .clk (clk ),
      .rst_n (rst_n ),
      .dividend (k_mol ),
      .divisor (k_den ),
      .quotient (k ),
      .valid (valid_k ),
      .warn ( ),
      .busy  ( )
    );
  

    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] c;
    wire [31:0] k_p2_ne;
    wire [31:0] k_2;
    wire [31:0] x_2_red_c;
    wire [31:0] b_2;
    wire [31:0] a_c;
    wire [31:0] a_c_4;

    assign a=x_2_add_y_2;

    qadd 
    qadd_dut10 (
      .add1 ({~k[31],k[30:0]} ),
      .add2 ({~k[31],k[30:0]} ),
      .sum  ( k_p2_ne)
    );  
    qadd 
    qadd_dut11 (
      .add1 (k_2 ),
      .add2 ({1'b1,y_2[30:0]} ),
      .sum  ( c)
    );
    qadd 
    qadd_dut12 (
      .add1 (x_2 ),
      .add2 ({~c[31],c[30:0]} ),
      .sum  ( x_2_red_c)
    );
    
    qmulti 
    qmulti_dut10 (
      .multi1 (k_p2_ne ),
      .multi2 (x_reg ),
      .result  ( b)
    );
    qmulti 
    qmulti_dut11 (
      .multi1 (k ),
      .multi2 (k ),
      .result  ( k_2)
    );
    qmulti 
    qmulti_dut12 (
      .multi1 (b ),
      .multi2 (b ),
      .result  ( b_2)
    );
    qmulti 
    qmulti_dut13 (
      .multi1 (a ),
      .multi2 (c ),
      .result  ( a_c)
    );
    qmulti 
    qmulti_dut14 (
      .multi1 (a_c ),
      .multi2 (32'h0004_0000 ),
      .result  ( a_c_4)
    );

    wire [31:0] x_2_red_c_sqrt;
    wire [31:0] delta_sqrt;
    wire [31:0] sin_mol;
    wire [31:0] sin_den;
    wire [31:0] sin;
    wire valid_sqrt;
    wire valid_div;
    wire [31:0] y_p2;

    reg [31:0] x_2_red_c_reg;
    reg [31:0] sin_mol_reg;
    reg valid_sqrt_prev;
    reg valid_div_prev;
    reg [31:0] sin_den_reg;

    qadd 
    qadd_dut20 (
      .add1 ({~b[31],b[30:0]} ),
      .add2 ({~delta_sqrt[31],delta_sqrt[30:0]} ),
      .sum  ( sin_mol)
    );  
    qadd 
    qadd_dut21 (
      .add1 (a ),
      .add2 (a ),
      .sum  ( sin_den)
    );  
    qadd
    qadd_dut22 (
      .add1 (y_reg ),
      .add2 (y_reg ),
      .sum  ( y_p2)
    );

    qmulti
    qmulti_dut20 (
      .multi1 (x_2_red_c_sqrt ),
      .multi2 (y_p2 ),
      .result  ( delta_sqrt)
    );

    sqrt 
    sqrt_dut20 (
      .clk (clk ),
      .rst_n (rst_n ),
      .valid (valid_sqrt ),
      .sqrter (x_2_red_c_reg ),
      .sqrted  ( x_2_red_c_sqrt)
    );
  
    qdiv 
    qdiv_dut20 (
      .clk (clk ),
      .rst_n (rst_n ),
      .dividend (sin_mol_reg ),
      .divisor (sin_den_reg ),
      .quotient (sin ),
      .valid (valid_div ),
      .warn ( ),
      .busy  ( )
    );
  

    wire [31:0] xita1_sharp;
    wire valid_arcsin;

    reg [31:0] sin_reg;
    reg valid_arcsin_prev;

    arcsin 
    arcsin_dut20 (
      .clk (clk ),
      .rst_n (rst_n ),
      .valid (valid_arcsin ),
      .value_sin (sin_reg ),
      .xita  ( xita1_sharp)
    );


    wire [31:0] L2_p2;
    wire [31:0] L2_2_red_L1_2;
    wire [31:0] r_mol;
    wire [31:0] r;
    wire valid_k_r;

    reg valid_k_r_prev;

    qadd
    qadd_dut30 (
      .add1 (L2 ),
      .add2 (L2 ),
      .sum  ( L2_p2)
    );
    qadd
    qadd_dut31 (
      .add1 (L2_2 ),
      .add2 ({~L1_2[31],L1_2[30:0]} ),
      .sum  ( L2_2_red_L1_2)
    );
    qadd
    qadd_dut32 (
      .add1 (L2_2_red_L1_2 ),
      .add2 (x_2_add_y_2 ),
      .sum  ( r_mol)
    );

    qdiv
    qdiv_dut30 (
      .clk (clk ),
      .rst_n (rst_n ),
      .dividend (r_mol ),
      .divisor (L2_p2 ),
      .quotient (r ),
      .valid ( valid_k_r),
      .warn ( ),
      .busy  ( )
    );
  

    wire [31:0] b_r;
    wire [31:0] c_r;
    wire [31:0] r_p2_ne;
    wire [31:0] r_2;
    wire [31:0] x_2_red_c_r;
    wire [31:0] b_r_2;
    wire [31:0] a_c_r;
    wire [31:0] a_c_r_p4;

    qadd
    qadd_dut40 (
      .add1 ({~r[31],r[30:0]} ),
      .add2 ({~r[31],r[30:0]} ),
      .sum  ( r_p2_ne)
    );
    qadd
    qadd_dut41 (
      .add1 (r_2 ),
      .add2 ({~y_2[31],y_2[30:0]} ),
      .sum  ( c_r)
    );
    qadd
    qadd_dut42 (
      .add1 (x_2 ),
      .add2 ({~c_r[31],c_r[30:0]} ),
      .sum  ( x_2_red_c_r)
    );

    qmulti
    qmulti_dut40 (
      .multi1 (r_p2_ne ),
      .multi2 (x_reg ),
      .result  ( b_r)
    );
    qmulti
    qmulti_dut41 (
      .multi1 (r ),
      .multi2 (r ),
      .result  ( r_2)
    );
    qmulti
    qmulti_dut42 (
      .multi1 (b_r ),
      .multi2 (b_r ),
      .result  ( b_r_2)
    );
    qmulti
    qmulti_dut43 (
      .multi1 (a ),
      .multi2 (c_r ),
      .result  ( a_c_r)
    );
    qmulti
    qmulti_dut44 (
      .multi1 (a_c_r ),
      .multi2 (32'h0004_0000 ),
      .result  ( a_c_r_p4)
    );


    wire [31:0] delta_sqrt_r;
    wire valid_sqrt_r;
    wire [31:0] x_2_red_c_sqrt_r;

    reg [31:0] x_2_red_c_r_reg;
    reg valid_sqrt_r_prev;
    
    qmulti
    qmulti_dut50 (
      .multi1 (y_p2 ),
      .multi2 (x_2_red_c_sqrt_r ),
      .result  ( delta_sqrt_r)
    );

    sqrt
    sqrt_dut50 (
      .clk (clk ),
      .rst_n (rst_n ),
      .valid (valid_sqrt_r ),
      .sqrter (x_2_red_c_r_reg ),
      .sqrted  ( x_2_red_c_sqrt_r)
    );

    wire [31:0] sin_r_mol;
    wire [31:0] sin_r;
    wire valid_div_r;

    reg [31:0] sin_r_mol_reg;
    reg [31:0] sin_r_den_reg;
    reg valid_div_r_prev;

    qadd
    qadd_dut60 (
      .add1 ({~b_r[31],b_r[30:0]} ),
      .add2 ({delta_sqrt_r[31],delta_sqrt_r[30:0]} ),
      .sum  ( sin_r_mol)
    );

    qdiv
    qdiv_dut60 (
      .clk (clk ),
      .rst_n (rst_n ),
      .dividend (sin_r_mol_reg ),
      .divisor (sin_r_den_reg ),
      .quotient (sin_r ),
      .valid ( valid_div_r),
      .warn ( ),
      .busy  ( )
    );

    wire valid_arcsin_r;
    wire [31:0] xita1_add_xita2;
    wire [31:0] xita2_sharp;
    wire [31:0] xita1_add_xita2_true;
    wire done;

    reg [31:0] sin_r_reg;
    reg valid_arcsin_r_prev;
    reg done_prev;

    assign xita1_add_xita2_true=(r>x)? xita1_add_xita2 : 32'h00B4_0000-xita1_add_xita2;
    assign done=valid1 && valid2;

    qadd
    qadd_dut70 (
      .add1 (xita1_add_xita2_true ),
      .add2 ({~xita1_sharp[31],xita1_sharp[30:0]} ),
      .sum  ( xita2_sharp)
    );

    arcsin
    arcsin_dut70 (
      .clk (clk ),
      .rst_n (rst_n ),
      .valid (valid_arcsin_r ),
      .value_sin (sin_r_reg ),
      .xita ( xita1_add_xita2)
    );

    always @(posedge clk or negedge rst_n) 
    begin
      if(!rst_n)
      begin
        valid1<=1'b0;
        valid2<=1'b0;
        x_reg<=x;
        y_reg<=y;
        x_2_red_c_reg<=0;
        sin_mol_reg<=0;
        sin_reg<=0;
        valid_k_prev<=0;
        sin_mol_reg<=0;
        valid_sqrt_prev<=0;
        valid_div_prev<=0;
        sin_den_reg<=0;
        valid_arcsin_prev<=0;
        sin_r_mol_reg<=0;
        sin_r_den_reg<=0;
        valid_div_r_prev<=0;
        sin_r_reg<=0;
        valid_arcsin_r_prev<=0;
        valid<=0;
        done_prev<=0;
      end
      else
      begin
        valid_arcsin_prev<=valid_arcsin;
        valid_sqrt_prev<=valid_sqrt;
        valid_div_prev<=valid_div;
        valid_k_prev<=valid_k;

        valid_k_r_prev<=valid_k_r;
        valid_sqrt_r_prev<=valid_sqrt_r;
        valid_div_r_prev<=valid_div_r;
        valid_arcsin_r_prev<=valid_arcsin_r;

        done_prev<=done;

        x_reg<=x;
        y_reg<=y;
        if(x_reg!=x || y_reg!=y)
        begin
          valid1<=1'b0;
          valid2<=1'b0;
          valid<=1'b0;
        end
        else
        begin
          if(valid_k_prev==1'b0 && valid_k==1'b1)
          begin
            x_2_red_c_reg<=x_2_red_c;
          end
          if(valid_sqrt_prev==1'b0 && valid_sqrt==1'b1)
          begin
            sin_mol_reg<=sin_mol;
            sin_den_reg<=sin_den;
          end
          if(valid_div_prev==1'b0 && valid_div==1'b1)
          begin
            sin_reg<=sin;
          end
          if(valid_arcsin_prev==1'b0 && valid_arcsin==1'b1)
          begin
            valid1<=1'b1;
            xita1<=xita1_sharp;
          end

          if(valid_k_r_prev==1'b0 && valid_k_r==1'b1)
          begin
            x_2_red_c_r_reg<=x_2_red_c_r;
          end
          if(valid_sqrt_r_prev==1'b0 && valid_sqrt_r==1'b1)
          begin
            sin_r_mol_reg<=sin_r_mol;
            sin_r_den_reg<=sin_den;
          end
          if(valid_div_r_prev==1'b0 && valid_div_r==1'b1)
          begin
            sin_r_reg<=sin_r;
          end
          if(valid_arcsin_r_prev==1'b0 && valid_arcsin_r==1'b1)
          begin
            valid2<=1'b1;
          end

          if(done_prev==1'b0 && done==1'b1)
          begin
            valid<=1'b1;
            xita2<=xita2_sharp;
          end
        end
      end
    end
endmodule