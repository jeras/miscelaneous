import subprocess

from pyosys import libyosys as ys

#PRIMITIVES = "~/VLSI/PDK/test-pdk/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
PRIMITIVES = "primitives.v"
FUNCTIONAL = "~/VLSI/PDK/test-pdk/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
#FUNCTIONAL = "sky130_fd_sc_hd.v"
LIBERTY    = "~/VLSI/PDK/test-pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
DONTUSE = "-dont_use *clkinv* -dont_use *lpflow*"

#for DUT in ["incrementer", "decrementer"]:
#for DUT in ["adder"]:
#for DUT in ["riscv_alu"]:
for DUT in ["incrementer"]:

    stepidx = 0

    def report (name: str):
        global stepidx
        stepname = f"reports/{DUT}_{stepidx}_{name}"
        ys.run_pass(f"dump")
        ys.run_pass(f"stat")
        ys.run_pass(f"write_verilog {stepname}.v")
        ys.run_pass(f"write_json {stepname}.json")
        subprocess.Popen(f'netlistsvg {stepname}.json -o {stepname}.svg', shell=True)
        stepidx = stepidx + 1

    # read design
    ys.run_pass(f"read_verilog -sv {DUT}.sv")
 
    ys.run_pass(f"hierarchy -check -top {DUT}")
#    ys.run_pass(f"select -list")

    # the high-level stuff
    ys.run_pass(f"proc; opt")
    ys.run_pass(f"memory; opt")
    ys.run_pass(f"fsm; opt")
    report("proc")

    ys.run_pass(f"flatten")

    # map simple cells to gate primitives
    ys.run_pass(f"equiv_opt -assert -async2sync simplemap")
    ys.run_pass(f"simplemap; opt")
    report("simplemap")
    ys.run_pass(f"show -prefix simplemap {DUT}")
#    ys.run_pass(f"shell")

    # make a copy of the design before technology mapping
    ys.run_pass(f"copy {DUT} {DUT}_orig")
    # mapping to internal cell library
#    ys.run_pass(f"read_liberty -ignore_miss_func {LIBERTY}")
#    ys.run_pass(f"select -list")
#    ys.run_pass(f"show -prefix sky130_fd_sc_hd__ha_1 sky130_fd_sc_hd__ha_1")
#    ys.run_pass(f"show -prefix librelane_fa_test librelane_fa_test")
#    ys.run_pass(f"equiv_opt -map {LIBERTY} -map {PRIMITIVES} -map {FUNCTIONAL} -assert techmap -map rca_map.v")
#    ys.run_pass(f"techmap -map rca_map.v; opt")
#    report("rca_map")
#    ys.run_pass(f"show {DUT}")
#    ys.run_pass(f"select -list")
##    ys.run_pass(f"shell")

    ys.run_pass(f"alumacc")
    report("alumacc")
#    ys.run_pass(f"equiv_opt -map {LIBERTY} -map {PRIMITIVES} -map {FUNCTIONAL} -assert techmap -map rca_map.v")
    ys.run_pass(f"show -prefix alumacc {DUT}")
#    ys.run_pass(f"shell")

    ys.run_pass(f"opt_expr")
    report("alumacc_opt_expr")
#    ys.run_pass(f"equiv_opt -map {LIBERTY} -map {PRIMITIVES} -map {FUNCTIONAL} -assert techmap -map rca_map.v")
    ys.run_pass(f"show -prefix alumacc_opt_expr {DUT}")


    ys.run_pass(f"techmap -map rca_map.v")
    ys.run_pass(f"show -prefix techmap_map {DUT}")

#    # mapping to internal cell library
#    ys.run_pass(f"techmap")
#    report("techmap")
#    ys.run_pass(f"show -prefix techmap {DUT}")
#    ys.run_pass(f"opt")
#    report("techmap_opt")
#    ys.run_pass(f"show -prefix techmap_opt {DUT}")
##    ys.run_pass(f"shell")

#    #ys.run_pass(f"extract_fa -ha; opt")
#    #report("extract_fa")
#    #ys.run_pass(f"shell")
#
#    # clock gating
#    ys.run_pass(f"clockgate -liberty {LIBERTY}")
#    report("clockgate")
##    ys.run_pass(f"shell")
#
#    # flip-flop mapping
#    ys.run_pass(f"dfflibmap -liberty {LIBERTY}")
#    report("dfflibmap")
##    ys.run_pass(f"shell")
#
#    ys.run_pass(f"opt_merge;")
#    report("opt_merge")
##    ys.run_pass(f"shell")
#
#    # mapping logic to SCL
#    ys.run_pass(f"abc -liberty {LIBERTY} {DONTUSE}")
#    report("abc")
#
#    ## write synthesized design
#    ys.run_pass(f"write_verilog {DUT}_netlist.v")
#    ys.run_pass(f"write_json {DUT}_netlist.json")
#
#    #######################################
#    # equivalence check
#    #######################################
#
##    ys.run_pass(f"read_verilog -D FUNCTIONAL -sv {PRIMITIVES} {FUNCTIONAL}")
#    ys.run_pass(f"read_verilog -D FUNCTIONAL -D UNIT_DELAY -sv {PRIMITIVES} {FUNCTIONAL}")
    ys.run_pass(f"read_liberty -ignore_miss_func {LIBERTY}")
#
#
#    ys.run_pass(f"show {DUT}")
#    ys.run_pass(f"hierarchy -top {DUT}")
#    ys.run_pass(f"select -list")
#
#
#    ys.run_pass(f"opt_clean -purge")
#    # create a miter circuit to test equivalence
    ys.run_pass(f"miter -equiv -make_assert -make_outputs {DUT}_orig {DUT} miter")
#    ys.run_pass(f"select -list")
    ys.run_pass(f"hierarchy -top miter")
#    ys.run_pass(f"select -list")
#    ys.run_pass(f"async2sync")
    ys.run_pass(f"flatten")
#    # run equivalence check
    ys.run_pass(f"sat -verify -prove-asserts -show-inputs -show-outputs -show-public miter")
#
#    # cleanup
#    clean
#
#    # create SVG schematic
#    subprocess.Popen('netlistsvg {DUT}_netlist.json -o {DUT}_netlist.svg', shell=True)