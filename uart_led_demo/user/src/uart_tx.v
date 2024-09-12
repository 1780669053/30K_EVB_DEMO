module uart_tx(
    input               clk,
    input               rst_n,
    input               baud_pulse,
    input               req,
    input       [7:0]   byte_in,
    output reg          busy,
    output reg          tx
);

    localparam S_IDLE   = 1'b00;
    localparam S_START  = 1'b01;
    localparam S_DATA   = 1'b11;
    localparam S_STOP   = 1'b10;

    reg     [1:0]   curr_state, next_state;

    /*
        req-busy握手
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
            ready <= 1'b1;
        else if(valid)
            ready <= 1'b0;
        else if(tx_done)
            ready <= 1'b1;
        else
            ready <= ready;
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)
            curr_state <= S_IDLE;
        else
            curr_state <= next_state;
    end

    always@(*)case(curr_state)
        S_IDLE:
            if(valid && baud_pulse)
                next_state = S_START;
            else
                next_state = S_IDLE;
        S_START:
            if( && baud_pulse)


    endcase


endmodule