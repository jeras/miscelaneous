# Updating Yosys synthesis

I went through the Yosys synthesis scripts
[pyosys.py](librelane/steps/pyosys.py) and
[synthesize.py](librelane/scripts/pyosys/synthesize.py)
and tested various features to se whether/how they work.

Overall the changes fall into the following groups:
- updates to handling variables and `extra.json`,
- fixing broken adder mapping features and extending it,
- updates for new Yosys/ABC features.

I prepared the next plan proposing various updates to this script.

1. A list of `blackbox_models` is created in `pyosys.py` and passed to `synthesize.py` through `extra.json`.
   I did not properly check this one, but I think the listed files
   are all already available in `config.json`, so going through `extra.json`
   seems like unnecessary extra steps.

2. It is possible `yosys-slang` will be integrated into future versions of Yosys
   (see [branch](https://github.com/YosysHQ/yosys/tree/yosys-slang)),
   so handling of SystemVerilog files might change a bit.

3. `techmap` for `SYNTH_ADDER_TYPE` for `RCA`/`CSA` (but not `FA`/`YOSYS`)
   1. It is processed before the Yosys command `proc` where `always*` statements are processed,
      meaning only adders within Verilog `assign` are affected.
      I did not check this properly, so I might be wrong.
      I did try to build a simple `assign sum=a+b` example and
      `sky130` HD SCL `fa` cells are indeed used.
   2. Since `open_pdks` `rca/csa_map.v` files only cover `$add` and `$sub` cells,
      magnitude comparators (`>`/`<`/`>=`,`<=`) are not covered.
      Without running a tests I would say they are converted to `$alu` during Yosys `alumacc`
      and further into Brent Kung adder during Yosys `techmap`.

4. I had some doubts, but `SYNTH_TRISTATE_MAP` mapping works as expected.
   at least for simple `assign pin = ena ? out : 'z` cases.
   I would have to test whether it would be better to move the `tribuf` pass
   to after proc (part of `librelane_synth` function).

5. `SYNTH_ADDER_TYPE="FA"` does not work.
   1. It is called before a Yosys `techmap` pass, so there are no `$fa` cells yet for SCL cells to map to.
   2. The [`fa_map.v`](https://github.com/fossi-foundation/open-pdks/blob/main/sky130/librelane/sky130_fd_sc_hd/fa_map.v) files
      in `open_pdks` do not do the mapping correctly.
      The [word-level cell `$fa`](https://yosyshq.readthedocs.io/projects/yosys/en/latest/cell/word_arith.html#arith.$fa)
      is supposed to handle a vector of instances, not a single gate cell.
   3. There are temporary variables `t*` left in all copies of `fa_map.v` files,
      indicating the code was not maintained much.
   4. `$fa` cells are only present in [Yosys `techlibs/common/techmap.v` `$alu` cell](https://github.com/YosysHQ/yosys/blob/main/techlibs/common/techmap.v#L292)
      (mapping `$alu` cells to a default `$fa and [$lcu Brent Kung adder](https://github.com/YosysHQ/yosys/blob/main/techlibs/common/techmap.v#L209-L255)).
      I am not entirely sure this interpretation is correct, I did not properly inspect the netlist yet.
      So the `$fa` mapping only works after Yosys passes `alumacc` and `techmap` are called.
   5. I am trying to write map files that would be able to implement RCA adders
      for incrementers/decrrementers (counters, timers, ...) using half adder cells (HA),
      I made some progress, but there are some issues with propagating constants during `techmap -map`.
   6. Instead of mapping just `$add` and `$sub`, it might be better to map `$alu` and `$macc`.
      Or even allow multiple mapping stages between passes `proc`/`alumacc`/`techmap`/...
   7. Currently mapping is global. To be able to map individual adders to different structures,
      something like attributes `assign sum = opa + (* map="RCA" *) opb;`
      combined with `select` filters could be used.
      The filter could be an attribute, a hierarchical path or something entirely custom.

6. `SYNTH_LATCH_MAP` could be handled automatically without a dedicated map file,
   using `dfflibmap` if my [PR for Yosys](https://github.com/YosysHQ/yosys/pull/5976) is accepted.
   With already merged improvements to the `dfflegalize` pass,
   additional LATCH types should be covered (those with preset/reset).
   1. There is also this [Yosys PR](https://github.com/YosysHQ/yosys/pull/5963)
      intended to update handling of undesired LATCH inference warnings/errors.
   In the future I would also like to look into mapping
   FF/LATCH cells with complementary outputs (`Q`/`QN`).

7. For the `clockgate` pass `SYNTH_CLOCKGATE_MIN_WIDTH` might be enough
   if Yosys is allowed to automatically select ICG cells from a Liberty file.
   Meaning `SYNTH_CLOCKGATE_POSEDGE_ICG` and `SYNTH_CLOCKGATE_NEGEDGE_ICG`
   would become redundant. I did not run any tests yet.
   A `-liberty` argument would have to be passed.

8. The `dfflibmap` pass inserts inverters for each FF/LATCH,
   where the polarity of set/reset/enable signals is different between RTL and a SCL cell.
   An additional `opt_merge` (not default in `opt`) step would recombine those inverters.
   For example a 32-bit register with an active high reset in RTL
   results in 32 extra inverters for `sky130` HD SCL.

8. Currently filtered (removing synthesis excluded cells) Liberty files are used for
   `dfflibmap`, ~`clockgate`~, `abc`.
   I tested an alternative using the `-dont_use` argument and it works.
   I used the `extra.json` file to pass the list created in `pyosys.py` to `synthesize.py`.
   I would like to propose to deprecate the current approach where the cell exclusions
   are separate files in `open_pdks` and instead have the exclusions
   as cell lists in `open_pdks` configuration `config.tcl`.

9. In additon to `-booth` there is now a [`arith_tree`](https://yosyshq.readthedocs.io/projects/yosys/en/latest/cmd/index_passes_techmap.html#arith-tree-convert-add-sub-macc-alu-chains-to-carry-save-adder-trees) pass in Yosys.

10. ABC might have better timing awareness if something like `-liberty_args "-G 250"`
    was used instead of `-D {clock_period}`.
    While researching recent PULP Platform projects I went through many issue reports
    mentioning issues with the current approach and solutions.
    I did not run any tests, since I have very limited ABC understanding,
    so this is just a placeholder for now.