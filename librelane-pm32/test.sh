#!/usr/bin/env bash

# default simulator
SIM=iverilog

# default PDK
PDK_HASH=c95f23a75038d54d60ecc7ca060f53851f8f25e5
#PDK=~/.ciel/ciel/sky130/versions/${PDK_HASH}/sky130A
PDK=~/.ciel/sky130A

# default SCL
SCL=sky130_fd_sc_hd

# default RUN (latest run)
RUN=$(ls -td runs/*/ | head -1)

# default interconnect and corner
INTERCONNECT=nom
CORNER=tt_025C_1v80

# parse CLI arguments to override the defaults
while [[ $# -gt 0 ]]; do
    case $1 in
        --sim)
            SIM="$2"
            shift # past argument
            shift # past value
            ;;
        --pdk)
            PDK="$2"
            shift # past argument
            shift # past value
            ;;
        --scl)
            SCL="$2"
            shift # past argument
            shift # past value
            ;;
        --run)
            RUN="$2"
            shift # past argument
            shift # past value
            ;;
        --interconnect)
            INTERCONNECT="$2"
            shift # past argument
            shift # past value
            ;;
        --corner)
            CORNER="$2"
            shift # past argument
            shift # past value
            ;;
        --cells)
            CELLS="$2"
            shift # past argument
            shift # past value
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            echo "Unknown positional argument $1"
            exit 1
            ;;
    esac
done

PRIMITIVES=${PDK}/libs.ref/${SCL}/verilog/primitives.v
CELLS="${CELLS:-${PDK}/libs.ref/${SCL}/verilog/${SCL}.v}"

NETLIST=${RUN}/final/nl/pm32.nl.v

SDF=$RUN/final/sdf/${INTERCONNECT}_${CORNER}/pm32__${INTERCONNECT}_${CORNER}.sdf
LIBERTY=${PDK}/libs.ref/${SCL}/lib/${SCL}__${CORNER}.lib
SPEF=${RUN}/final/spef/${INTERCONNECT}/pm32.${INTERCONNECT}.spef

case $SIM in

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

    *)
        echo "ERROR: unsupported simulator"
        exit 1
        ;;

esac

echo "================================================================"
echo "== OpenSTA power estimation TCL script"
echo "================================================================"

cat > opensta_power__${SCL}__${INTERCONNECT}__${CORNER}.tcl <<EOF
read_liberty ${LIBERTY}
read_verilog ${NETLIST}
link_design pm32
read_sdc pm32.sdc
read_spef ${SPEF}
#set_power_activity -input -activity 0.1
#set_power_activity -input_port rst -activity 0
read_vcd -scope pm32_tb_sdf/dut pm32_tb_sdf.vcd
report_power -digits 6
EOF
