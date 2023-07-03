



//涓枃16*16 鏁板瓧鍜屽瓧姣*16
module OLED_FontData(
	
	input			sys_clk,
	input			rst_n,
	
	input			font_row,
	input[5:0]	font_sel,
	input[8:0]	index,
	
	output reg[7:0]	 data
);


reg[7:0] data0[15:0];   //F
reg[7:0] data1[15:0];   //G
reg[7:0] data2[31:0];   //戴
reg[7:0] data3[31:0];   //车
reg[7:0] data4[31:0];   //飞
reg[7:0] data5[31:0];   //队

reg[7:0] data6[31:0];   //娓
reg[7:0] data7[31:0];   //搴
reg[7:0] data8[31:0];   //婀
reg[7:0] data9[31:0];   //搴
reg[7:0] data10[15:0];   //.
reg[7:0] data11[31:0];   //鈩
reg[7:0] data12[15:0];   //R
reg[7:0] data13[15:0];   //H

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 'd0)
		data <= 'd0;
	else if(font_sel == 'd0)
		data <= data0[index + 'd8 * font_row];
	else if(font_sel == 'd1)
		data <= data1[index + 'd8 * font_row];
	else if(font_sel == 'd2)
		data <= data2[index + 'd16 * font_row];
	else if(font_sel == 'd3)
		data <= data3[index + 'd16 * font_row];
	else if(font_sel == 'd4)
		data <= data4[index + 'd16 * font_row];
	else if(font_sel == 'd5)
		data <= data5[index + 'd16 * font_row];
	else if(font_sel == 'd6)
		data <= data6[index + 'd16 * font_row];
	else if(font_sel == 'd7)
		data <= data7[index + 'd16 * font_row];
	else if(font_sel == 'd8)
		data <= data8[index + 'd16 * font_row];
	else if(font_sel == 'd9)
		data <= data9[index + 'd16 * font_row];
	else if(font_sel == 'd10)
		data <= data10[index + 'd8 * font_row];
	else if(font_sel == 'd11)
		data <= data11[index + 'd16 * font_row];
	else if(font_sel == 'd12)
		data <= data12[index + 'd8 * font_row];
	else if(font_sel == 'd13)
		data <= data13[index + 'd8 * font_row];
	else if(font_sel == 'd14)
		data <= data10[index + 'd8 * font_row];
	else
		data <= data;
end

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data0[0]  = 8'h00;
		data0[1]  = 8'h00;
		data0[2]  = 8'h00;
		data0[3]  = 8'h00;
		data0[4]  = 8'h00;
		data0[5]  = 8'h00;
		data0[6]  = 8'h00;
		data0[7]  = 8'h00;
		data0[8]  = 8'h00;
		data0[9]  = 8'h00;
		data0[10] = 8'h00;
		data0[11] = 8'h00;
		data0[12] = 8'h00;
		data0[13] = 8'h00;
		data0[14] = 8'h00;
		data0[15] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data1[0]  = 8'h00;
		data1[1]  = 8'h00;
		data1[2]  = 8'h00;
		data1[3]  = 8'h00;
		data1[4]  = 8'h00;
		data1[5]  = 8'h00;
		data1[6]  = 8'h00;
		data1[7]  = 8'h00;
		data1[8]  = 8'h00;
		data1[9]  = 8'h00;
		data1[10] = 8'h00;
		data1[11] = 8'h00;
		data1[12] = 8'h00;
		data1[13] = 8'h00;
		data1[14] = 8'h00;
		data1[15] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data2[0]  = 8'h08;
		data2[1]  = 8'hEA;
		data2[2]  = 8'hAA;
		data2[3]  = 8'hAA;
		data2[4]  = 8'hEF;
		data2[5]  = 8'hAA;
		data2[6]  = 8'hAA;
		data2[7]  = 8'hEA;
		data2[8]  = 8'h08;
		data2[9]  = 8'h08;
		data2[10] = 8'hFF;
		data2[11] = 8'h08;
		data2[12] = 8'h0A;
		data2[13] = 8'hCC;
		data2[14] = 8'h08;
		data2[15] = 8'h00;
		data2[16] = 8'h20;
		data2[17] = 8'hAB;
		data2[18] = 8'h7E;
		data2[19] = 8'h2A;
		data2[20] = 8'h2B;
		data2[21] = 8'h2A;
		data2[22] = 8'h7E;
		data2[23] = 8'hAB;
		data2[24] = 8'hA0;
		data2[25] = 8'h40;
		data2[26] = 8'h27;
		data2[27] = 8'h18;
		data2[28] = 8'h26;
		data2[29] = 8'h41;
		data2[30] = 8'hF0;
		data2[31] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data3[0]  = 8'h00;
		data3[1]  = 8'h08;
		data3[2]  = 8'h88;
		data3[3]  = 8'h48;
		data3[4]  = 8'h28;
		data3[5]  = 8'h18;
		data3[6]  = 8'h0F;
		data3[7]  = 8'hE8;
		data3[8]  = 8'h08;
		data3[9]  = 8'h08;
		data3[10] = 8'h08;
		data3[11] = 8'h08;
		data3[12] = 8'h08;
		data3[13] = 8'h08;
		data3[14] = 8'h00;
		data3[15] = 8'h00;
		data3[16] = 8'h08;
		data3[17] = 8'h08;
		data3[18] = 8'h09;
		data3[19] = 8'h09;
		data3[20] = 8'h09;
		data3[21] = 8'h09;
		data3[22] = 8'h09;
		data3[23] = 8'hFF;
		data3[24] = 8'h09;
		data3[25] = 8'h09;
		data3[26] = 8'h09;
		data3[27] = 8'h09;
		data3[28] = 8'h09;
		data3[29] = 8'h08;
		data3[30] = 8'h08;
		data3[31] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data4[0]  = 8'h02;
		data4[1]  = 8'h02;
		data4[2]  = 8'h02;
		data4[3]  = 8'h02;
		data4[4]  = 8'h02;
		data4[5]  = 8'h02;
		data4[6]  = 8'h02;
		data4[7]  = 8'h02;
		data4[8]  = 8'h02;
		data4[9]  = 8'hFE;
		data4[10] = 8'h40;
		data4[11] = 8'hA0;
		data4[12] = 8'h10;
		data4[13] = 8'h08;
		data4[14] = 8'h00;
		data4[15] = 8'h00;
		data4[16] = 8'h00;
		data4[17] = 8'h00;
		data4[18] = 8'h00;
		data4[19] = 8'h00;
		data4[20] = 8'h00;
		data4[21] = 8'h00;
		data4[22] = 8'h00;
		data4[23] = 8'h00;
		data4[24] = 8'h00;
		data4[25] = 8'h03;
		data4[26] = 8'h0C;
		data4[27] = 8'h10;
		data4[28] = 8'h21;
		data4[29] = 8'h42;
		data4[30] = 8'hF0;
		data4[31] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data5[0]  = 8'h00;
		data5[1]  = 8'hFE;
		data5[2]  = 8'h02;
		data5[3]  = 8'h22;
		data5[4]  = 8'hDA;
		data5[5]  = 8'h06;
		data5[6]  = 8'h00;
		data5[7]  = 8'h00;
		data5[8]  = 8'h00;
		data5[9]  = 8'hFF;
		data5[10] = 8'h00;
		data5[11] = 8'h00;
		data5[12] = 8'h00;
		data5[13] = 8'h00;
		data5[14] = 8'h00;
		data5[15] = 8'h00;
		data5[16] = 8'h00;
		data5[17] = 8'hFF;
		data5[18] = 8'h08;
		data5[19] = 8'h10;
		data5[20] = 8'h88;
		data5[21] = 8'h47;
		data5[22] = 8'h20;
		data5[23] = 8'h18;
		data5[24] = 8'h07;
		data5[25] = 8'h00;
		data5[26] = 8'h07;
		data5[27] = 8'h18;
		data5[28] = 8'h20;
		data5[29] = 8'h40;
		data5[30] = 8'h80;
		data5[31] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data6[0] = 8'h10;
		data6[1] = 8'h60;
		data6[2] = 8'h02;
		data6[3] = 8'h8C;
		data6[4] = 8'h00;
		data6[5] = 8'h00;
		data6[6] = 8'hFE;
		data6[7] = 8'h92;
		data6[8] = 8'h92;
		data6[9] = 8'h92;
		data6[10] = 8'h92;
		data6[11] = 8'h92;
		data6[12] = 8'hFE;
		data6[13] = 8'h00;
		data6[14] = 8'h00;
		data6[15] = 8'h00;
		data6[16] = 8'h04;
		data6[17] = 8'h04;
		data6[18] = 8'h7E;
		data6[19] = 8'h01;
		data6[20] = 8'h40;
		data6[21] = 8'h7E;
		data6[22] = 8'h42;
		data6[23] = 8'h42;
		data6[24] = 8'h7E;
		data6[25] = 8'h42;
		data6[26] = 8'h7E;
		data6[27] = 8'h42;
		data6[28] = 8'h42;
		data6[29] = 8'h7E;
		data6[30] = 8'h40;
		data6[31] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data7[0] = 8'h00;
		data7[1] = 8'h00;
		data7[2] = 8'hFC;
		data7[3] = 8'h24;
		data7[4] = 8'h24;
		data7[5] = 8'h24;
		data7[6] = 8'hFC;
		data7[7] = 8'h25;
		data7[8] = 8'h26;
		data7[9] = 8'h24;
		data7[10] = 8'hFC;
		data7[11] = 8'h24;
		data7[12] = 8'h24;
		data7[13] = 8'h24;
		data7[14] = 8'h04;
		data7[15] = 8'h00;
		data7[16] = 8'h40;
		data7[17] = 8'h30;
		data7[18] = 8'h8F;
		data7[19] = 8'h80;
		data7[20] = 8'h84;
		data7[21] = 8'h4C;
		data7[22] = 8'h55;
		data7[23] = 8'h25;
		data7[24] = 8'h25;
		data7[25] = 8'h25;
		data7[26] = 8'h55;
		data7[27] = 8'h4C;
		data7[28] = 8'h80;
		data7[29] = 8'h80;
		data7[30] = 8'h80;
		data7[31] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data8[0] = 8'h10;
		data8[1] = 8'h60;
		data8[2] = 8'h02;
		data8[3] = 8'h8C;
		data8[4] = 8'h00;
		data8[5] = 8'hFE;
		data8[6] = 8'h92;
		data8[7] = 8'h92;
		data8[8] = 8'h92;
		data8[9] = 8'h92;
		data8[10] = 8'h92;
		data8[11] = 8'h92;
		data8[12] = 8'hFE;
		data8[13] = 8'h00;
		data8[14] = 8'h00;
		data8[15] = 8'h00;
		data8[16] = 8'h04;
		data8[17] = 8'h04;
		data8[18] = 8'h7E;
		data8[19] = 8'h01;
		data8[20] = 8'h44;
		data8[21] = 8'h48;
		data8[22] = 8'h50;
		data8[23] = 8'h7F;
		data8[24] = 8'h40;
		data8[25] = 8'h40;
		data8[26] = 8'h7F;
		data8[27] = 8'h50;
		data8[28] = 8'h48;
		data8[29] = 8'h44;
		data8[30] = 8'h40;
		data8[31] = 8'h00;
	end


end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data9[0] = 8'h00;
		data9[1] = 8'h00;
		data9[2] = 8'hFC;
		data9[3] = 8'h24;
		data9[4] = 8'h24;
		data9[5] = 8'h24;
		data9[6] = 8'hFC;
		data9[7] = 8'h25;
		data9[8] = 8'h26;
		data9[9] = 8'h24;
		data9[10] = 8'hFC;
		data9[11] = 8'h24;
		data9[12] = 8'h24;
		data9[13] = 8'h24;
		data9[14] = 8'h04;
		data9[15] = 8'h00;
		data9[16] = 8'h40;
		data9[17] = 8'h30;
		data9[18] = 8'h8F;
		data9[19] = 8'h80;
		data9[20] = 8'h84;
		data9[21] = 8'h4C;
		data9[22] = 8'h55;
		data9[23] = 8'h25;
		data9[24] = 8'h25;
		data9[25] = 8'h25;
		data9[26] = 8'h55;
		data9[27] = 8'h4C;
		data9[28] = 8'h80;
		data9[29] = 8'h80;
		data9[30] = 8'h80;
		data9[31] = 8'h00;
	end


end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data10[0] = 8'h00;
		data10[1] = 8'h00;
		data10[2] = 8'h00;
		data10[3] = 8'h00;
		data10[4] = 8'h00;
		data10[5] = 8'h00;
		data10[6] = 8'h00;
		data10[7] = 8'h00;
		data10[8] = 8'h00;
		data10[9] = 8'h30;
		data10[10] = 8'h30;
		data10[11] = 8'h00;
		data10[12] = 8'h00;
		data10[13] = 8'h00;
		data10[14] = 8'h00;
		data10[15] = 8'h00;
	end


end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data11[0] = 8'h06;
		data11[1] = 8'h09;
		data11[2] = 8'h09;
		data11[3] = 8'hE6;
		data11[4] = 8'hF8;
		data11[5] = 8'h0C;
		data11[6] = 8'h04;
		data11[7] = 8'h02;
		data11[8] = 8'h02;
		data11[9] = 8'h02;
		data11[10] = 8'h02;
		data11[11] = 8'h02;
		data11[12] = 8'h04;
		data11[13] = 8'h1E;
		data11[14] = 8'h00;
		data11[15] = 8'h00;
		data11[16] = 8'h00;
		data11[17] = 8'h00;
		data11[18] = 8'h00;
		data11[19] = 8'h07;
		data11[20] = 8'h1F;
		data11[21] = 8'h30;
		data11[22] = 8'h20;
		data11[23] = 8'h40;
		data11[24] = 8'h40;
		data11[25] = 8'h40;
		data11[26] = 8'h40;
		data11[27] = 8'h40;
		data11[28] = 8'h20;
		data11[29] = 8'h10;
		data11[30] = 8'h00;
		data11[31] = 8'h00;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data12[0] = 8'h08;
		data12[1] = 8'hF8;
		data12[2] = 8'h88;
		data12[3] = 8'h88;
		data12[4] = 8'h88;
		data12[5] = 8'h88;
		data12[6] = 8'h70;
		data12[7] = 8'h00;
		data12[8] = 8'h20;
		data12[9] = 8'h3F;
		data12[10] = 8'h20;
		data12[11] = 8'h00;
		data12[12] = 8'h03;
		data12[13] = 8'h0C;
		data12[14] = 8'h30;
		data12[15] = 8'h20;
	end


end
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data13[0] = 8'h08;
		data13[1] = 8'hF8;
		data13[2] = 8'h08;
		data13[3] = 8'h00;
		data13[4] = 8'h00;
		data13[5] = 8'h08;
		data13[6] = 8'hF8;
		data13[7] = 8'h08;
		data13[8] = 8'h20;
		data13[9] = 8'h3F;
		data13[10] = 8'h21;
		data13[11] = 8'h01;
		data13[12] = 8'h01;
		data13[13] = 8'h21;
		data13[14] = 8'h3F;
		data13[15] = 8'h20;
	end

end

endmodule 