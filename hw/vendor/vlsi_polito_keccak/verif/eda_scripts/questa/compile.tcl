############################################################## 
# Author: Petr Bardonek ibardonek@fit.vut.cz
# Language: Tcl
# Description: Tcl script containing functions for compilation 
#              of RTL files written in HDL
############################################################## 
source "eda_scripts/questa/start_common.tcl"

# compile SystemVerilog source file(s)
proc compile_fve_source { LIBRARY SRC_FILES {INC_DIRS ""}} {
    set COMPILE_CMD "vlog -sv -incr -source -timescale \"1ps/1ps\" -work ${LIBRARY} ${INC_DIRS} ${SRC_FILES} -suppress 8386"
    eval ${COMPILE_CMD}
}

# compile VHDL RTL source file(s)
proc compile_vhdl { LIBRARY SRC_FILES {INC_DIRS ""}} {
    global CODE_COVERAGE_FLAGS
    # VHDL 2008 is required for testbench compilation only, RTL is compliant with 1993 standard
    set COMPILE_CMD "vcom -explicit -2008 -source ${CODE_COVERAGE_FLAGS} -work ${LIBRARY} ${INC_DIRS} ${SRC_FILES}"
    eval "${COMPILE_CMD} -just pe"
    eval "${COMPILE_CMD} -skip pec"
    eval "${COMPILE_CMD} -just c"
}

# compile Verilog RTL source file(s)
proc compile_verilog { LIBRARY SRC_FILES {INC_DIRS ""}} {
    global CODE_COVERAGE_FLAGS
    set COMPILE_CMD "vlog -incr -source ${CODE_COVERAGE_FLAGS} -timescale \"1ps/1ps\" -work ${LIBRARY} ${INC_DIRS} ${SRC_FILES}"
    eval ${COMPILE_CMD}
}

# compile SystemVerilog RTL source file(s)
proc compile_sverilog { LIBRARY SRC_FILES {INC_DIRS ""}} {
    global CODE_COVERAGE_FLAGS
    set COMPILE_CMD "vlog -sv -sv12compat -incr -source ${CODE_COVERAGE_FLAGS} -timescale \"1ps/1ps\" -work ${LIBRARY} ${INC_DIRS} ${SRC_FILES}"
    eval ${COMPILE_CMD}
}

proc compile_cnd { LIBRARY SRC_FILES CMD HDL_EXT INC_DIRS} {
    set FILES [filter_extensions ${SRC_FILES} ${HDL_EXT}]
    if { [llength ${FILES}] } {
        eval "${CMD} {${LIBRARY}} {${FILES}} ${INC_DIRS}"
    }
}

# compile all RTL source files in given directory and its sub-directories
proc compile_rtl_directory { LIBRARY HDL_DIRECTORY {INC_DIRS ""}} {
    set SRC_FILES [get_file_list ${HDL_DIRECTORY} ""]

    compile_cnd ${LIBRARY} ${SRC_FILES} compile_vhdl vhd ${INC_DIRS}
    compile_cnd ${LIBRARY} ${SRC_FILES} compile_verilog v ${INC_DIRS}
    compile_cnd ${LIBRARY} ${SRC_FILES} compile_sverilog sv ${INC_DIRS}
}

proc get_list_from_file { FILE_NAME } {
    # Open the file for reading
    set rtl_file [open $FILE_NAME r]

    # Initialize an empty list to store lines
    set SRC_FILES {}

    # Read each line and append it to the list
    while {[gets $rtl_file line] != -1} {
        lappend SRC_FILES $line
    }

    # Close the file
    close $rtl_file

    return $SRC_FILES
}

# create working library and compile source files
proc compile_sources { LIBRARY HDL_DIRECTORY } {
    # backup previous error message and set new one
    global ERROR_MESSAGE
    quietly set prev_error_msg ERROR_MESSAGE
    quietly set ERROR_MESSAGE "Compilation error has been encountered."

    # create working library
    vlib $LIBRARY

    # DUT compilation
    quietly set CODE_COVERAGE_FLAGS "+cover=sbcef -nowarn 13"

    set SRC_FILES [get_list_from_file "rtl_files.f"]

    foreach line $SRC_FILES {
        puts $line
        set re {([^.]*$)}
        regexp $re $line match
        switch $match {
            "sv" {
                # Handle sv case
                puts "Processing SystemVerilog line: $line"
                compile_sverilog ${LIBRARY} $line
            }
            "vhd" {
                # Handle vhd case
                puts "Processing VHDL line: $line"
                compile_vhdl ${LIBRARY} $line
            }
            "v" {
                # Handle v case
                puts "Processing Verilog line: $line"
                compile_verilog ${LIBRARY} $line
            }
            default {
                # Handle other cases
                puts "Unknown format in line: $line"
            }
        }
    }

    # verification environment compilation
    set SRC_FILES [list \
      test_parameters.sv  \
      [file join keccak_agent sv_keccak_agent_pkg.sv] \
      [file join golden_model sv_golden_model_pkg.sv] \
      [file join env_lib sv_env_pkg.sv] \
      [file join test_lib sv_test_pkg.sv] \
      [file join keccak_agent keccak_itf.sv] \
      dut.sv  \
      top_level.sv  \
    ]

    compile_fve_source ${LIBRARY} ${SRC_FILES}
    # restore previous error message
    quietly set ERROR_MESSAGE prev_error_msg
}
