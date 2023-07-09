module OLED_sensor(
	
	input			sys_clk,
	input			rst_n,
	
	inout			dht11,
	
	output		OLED_SCL,
	inout			OLED_SDA

);

wire dht11_done;
reg  dht11_req;
wire[7:0]  tempH;
wire[7:0]  tempL;	
wire[7:0]  humidityH;
wire[7:0]  humidityL;

localparam S_DELAY	=	'd55_000_000;
reg[35:0]	delay;

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		delay <= 'd0;
	else if(dht11_done == 1'b1)
		delay <= 'd0;
	else if(delay == S_DELAY)
		delay <= delay;
	else 
		delay <= delay + 1'b1;
end

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)	
		dht11_req <= 1'b0;
	else if(delay == S_DELAY)
		dht11_req <= 1'b1;
	else
		dht11_req <= 1'b0;


end

DHT11 DHT11HP(

	.sys_clk			(sys_clk),
	.rst_n			(rst_n),
	
	.dht11_req		(dht11_req),   //dht11数据采集请求
	.dht11_done		(dht11_done),	 //dht11数据采集结束
	.dht11_error	(), //dht11数据采集正确与否判断   1为错误
	
	.tempH			(tempH),			//温度数据整数
	.tempL			(tempL),			//温度数据小数
	.humidityH		(humidityH),		//温度数据整数
	.humidityL		(humidityL),		//温度数据小数
	
	
	.dht11			(dht11)
);



OLED_Top OLED_TopHP(

	.sys_clk		(sys_clk),
	.rst_n		(rst_n),
	
	.dht11_done		(dht11_done),
	.tempH			(tempH),			//温度数据整数
	.tempL			(tempL),			//温度数据小数
	.humidityH		(humidityH),		//温度数据整数
	.humidityL		(humidityL),		//温度数据小数
	
	//OLED IIC
	.OLED_SCL	(OLED_SCL),
	.OLED_SDA	(OLED_SDA)
	
);


endmodule 