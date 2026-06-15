import subprocess

from pyosys import libyosys as ys

DUT = "incrementer"

LIBERTY = "~/VLSI/PDK/test-pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
DONTUSE = "-dont_use *clkinv* -dont_use *lpflow*"

stepidx = 0

def report (name: str):
    global stepidx
    stepname = f"{stepidx}_{name}"
    ys.run_pass(f"dump")
    ys.run_pass(f"stat")
    ys.run_pass(f"write_verilog {stepname}.v")
    ys.run_pass(f"write_json {stepname}.json")
    subprocess.Popen(f'netlistsvg {stepname}.json -o {stepname}.svg', shell=True)
    stepidx = stepidx + 1

# read design
ys.run_pass(f"read_verilog -sv {DUT}.sv")
ys.run_pass(f"hierarchy -check -top {DUT}")

# the high-level stuff
ys.run_pass(f"proc; opt")
ys.run_pass(f"memory; opt")
ys.run_pass(f"fsm; opt")
report("proc")

ys.run_pass(f"flatten")
ys.run_pass(f"simplemap; opt")
report("smiplemap")
#ys.run_pass(f"shell")

ys.run_pass(f"alumacc; opt")
report("alumacc")
#ys.run_pass(f"shell")

# mapping to internal cell library
ys.run_pass(f"techmap; opt")
report("techmap")
#ys.run_pass(f"shell")

#ys.run_pass(f"extract_fa -ha; opt")
#report("extract_fa")
#ys.run_pass(f"shell")

# technoloqy mapping to sky130 HD SCL
#techmap -map latch_map.v
#report("techmap_map")

ys.run_pass(f"dfflibmap -liberty {LIBERTY}")
report("dfflibmap")
#ys.run_pass(f"shell")

ys.run_pass(f"opt_merge;")
ys.run_pass(f"dump; stat -tech cmos; write_verilog opt_merge.v")
report("opt_merge")
#ys.run_pass(f"shell")

# mapping logic to SCL
ys.run_pass(f"abc -liberty {LIBERTY} {DONTUSE}")
report("abc")

## cleanup
#clean
#
## write synthesized design
ys.run_pass(f"write_verilog netlist.v")
ys.run_pass(f"write_json netlist.json")

# create SVG schematic
subprocess.Popen('netlistsvg netlist.json -o netlist.svg', shell=True)