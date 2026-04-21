#!/usr/bin/env bash

PDK_HASH=c95f23a75038d54d60ecc7ca060f53851f8f25e5
#PDK_PATH=~/.ciel/ciel/sky130/versions/${PDK_HASH}/sky130A
PDK_PATH=~/.ciel/sky130A
PRIMITIVES=${PDK_PATH}/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
#CELLS=${PDK_PATH}/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
CELLS=sky130_fd_sc_hd.v

LAST_RUN=$(ls -td runs/*/ | head -1)
RUN="runs/latest"
NETLIST=${RUN}/final/nl/pm32.nl.v

INTERCONNECT=nom
#CORNER=ss_100C_1v60
CORNER=tt_025C_1v80
SDF=$RUN/final/sdf/${INTERCONNECT}_${CORNER}/pm32__${INTERCONNECT}_${CORNER}.sdf
LIBERTY=${PDK_PATH}/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__${CORNER}.lib
SPEF=${RUN}/final/spef/${INTERCONNECT}/pm32.${INTERCONNECT}.spef

case $1 in

    "cvc")
        echo "================================================================"
        echo "== RTL simulation"
        echo "================================================================"
        cvc64 spm.v -sv pm32.sv pm32_tb.sv
        ./cvcsim

        echo "================================================================"
        echo "== netlist simulation"
        echo "================================================================"
        cvc64 \
        ${PRIMITIVES} ${CELLS} \
        ${NETLIST} \
        -sv pm32_tb_sdf.sv
        ./cvcsim
        ;;

    "questa")
        echo "================================================================"
        echo "== RTL simulation"
        echo "================================================================"
        qrun +acc -top pm32_tb \
        spm.v pm32.sv \
        pm32_tb.sv

        echo "================================================================"
        echo "== netlist simulation"
        echo "================================================================"
        qrun +acc -top pm32_tb_sdf \
        -defineall SDF=\"${SDF}\" \
        ${PRIMITIVES} ${CELLS} \
        ${NETLIST} \
        pm32_tb_sdf.sv
        ;;

    "iverilog")
        echo "================================================================"
        echo "== RTL simulation"
        echo "================================================================"
        rm m32_tb
        iverilog -g 2012 \
        spm.v pm32.sv \
        pm32_tb.sv \
        -o m32_tb
        vvp m32_tb

        echo "================================================================"
        echo "== netlist simulation"
        echo "================================================================"
        rm m32_tb_sdf
        iverilog -g 2012 -g specify -g interconnect \
        -DSDF=\"${SDF}\" \
        -Tmax \
        ${PRIMITIVES} ${CELLS} \
        ${NETLIST} \
        pm32_tb_sdf.sv \
        -o m32_tb_sdf
        vvp m32_tb_sdf
        ;;

esac

echo "================================================================"
echo "== OpenSTA power estimation TCL script"
echo "================================================================"

cat > opensta_power.tcl <<EOF
read_liberty ${LIBERTY}
read_verilog ${NETLIST}
link_design pm32
read_sdc pm32.sdc
read_spef ${SPEF}
#set_power_activity -input -activity 0.1
#set_power_activity -input_port rst -activity 0
read_vcd -scope pm32_tb_sdf/dut pm32_tb_sdf.vcd
report_power
EOF
