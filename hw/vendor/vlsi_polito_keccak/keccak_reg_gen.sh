
echo "Generating Keccak data registers data RTL"
/home/mattia.mirigaldi/projects/pqc_x_heep/hw/vendor/esl_epfl_x_heep/hw/vendor/pulp_platform_register_interface/vendor/lowrisc_opentitan/util/regtool.py -r -t rtl/gen_sv data/keccak_data_regs.hjson
echo "Generating Keccak ctrl registers data RTL"
/home/mattia.mirigaldi/projects/pqc_x_heep/hw/vendor/esl_epfl_x_heep/hw/vendor/pulp_platform_register_interface/vendor/lowrisc_opentitan/util/regtool.py -r -t rtl/gen_sv data/keccak_ctrl_regs.hjson

echo "Generating Keccak data registers data SW"
/home/mattia.mirigaldi/projects/pqc_x_heep/hw/vendor/esl_epfl_x_heep/hw/vendor/pulp_platform_register_interface/vendor/lowrisc_opentitan/util/regtool.py --cdefines -o sw/keccak_data_auto.h data/keccak_data_regs.hjson
echo "Generating Keccak ctrl registers data SW"
/home/mattia.mirigaldi/projects/pqc_x_heep/hw/vendor/esl_epfl_x_heep/hw/vendor/pulp_platform_register_interface/vendor/lowrisc_opentitan/util/regtool.py --cdefines -o sw/keccak_ctrl_auto.h data/keccak_ctrl_regs.hjson

