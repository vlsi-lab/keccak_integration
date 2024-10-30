############################################################## 
# Author: Petr Bardonek ibardonek@fit.vut.cz
# Language: Tcl
# Description: Main tcl script for verification run
############################################################## 
package require cmdline

source "eda_scripts/questa/compile.tcl"
source "eda_scripts/questa/start_common.tcl"

# parse script arguments
# updates global variables when configured from cmdline
proc parse_arguments { ARGV } {
    # make global variables available
    global UVM_TESTNAME
    global UVM_TESTS_FILE
    global RUN_MULTIPLE_TESTS
    global SEED
    global TRANSACTION_COUNT

    # prepare variables necessary for the cmdline package
    set USAGE "do start.tcl -uvm_testname uvm_class_name -uvm_tests_file path_to_tests_file -run_multiple_tests -seed number"
    set PARAMETERS {
        { "uvm_testname.arg" "" "Specify which UVM test to execute (optional)" }
        { "uvm_tests_file.arg" "" "Specify location of the file with list of test names (optional)" }
        { "run_multiple_tests" "Run all tests specified in file with list of test names (optional)" }
        { "seed.arg" "" "Specify seed for randomization (optional)" }
        { "trans_cnt.arg" "" "Specify number of transactions (optional)" }\
    }
    array set ARGUMENTS [::cmdline::getoptions ARGV ${PARAMETERS} ${USAGE}]
    if { [string length $ARGUMENTS(uvm_testname)] > 0 } {
        if { [string index $ARGUMENTS(uvm_testname) 0] == "-" } {
            run_on_error "Error: Specification of test name is required \nUsage: ${USAGE}"
        }
        set UVM_TESTNAME $ARGUMENTS(uvm_testname)
    }
    if { [string length $ARGUMENTS(uvm_tests_file)] > 0 } {
        if { [string index $ARGUMENTS(uvm_tests_file) 0] == "-" } {
            run_on_error "Error: Specification of path to file with list of tests is required \nUsage: ${USAGE}"
        }
        set UVM_TESTS_FILE $ARGUMENTS(uvm_tests_file)
    }
    if { $ARGUMENTS(run_multiple_tests) == 1} {
        set RUN_MULTIPLE_TESTS $ARGUMENTS(run_multiple_tests)
    }

    if { [string length $ARGUMENTS(seed)] > 0 } {
        if { [string index $ARGUMENTS(seed) 0] == "-" } {
            run_on_error "Error: Specification of the number used as seed for randomization is required \nUsage: ${USAGE}"
        }
        set SEED $ARGUMENTS(seed)
    }

    if { [string length $ARGUMENTS(trans_cnt)] > 0 } {
        if { [string index $ARGUMENTS(trans_cnt) 0] == "-" } {
            run_on_error "Error: Specification of the number of transactions used is required \nUsage: ${USAGE}"
        }
        set TRANSACTION_COUNT $ARGUMENTS(trans_cnt)
    }
}

# run single simulation
proc run_program { VSIM_RUN_CMD UVM_TESTNAME COVERAGE_FILE} {
    global ERROR_MESSAGE
    global UCDB_DIR
    global SEED
    global TRANSACTION_COUNT
    quietly set ERROR_MESSAGE "Error occured while running test ${UVM_TESTNAME}"

    append VSIM_RUN_CMD " +UVM_TESTNAME=${UVM_TESTNAME} +SEED=${SEED}"
    if { $TRANSACTION_COUNT != 0 } {
        # specify UVM test to run
        append VSIM_RUN_CMD " +TRANSACTION_COUNT=${TRANSACTION_COUNT}"
    }


    # start of the simulation
    eval ${VSIM_RUN_CMD}

    suppress_warnings
    # set variables to run multiple programs
    onbreak resume
    onfinish stop

    # Disable logging
    # nolog -all

    # definition of signals in a wave window and complete GUI customization
    if { ![batch_mode] } {
        source "eda_scripts/questa/wave.tcl"
        customize_gui
    }

    # run the simulation
    run -all
    # save coverage from current run
    save_coverage ./${UCDB_DIR}/${COVERAGE_FILE}
}

# quit any previous simulation
quit -sim

# prepare script arguments for the cmdline package
set DO_ARGS ""
while { $argc != 0 } {
    set DO_ARGS [concat ${DO_ARGS} ${1}]
    shift
}

# parse script arguments
quietly set ERROR_MESSAGE "Error occured while parsing arguments"
parse_arguments ${DO_ARGS}
clear_transcript_file
if { ![batch_mode] } {
    .main clear
}

# compile HDL and HVL source files
compile_sources $WORKING_LIBRARY $HDL_DIRECTORY

if { ${RUN_MULTIPLE_TESTS} } {
    # check if path to file with tests is set
    if { [string length ${UVM_TESTS_FILE}] > 0} {
        # check if set file exists
        if { [file isfile ${UVM_TESTS_FILE}]} {
            set TESTS_RUN 0
            file mkdir ${UCDB_DIR}
            set fp [open ${UVM_TESTS_FILE} r]
            while { [gets $fp uvm_test] >= 0 } {
                if { [string length ${uvm_test}] > 0 } {
                    set TESTS_RUN 1
                    run_program [subst ${VSIM_RUN_CMD}] ${uvm_test} ${uvm_test}.ucdb
                    # quit any previous simulation
                    quit -sim
                }
            }
            close $fp
            if { [file exists ${VSIM_COV_MERGE_FILE}] } {
                file delete ${VSIM_COV_MERGE_FILE}
            }
            if {${TESTS_RUN}} {
                eval ${VSIM_COVERAGE_MERGE}
            }
        } else {
            run_on_error "Error: Input file '${UVM_TESTS_FILE}' does not exist"
        }
    } else {
        run_on_error "Error: Path to file with list of test names is required, see\
        parameter -uvm_tests_file usage"
    }

} else {
    if { [string length ${UVM_TESTNAME}] > 0} {
        file mkdir ${UCDB_DIR}
        run_program [subst ${VSIM_RUN_CMD}] ${UVM_TESTNAME} ${UVM_TESTNAME}.ucdb
    } else {
        run_on_error "Error: UVM testname has to be specified"
    }
}

if [batch_mode] {
    quit -f
} else {
    pause
}
