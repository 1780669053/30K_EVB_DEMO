module uart_rx(
    input               clk,
    input               rst_n,
    input               rx,
    input               baud_pulse,
    output reg  [7:0]   byte_out,
    output              valid_out
);

    localparam S_IDLE   = 2'b00;
    localparam S_START  = 2'b01;
    localparam S_DATA   = 2'b11;
    localparam S_STOP   = 2'b10;

    reg     [1:0]   curr_state, next_state;
    reg     [2:0]   data_baud_cnt;

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            curr_state <= S_IDLE;
        else
            curr_state <= next_state;
    end

    always@(*)case(curr_state)
        S_IDLE:
            if(baud_pulse && rx == 1'b0)
                next_state = S_START;
            else
                next_state = S_IDLE;
        S_START:
            if(baud_pulse)
                next_state = S_DATA;
            else
                next_state = S_START;
        S_DATA:
            if(data_baud_cnt == 3'd7 && baud_pulse)
                next_state = S_STOP;
            else
                next_state = S_DATA;
        S_STOP:
            if(baud_pulse)
                next_state = S_IDLE;
            else
                next_state = S_STOP;
    endcase

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            data_baud_cnt <= 3'd7;
        else if(next_state == S_DATA && baud_pulse)
            data_baud_cnt <= data_baud_cnt + 1'b1;
        else
            data_baud_cnt <= data_baud_cnt;
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            byte_out <= 8'd0;
        else if(next_state == S_DATA && baud_pulse)
            byte_out <= {byte_out[6:0], rx};
        else
            byte_out <= byte_out;
    end

    assign valid_out = (curr_state == S_STOP && next_state == S_IDLE);

endmodule