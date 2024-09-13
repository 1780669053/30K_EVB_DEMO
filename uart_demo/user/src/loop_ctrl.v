module loop_ctrl(
    input               clk,
    input               rst_n,
    input       [7:0]   byte_in,
    input               valid_in,
    input               tx_busy,
    output reg          tx_req,
    output reg  [7:0]   byte_out
);

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            byte_out <= 8'd0;
        else if(valid_in)
            byte_out <= byte_in;
        else
            byte_out <= byte_out;
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            tx_req <= 1'b0;
        else if(valid_in && !tx_busy)
            tx_req <= 1'b1;
        else if(tx_busy)
            tx_req <= 1'b0;
        else
            tx_req <= tx_req;
    end

endmodule