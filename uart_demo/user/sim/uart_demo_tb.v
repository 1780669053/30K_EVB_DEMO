`timescale 1ns/1ps
module uart_demo_tb;
    
	localparam CLK_FREQ = 25 * 1000000;
    localparam CYCLE = 1e9 / CLK_FREQ;
	
	reg             clk;
    reg             rst_n;
    wire            uart_tx;
    wire            uart_rx;

    // baud 发生器 *********************************** BEGIN

    reg             en;
    reg             req;
    reg     [7:0]   byte_in;

	wire			baud_pulse;
    wire            baud_gen_busy;
	wire            baud_gen_tx;
    

	baud_pulse_gen
    #(
        .CLK_FREQ       (CLK_FREQ),
        .BAUD_RATE      (115200)
    )
        u_baud_pulse_gen
    (
        .clk        	(clk),
        .rst_n      	(rst_n),
        .en         	(en),
        .baud_pulse 	(baud_pulse)
    );
	
	uart_tx         u_uart_tx(
		.clk			(clk),
		.rst_n			(rst_n),
		.baud_pulse		(baud_pulse),
		.req			(req),
		.byte_in		(byte_in),
		.busy			(baud_gen_busy),
		.tx             (baud_gen_tx)
	);

    task bx_req(
        input   [7:0]   task_byte_in
    );
		begin
            $display("uart tx data %b", task_byte_in);
		    @(posedge clk);
			byte_in <= task_byte_in;
			req		<= 1'b1;
			en		<= 1'b1;
		    wait(baud_gen_busy);
            @(posedge clk);
			req		<= 1'b0;
            wait(!baud_gen_busy);
        end
	endtask

	// baud 发生器 *********************************** END

    assign uart_rx = baud_gen_tx;

    uart_demo       u_uart_demo(
        .clk			(clk),
        .rst_n			(rst_n),
        .uart_rx		(uart_rx),
        .uart_tx        (uart_tx)
    );


	initial clk = 0;
    always #(CYCLE/2) clk = ~clk;

    initial begin
        #0
            rst_n = 0;
        #5
            rst_n = 1;
    end

    initial begin
        #0
            en 		<= 0;
			req		<= 0;
			byte_in <= 0;
            bx_req(8'b1010_1010);
            bx_req($random % 2**8);
        #10000
            $stop;
    end

    always@(posedge clk)begin
        if(u_uart_demo.u_uart_tx.curr_state == 2'b11 && u_uart_demo.u_baud_pulse_gen.cnt == 16'd2)
            $display("data[%d]: %d", 7-u_uart_demo.u_uart_tx.data_baud_cnt, uart_tx);
    end
	
endmodule