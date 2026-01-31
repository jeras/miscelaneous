#! /bin/bash

PRJ=binary2thermometer

# test both implementations
for imp in "POWER" "SHIFT"
do
    yosys --plugin slang --logfile ${PRJ}_${imp}.log -p \
    "read_slang ${PRJ}.sv --top ${PRJ} -G IMPLEMENTATION=\"${imp}\"; \
     proc; opt -full; \
     write_json ${PRJ}_${imp}.json; \
     write_verilog ${PRJ}_${imp}.verilog"
    netlistsvg ${PRJ}_${imp}.json -o ${PRJ}_${imp}.svg
done

