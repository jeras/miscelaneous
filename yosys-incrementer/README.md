## LibreLane technology mapping

LibreLane technology mapping variables:
```
# Latch mapping
set ::env(SYNTH_LATCH_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/latch_map.v"

# Tri-state buffer mapping
set ::env(SYNTH_TRISTATE_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/tribuff_map.v"

# Full adder mapping
set ::env(SYNTH_FA_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/fa_map.v"

# Ripple carry adder mapping
set ::env(SYNTH_RCA_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/rca_map.v"

# Carry select adder mapping
set ::env(SYNTH_CSA_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/csa_map.v"
```

## Standard cell libraries



AOAOI ((AB+C)D)_
OAOI (((A+B)C)+D)_
OAOAI (((A+B)C)+D)_
AOAI (((AB+C)D)_)

half adder EXOR and an AOI22
full adder three-bit EXOR and an AOI222

### Skywater 130nm PDK

- `sky130_fd_sc_hd` and `sky130_fd_sc_hdll` (does not contain any adder cells):
  - [HD](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hd/cells/ha/README.html)
    `ha` - half adder
  - [HD](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hd/cells/fa/README.html)
    `fa` - full adder
  - [HD](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hd/cells/fah/README.html)
    `fah` - full adder
  - [HD](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hd/cells/fahcin/README.html)
    `fahcin` - full adder, inverted carry in
  - [HD](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hd/cells/fahcon/README.html)
    `fahcon` - full adder, inverted carry in, inverted carry out
- `sky130_fd_sc_hs`, `sky130_fd_sc_ms`, `sky130_fd_sc_ls`:
  - [HS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hs/cells/ha/README.html)
    [MS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ms/cells/ha/README.html)
    [LS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ls/cells/ha/README.html)
    `ha` - half adder
  - [HS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hs/cells/fa/README.html)
    [MS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ms/cells/fa/README.html)
    [LS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ls/cells/fa/README.html)
    `fa` - full adder
  - [HS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hs/cells/fah/README.html)
    [MS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ms/cells/fah/README.html)
    [LS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ls/cells/fah/README.html)
    `fah` - full adder
  - [HS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hs/cells/fahcin/README.html)
    [MS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ms/cells/fahcin/README.html)
    [LS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ls/cells/fahcin/README.html)
    `fahcin` - full adder, inverted carry in
  - [HS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hs/cells/fahcon/README.html)
    [MS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ms/cells/fahcon/README.html)
    [LS](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_ls/cells/fahcon/README.html)
    `fahcon` - full adder, inverted carry in, inverted carry out
- `sky130_fd_sc_lp`:
  - [LP](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_lp/cells/ha/README.html)
    `ha` - half adder
  - [LP](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_lp/cells/fa/README.html)
    `fa` - full adder
  - [LP](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_lp/cells/fah/README.html)
    `fah` - full adder
  - [LP](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_lp/cells/fahcin/README.html)
    `fahcin` - full adder, inverted carry in
  - [LP](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_lp/cells/fahcon/README.html)
    `fahcon` - full adder, inverted carry in, inverted carry out
- `sky130_fd_sc_hvl` (does not contain any adder cells):

### IHP Open Source PDK

