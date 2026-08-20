import subprocess

from pyosys import libyosys as ys

#######################################
# equivalence check
#######################################

DUT = "prefix_or"

ys.run_pass(f"read_verilog -sv simlib.v")
ys.run_pass(f"show {DUT}")
ys.run_pass(f"select -list")
ys.run_pass(f"hierarchy -top {DUT}")
ys.run_pass(f"copy {DUT} ref")
ys.run_pass(f"delete {DUT}")

ys.run_pass(f"read_verilog -sv techmap.v")
ys.run_pass(f"show {DUT}")
ys.run_pass(f"select -list")
ys.run_pass(f"copy {DUT} rtl")

# create a miter circuit to test equivalence
ys.run_pass(f"miter -equiv -make_assert -make_outputs ref rtl miter")
ys.run_pass(f"select -list")
ys.run_pass(f"hierarchy -top miter")
ys.run_pass(f"select -list")
ys.run_pass(f"flatten")
# run equivalence check
ys.run_pass(f"sat -verify -prove-asserts -show-inputs -show-outputs -show-public miter")

# cleanup
ys.run_pass(f"clean")

## create SVG schematic
#subprocess.Popen('netlistsvg {DUT}_netlist.json -o {DUT}_netlist.svg', shell=True)