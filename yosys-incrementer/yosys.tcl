
set LIBERTY $::env(HOME)/VLSI/PDK/test-pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
set DONTUSE {-dont_use *clkinv* -dont_use *lpflow*}

yosys -import

# read design
read_verilog -sv incrementer.sv
hierarchy -check -top incrementer

# the high-level stuff
procs; opt
memory; opt
fsm; opt
dump; stat; write_verilog proc.v

flatten
simplemap; opt
dump; stat; write_verilog simplemap.v
#shell

alumacc; opt
dump; stat; write_verilog alumacc.v
#shell

# mapping to internal cell library
techmap; opt
dump; stat -tech cmos; write_verilog techmap.v
#shell

#extract_fa -ha; opt
#dump; stat -tech cmos; write_verilog extract_fa.v
##shell

# technoloqy mapping to sky130 HD SCL
#techmap -map latch_map.v
#dump
#write_verilog techmap_map.v

dfflibmap -liberty $LIBERTY
dump; stat -tech cmos; write_verilog dfflibmap.v
#shell

opt_merge;
dump; stat -tech cmos; write_verilog opt_merge.v
#shell

# mapping logic to SCL
set ARGUMENT {$LIBERTY $DONTUSE}
#abc -liberty $ARGUMENT
abc -liberty $LIBERTY $DONTUSE
#abc -liberty /home/izi/VLSI/PDK/test-pdk/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib -dont_use *clkinv* -dont_use *lpflow*
dump; stat -tech cmos; write_verilog abc.v

## cleanup
#clean
#
## write synthesized design
#write_verilog synth.v