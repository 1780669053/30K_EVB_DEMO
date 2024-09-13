module baud_pulse_gen
#(
    parameter CLK_FREQ  = 25 * 1000000,
    parameter BAUD_RATE = 115200
)
(
    input       clk,
    input       rst_n,
    input       en,
    output      baud_pulse
);
    /*
        模块功能：
            使能状态下（en），输出周期为1个baud的单时钟周期脉冲
    */

    localparam  CYCLE_PER_BAUD = CLK_FREQ / BAUD_RATE;

    reg [15:0]  cnt;

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            cnt <= 16'd0;
        else if(en) 
            if(baud_pulse)
                cnt <= 16'd0;
            else
                cnt <= cnt + 1'b1;
        else
            cnt <= 16'd0;
    end

    assign baud_pulse = (cnt == CYCLE_PER_BAUD-1);

endmodule