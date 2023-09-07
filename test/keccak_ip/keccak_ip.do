add wave -position insertpoint sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_keccak_top/i_keccak/CU/*
add wave -position insertpoint sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/i_keccak_top/i_keccak/DP/*

run -all
WaveRestoreZoom {15991312 ns} {15992030 ns}


