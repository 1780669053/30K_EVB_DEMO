module uart_demo(
	input			clk,
	input			rst_n,
	input			uart_rx,
	output			uart_tx
);

/* 
	功能描述：
		1. 串口回环：uart demo将会转发接收到的信息
	系统参数：
		1. baud rate: 115200

*/
	localparam CLK_FREQ = 25 * 1000000;
    localparam CYCLE = 1e9 / CLK_FREQ;

	wire			baud_pulse;
	wire			tx_req;
	wire	[7:0]	tx_byte;
	wire			tx_busy;
	wire	[7:0]	rx_byte;
	wire			rx_valid;

	baud_pulse_gen
    #(
        .CLK_FREQ       (CLK_FREQ),
        .BAUD_RATE      (115200)
    )
        u_baud_pulse_gen
    (
        .clk        	(clk),
        .rst_n      	(rst_n),
        .en         	(1'b1),
        .baud_pulse 	(baud_pulse)
    );
	
	uart_tx         u_uart_tx(
		.clk			(clk),
		.rst_n			(rst_n),
		.baud_pulse		(baud_pulse),
		.req			(tx_req),
		.byte_in		(tx_byte),
		.busy			(tx_busy),
		.tx             (uart_tx)
	);
	
    uart_rx         u_uart_rx(
        .clk            (clk),
        .rst_n          (rst_n),
        .rx             (uart_rx),
        .baud_pulse     (baud_pulse),
        .byte_out       (rx_byte),
        .valid_out      (rx_valid)
    );

	loop_ctrl		u_loop_ctrl(
		.clk			(clk),
		.rst_n			(rst_n),
		.byte_in		(rx_byte),
		.valid_in		(rx_valid),
		.tx_busy		(tx_busy),
		.tx_req			(tx_req),
		.byte_out		(tx_byte)
	);

endmodule