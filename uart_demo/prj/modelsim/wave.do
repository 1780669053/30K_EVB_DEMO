onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_demo_tb/CLK_FREQ
add wave -noupdate /uart_demo_tb/CYCLE
add wave -noupdate /uart_demo_tb/clk
add wave -noupdate /uart_demo_tb/rst_n
add wave -noupdate /uart_demo_tb/uart_tx
add wave -noupdate /uart_demo_tb/uart_rx
add wave -noupdate /uart_demo_tb/en
add wave -noupdate /uart_demo_tb/req
add wave -noupdate -radix binary /uart_demo_tb/byte_in
add wave -noupdate /uart_demo_tb/baud_pulse
add wave -noupdate /uart_demo_tb/baud_gen_busy
add wave -noupdate /uart_demo_tb/baud_gen_tx
add wave -noupdate -itemcolor Pink /uart_demo_tb/u_uart_demo/u_loop_ctrl/clk
add wave -noupdate -itemcolor Pink /uart_demo_tb/u_uart_demo/u_loop_ctrl/rst_n
add wave -noupdate -itemcolor Pink /uart_demo_tb/u_uart_demo/u_loop_ctrl/byte_in
add wave -noupdate -itemcolor Pink /uart_demo_tb/u_uart_demo/u_loop_ctrl/valid_in
add wave -noupdate -itemcolor Pink /uart_demo_tb/u_uart_demo/u_loop_ctrl/tx_busy
add wave -noupdate -itemcolor Pink /uart_demo_tb/u_uart_demo/u_loop_ctrl/tx_req
add wave -noupdate -itemcolor Pink -radix binary /uart_demo_tb/u_uart_demo/u_loop_ctrl/byte_out
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/clk
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/rst_n
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/baud_pulse
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/req
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/byte_in
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/busy
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/tx
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/curr_state
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/next_state
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/data_baud_cnt
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/tx_done
add wave -noupdate /uart_demo_tb/u_uart_demo/u_uart_tx/byte_in_reg
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/clk
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/rst_n
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/baud_pulse
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/req
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/byte_in
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/busy
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/tx
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/curr_state
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/next_state
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/data_baud_cnt
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/tx_done
add wave -noupdate -itemcolor {Sky Blue} /uart_demo_tb/u_uart_tx/byte_in_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8700000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {325143 ns}
