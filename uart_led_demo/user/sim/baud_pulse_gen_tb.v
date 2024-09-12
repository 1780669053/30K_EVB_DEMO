`timescale 1ns/1ps
module baud_pulse_gen_tb;

    reg     clk;
    reg     rst_n;
    reg     en;
    wire    baud_pulse;

    localparam CLK_FREQ = 25e6;
    localparam CYCLE = 1e9 / CLK_FREQ;

    baud_pulse_gen
    #(
        .CLK_FREQ       ( CLK_FREQ    ),
        .BAUD_RATE      ( 115200      )
    )
        u_baud_pulse_gen
    (
        .clk        	( clk         ),
        .rst_n      	( rst_n       ),
        .en         	( en          ),
        .baud_pulse 	( baud_pulse  )
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
            en <= 0;
        @(posedge clk)
            en <= 1;
        #1000000
            $stop;
    end

    always@(posedge clk)begin
        if(baud_pulse)
            $display("pulse @ %0t", $time);
    end

endmodule