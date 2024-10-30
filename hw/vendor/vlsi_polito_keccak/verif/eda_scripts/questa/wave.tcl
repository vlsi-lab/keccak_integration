############################################################## 
# Author: Petr Bardonek ibardonek@fit.vut.cz
# Language: Tcl
# Description: Tcl script for wave view for verification when
#              run in GUI
############################################################## 

# Signals of interfaces.
proc basic { PATH } {
    add wave -noupdate -divider "Basic signals"
    add wave -noupdate -color yellow -label CLK $PATH/CLK
    add wave -noupdate -color yellow -label rst_n $PATH/rst_n
}

proc i_keccak_itf { PATH } {
    set PROBE_PATH $PATH

    add wave -noupdate -divider "Keccak DUT signals:"
    add wave -noupdate -divider "input"
    add wave -noupdate -hex -label start $PROBE_PATH/start
    add wave -noupdate -hex -label din $PROBE_PATH/din

    add wave -noupdate -divider "output"
    add wave -noupdate -hex -label dout $PROBE_PATH/dout
    add wave -noupdate -hex -label status_d $PROBE_PATH/status_d
    add wave -noupdate -hex -label status_de $PROBE_PATH/status_de
    add wave -noupdate -hex -label keccak_intr $PROBE_PATH/keccak_intr

    add wave -noupdate -divider "Keccak GM signals:"
    add wave -noupdate -divider "output"
    add wave -noupdate -hex -color orange -label dout sv_keccak_gm_pkg::keccak_gm::dout
    add wave -noupdate -hex -color orange -label status_d sv_keccak_gm_pkg::keccak_gm::status_d
    add wave -noupdate -hex -color orange -label status_de sv_keccak_gm_pkg::keccak_gm::status_de
    add wave -noupdate -hex -color orange -label keccak_intr sv_keccak_gm_pkg::keccak_gm::keccak_intr
    add wave -noupdate -divider "auxiliar variables"
    add wave -noupdate -hex -color orange -label result sv_keccak_gm_pkg::keccak_gm::result
    add wave -noupdate -dec -color orange -label cnt sv_keccak_gm_pkg::keccak_gm::cnt
    add wave -noupdate -hex -color orange -label curr_st sv_keccak_gm_pkg::keccak_gm::curr_st
    add wave -noupdate -hex -color orange -label next_st sv_keccak_gm_pkg::keccak_gm::next_st
}

proc customize_gui { } {
    global DUT_MODULE
    global HDL_DUT
    # View simulation waves
    view wave
    # Remove all previous waves first
    delete wave *
    # Clock and reset signals
    puts $DUT_MODULE
    puts $HDL_DUT
    basic $DUT_MODULE/keccak_itf
    i_keccak_itf $DUT_MODULE/keccak_itf

    # Additional wave configuration
    TreeUpdate [SetDefaultTree]
    configure wave -namecolwidth 200
    configure wave -valuecolwidth 100
    configure wave -justifyvalue left
    configure wave -signalnamewidth 0
    configure wave -gridoffset 0
    configure wave -gridperiod {10 ns}
    configure wave -griddelta 50
    configure wave -timeline 0
    configure wave -timelineunits ns
    WaveRestoreZoom {0 ns} {250 ns}
    update
    view structure
    view signals
    wave refresh
}
