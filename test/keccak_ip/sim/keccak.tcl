
set workdir [pwd]
puts "Working directory :"
puts $workdir
quit -sim 

vcom -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/keccak_globals.vhd
vcom -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/Keccak_2to1mux.vhd
vcom -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/Keccak_REG_rst_n.vhd
vcom -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/reg_en_rst_n.vhd
vcom -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/keccak_round_constants_gen.vhd
vcom -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/keccak_round.vhd
vcom -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/keccak_buffer.vhd
vcom -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/keccak.vhd
vlog -reportprogress 300 -work work $workdir/../rtl/src_64bit_buffer/with_FSM/keccak_cu.sv  
vcom -reportprogress 300 -work work $workdir/keccak_tb.vhd

vsim -debugDB -t 1ns work.keccak_tb

onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate /keccak_tb/clk
add wave -noupdate /keccak_tb/rst_n
add wave -noupdate /keccak_tb/start_i

add wave -noupdate -group KECCAK_CU /keccak_tb/ready_keccak
add wave -noupdate -group KECCAK_CU /keccak_tb/start_keccak
add wave -noupdate -group KECCAK_CU /keccak_tb/CU/State
add wave -noupdate -group KECCAK_CU /keccak_tb/CU/State_next
add wave -noupdate -group KECCAK_CU /keccak_tb/CU/counter
add wave -noupdate -group KECCAK_CU /keccak_tb/CU/status

add wave -noupdate -group INPUT_KECCAK /keccak_tb/din_i
add wave -noupdate -group INPUT_KECCAK /keccak_tb/din_valid_keccak
add wave -noupdate -group INPUT_KECCAK /keccak_tb/din_keccak
add wave -noupdate -group INPUT_KECCAK /keccak_tb/buffer_full

add wave -noupdate -group OUTPUT_KECCAK /keccak_tb/dout_o
add wave -noupdate -group OUTPUT_KECCAK /keccak_tb/dout_valid_keccak
add wave -noupdate -group OUTPUT_KECCAK /keccak_tb/dout_keccak
add wave -noupdate -group OUTPUT_KECCAK /keccak_tb/last_block_keccak
add wave -noupdate -group OUTPUT_KECCAK /keccak_tb/DATAPATH/counter_nr_rounds
add wave -noupdate -group OUTPUT_KECCAK /keccak_tb/DATAPATH/permutation_computed 


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 250
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
configure wave -timelineunits ns
update

run 20 us
WaveRestoreZoom {0 ns} {300 ns}
