module uart_led_demo(
	input			clk,
	input			rst_n,
	input			uart_rx,
	output			uart_tx,
	output	[3:0]	led
);

/* 
	功能描述：
		1. 系统扫描led状态，通过串口发送至上位机，每秒触发一次扫描
		2. 上位机可以发送指令点亮/关闭led
	系统参数：
		1. baud rate: 115200
		2. 控制字位宽为4位，依次代表4颗led的状态，“1”为点亮
*/

//	

endmodule