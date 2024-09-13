`timescale 1ns/1ps
module uart_rx_tb;
    
	localparam CLK_FREQ = 25 * 1000000;
    localparam CYCLE = 1e9 / CLK_FREQ;
	
	reg             clk;
    reg             rst_n;
    reg             en;
    reg             req;
    reg     [7:0]   byte_in;

    wire            busy;
    wire    [7:0]   byte_out;
    wire            valid_out;
	wire			baud_pulse;
	wire            tx_rx_wire;

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
		.busy			(busy),
		.tx             (tx_rx_wire)
	);
	
    uart_rx         u_uart_rx(
        .clk            (clk),
        .rst_n          (rst_n),
        .rx             (tx_rx_wire),
        .baud_pulse     (baud_pulse),
        .byte_out       (byte_out),
        .valid_out      (valid_out)
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
            wait(valid_out);
        #100
            en      <= 0;
        #10000
            $stop;
    end
	
    always@(posedge clk)begin
        if(u_uart_tx.curr_state == 2'b11 && u_baud_pulse_gen.cnt == 16'd2)
            $display("data[%d]: %d", 7-u_uart_tx.data_baud_cnt, tx_rx_wire);
    end

    always@(posedge clk)begin
        if(valid_out)
            $display("uart rx data %b", byte_out);
    end

	task bx_req(
        input   [7:0]   task_byte_in
    );
		begin
            $display("uart tx data %b", task_byte_in);
		    @(posedge clk);
			byte_in <= task_byte_in;
			req		<= 1'b1;
			en		<= 1'b1;
		    wait(busy);
            @(posedge clk);
			req		<= 1'b0;
            wait(!busy);
        end
	endtask
	
endmodule