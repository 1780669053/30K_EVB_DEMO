module uart_tx(
    input               clk,
    input               rst_n,
    input               baud_pulse,
    input               req,
    input       [7:0]   byte_in,
    output reg          busy,
    output reg          tx
);

    localparam S_IDLE   = 2'b00;
    localparam S_START  = 2'b01;
    localparam S_DATA   = 2'b11;
    localparam S_STOP   = 2'b10;

    reg     [1:0]   curr_state, next_state;
    reg     [2:0]   data_baud_cnt;
    wire            tx_done;
    reg     [7:0]   byte_in_reg;


    /*
        req-busy设计
        1. uart_tx上电后空闲(!busy)
        2. uart_tx的前级检测到uart_tx空闲，可以提交请求(req)，同时发送数据
        3. uart_tx前级的req伴随着数据到来，req期间，前级给的数据必须稳定
        4. uart_tx响应req，首先会存储数据，同时拉高busy，忙着处理数据
        5. 在uart_tx处理期间，前级撤回req信号(!req)，准备新的数据
        6. uart_tx在处理完成后，会重新拉低busy
        6. uart_tx前级耐心等待uart_tx空闲，这之后可以重新提交req
    */

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            curr_state <= S_IDLE;
        else
            curr_state <= next_state;
    end

    always@(*)case(curr_state)
        S_IDLE:
            if(baud_pulse && req)
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
            busy <= 1'b0;
        else if(req && baud_pulse)
            busy <= 1'b1;
        else if(tx_done)
            busy <= 1'b0;
        else
            busy <= busy;
    end

    assign tx_done = (curr_state == S_STOP && next_state == S_IDLE);

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
            byte_in_reg <= 8'd0;
        else if(req)
            byte_in_reg <= byte_in;
        else if(next_state == S_DATA && baud_pulse)
            byte_in_reg <= byte_in_reg << 1;
        else
            byte_in_reg <= byte_in_reg;
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            tx <= 1'b1;
        else if(next_state == S_START && baud_pulse)
            tx <= 1'b0;
        else if(next_state == S_DATA && baud_pulse)
            tx <= byte_in_reg[7];
        else if(next_state == S_STOP && baud_pulse)
            tx <= 1'b1;
        else
            tx <= tx;
    end

endmodule