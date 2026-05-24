# LibreLane `pm32` example

```sh
nix-shell .../librelane/shell.nix
```

To select a PKD version first use `ciel` to fetch/enable it:

```sh
ciel fetch  --pdk-family sky130 c95f23a75038d54d60ecc7ca060f53851f8f25e5
ciel enable --pdk-family sky130 c95f23a75038d54d60ecc7ca060f53851f8f25e5
ciel ls --pdk-family sky130
```

To build/enable a PDK which has already been committed to [open_pdks](),
but not yet published do:

```sh
ciel build --pdk-family sky130 e2f6d053cc04966ddb857a3cc0d101bff7654ffa
ciel enable --pdk-family sky130 e2f6d053cc04966ddb857a3cc0d101bff7654ffa
```

Somehow enabling a PDK using `ciel` does not persuade LibreLane to use it,
you also have to change the hash in the LibreLane file `librelane/pdk_hashes.yaml`.

To rebuild a local version of the library use:

```sh
ciel build --pdk-family sky130 e11f4c42613de5269371782324cca97762f67401 --use-repo-at open_pdks=../../PDK/open_pdks/ --use-repo-at sky130_fd_sc_hdll=../../PDK/skywater-pdk-libs-sky130_fd_sc_hdll/ -l all
```

It might be better to compile with `-l sky130_fd_sc_hdll` and without (to get defaults) to speed up the build.

First synthesize/place/route/... using LibreLane,
the results placed into the `runs/latest` folder.

```sh
librelane --run-tag latest config.json
librelane --run-tag latest_sky130_fd_sc_hd --scl sky130_fd_sc_hd config.json
librelane --run-tag latest_sky130_fd_sc_hdll --scl sky130_fd_sc_hdll config.json
librelane --run-tag latest_sky130_fd_sc_hs --scl sky130_fd_sc_hs config.json
librelane --run-tag latest_sky130_fd_sc_ms --scl sky130_fd_sc_ms config.json
librelane --run-tag latest_sky130_fd_sc_ls --scl sky130_fd_sc_ls config.json
librelane --run-tag latest_sky130_fd_sc_lp --scl sky130_fd_sc_lp config.json
```

The interconnect and PVT corners are a variable in the `test.sh` file.
The tests (RTL and netlist simulation) can be run using `cvc` (not working), `questa` or `iverilog` (default).
The main output for the test is a VCD file of a netlist simulation annotated with a SDF for a given corner.

```sh
./test.sh --sim iverilog --pdk ~/.ciel/sky130A --scl sky130_fd_sc_hd --run runs/latest_sky130_fd_sc_hd --interconnect nom --corner tt_025C_1v80 --cells sky130_fd_sc_hd.v
./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_hd --run runs/latest_sky130_fd_sc_hd --interconnect nom --corner tt_025C_1v80 --cells sky130_fd_sc_hd.v

./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_hdll --run runs/latest_sky130_fd_sc_hdll --interconnect nom --corner tt_025C_1v80

./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_hs --run runs/latest_sky130_fd_sc_hs --interconnect nom --corner tt_025C_1v80
./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_ms --run runs/latest_sky130_fd_sc_ms --interconnect nom --corner tt_025C_1v80
./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_ls --run runs/latest_sky130_fd_sc_ls --interconnect nom --corner tt_025C_1v80

```

The script also creates an OpenSTA TCL script.

```sh
sta opensta_power.tcl
```

 ── 1e931c9417df0478df9ee6b7289202f3e87440ab (2026.05.06)
├── d815bb30c9afdf9e264c276a8a2b533108dea3d0 (2026.04.27)
├── 78f0ccbb45a0d560890540a1ebc5ccf4d8370c70 (2026.04.24) (enabled)
├── c95f23a75038d54d60ecc7ca060f53851f8f25e5 (2026.04.18)
├── 7b70722e33c03fcb5dabcf4d479fb0822d9251c9 (2026.03.01)
├── 54435919abffb937387ec956209f9cf5fd2dfbee (2025.12.26)
├── d400e26845538beaeb7cc5fdb9bfc06c30ea27cb (2025.12.12)
├── 3c1a32a2e05bfbe3311ed348e60435f0a3468ef0 (2025.12.08)
├── 8fa792c6f7db44c0873c619d62190496b89c0083 (2025.11.28)
├── 486fb8633c3d95ae475a5ccd68d0066c25919bb5 (2025.11.22)
├── 0da75e73164cb90ca1eb1cab4803922e384e2b9d (2025.11.21)
├── bb7007987f46dc9708c7b1b15e7d8a663e6a80d9 (2025.11.11)
├── dd64ab492bca7e7a93f5a673351a239e87697ebc (2025.11.11)
├── ef86633d7da8a9f270811931222075ada05d6ef9 (2025.11.07)
├── 9608f38a18c41de49402a7b91daaed6b69317398 (2025.11.04)
├── 8f2d1529c86235d726979eb9ecb7e9628108590b (2025.10.20)
├── e3262351fb1f5a3cc262ced1c76ebe3f2a5218fb (2025.10.15)
├── 6971617b18b2f322d8f574af7e53f79ddd75dafe (2025.10.01)
├── d56f8a8ea0f9171cbdc5273035907b93f3f3bed7 (2025.09.30)
├── 0536d02d875c8f67dd7cca3902ac457e62f20005 (2025.09.28)
├── ff08c23db8359afce3f134c454e7930586d0641c (2025.09.25)
├── 8283f1a6a695a5b41f6aea468385ced78c7a934e (2025.09.23)
├── a80ed405766c5d4f21c8bfca84552a7478fe75b2 (2025.09.16)
├── 426f95115110d6d0185f1ba3d09b3aa8a014969b (2025.09.10)
├── d12db87685f4c8859f9296f84e85a48707e249a0 (2025.09.05)
├── 4d004a98790dbffee2f4c725606ca580495921b4 (2025.09.02)
├── f4731948ed7bb478ce2f822499bc65d8058e7a99 (2025.08.31)
├── 40cee970d8a9b7eaea35a34fe7d6068f05721f0a (2025.08.20)
├── bb0ba76993fbea9cad2298a35d3c99723ad2bb62 (2025.08.20)
├── a492ff787163f93ce9ebc382b23c58c0de33afa3 (2025.08.12)
├── 9d590c97000f7992c75e040d0c2b4f2bee977cdb (2025.07.20)
├── 8afc8346a57fe1ab7934ba5a6056ea8b43078e71 (2025.07.14)
├── 823ec23c421cfb1d6aec06b8140cbde11cbc95a0 (2025.05.24)
├── 18dbe6102a36303bb8942b490efb0f33d2815bdb (2025.05.11)


-rw-rw-r-- 1 izi izi 12841794 Apr 30 15:13 sky130_fd_sc_hd__ff_100C_1v65.lib
-rw-rw-r-- 1 izi izi 12842685 Apr 30 15:13 sky130_fd_sc_hd__ff_100C_1v95.lib
-rw-rw-r-- 1 izi izi 12843237 Apr 30 15:13 sky130_fd_sc_hd__ff_n40C_1v56.lib
-rw-rw-r-- 1 izi izi 12844108 Apr 30 15:13 sky130_fd_sc_hd__ff_n40C_1v65.lib
-rw-rw-r-- 1 izi izi 12844986 Apr 30 15:13 sky130_fd_sc_hd__ff_n40C_1v76.lib
-rw-rw-r-- 1 izi izi 12918504 Apr 30 15:13 sky130_fd_sc_hd__ff_n40C_1v95.lib
-rw-rw-r-- 1 izi izi 26214198 Apr 30 15:13 sky130_fd_sc_hd__ff_n40C_1v95_ccsnoise.lib
-rw-rw-r-- 1 izi izi 12847083 Apr 30 15:13 sky130_fd_sc_hd__ss_100C_1v40.lib
-rw-rw-r-- 1 izi izi 12845260 Apr 30 15:13 sky130_fd_sc_hd__ss_100C_1v60.lib
-rw-rw-r-- 1 izi izi 12838331 Apr 30 15:13 sky130_fd_sc_hd__ss_n40C_1v28.lib
-rw-rw-r-- 1 izi izi 12844282 Apr 30 15:13 sky130_fd_sc_hd__ss_n40C_1v35.lib
-rw-rw-r-- 1 izi izi 12845465 Apr 30 15:13 sky130_fd_sc_hd__ss_n40C_1v40.lib
-rw-rw-r-- 1 izi izi 12842498 Apr 30 15:13 sky130_fd_sc_hd__ss_n40C_1v44.lib
-rw-rw-r-- 1 izi izi 12916754 Apr 30 15:13 sky130_fd_sc_hd__ss_n40C_1v60.lib
-rw-rw-r-- 1 izi izi 26214006 Apr 30 15:13 sky130_fd_sc_hd__ss_n40C_1v60_ccsnoise.lib
-rw-rw-r-- 1 izi izi 12839708 Apr 30 15:13 sky130_fd_sc_hd__ss_n40C_1v76.lib
-rw-rw-r-- 1 izi izi 12841637 Apr 30 15:13 sky130_fd_sc_hd__tt_025C_1v80.lib
-rw-rw-r-- 1 izi izi 12840460 Apr 30 15:13 sky130_fd_sc_hd__tt_100C_1v80.lib

-rw-rw-r-- 1 izi izi 17168187 Apr 29 22:24 sky130_fd_sc_hdll__ff_100C_1v65.lib
-rw-rw-r-- 1 izi izi 17169467 Apr 29 22:24 sky130_fd_sc_hdll__ff_100C_1v95.lib
-rw-rw-r-- 1 izi izi 16761919 Apr 29 22:24 sky130_fd_sc_hdll__ff_n40C_1v56.lib
-rw-rw-r-- 1 izi izi 17170888 Apr 29 22:24 sky130_fd_sc_hdll__ff_n40C_1v65.lib
-rw-rw-r-- 1 izi izi 17178915 Apr 29 22:24 sky130_fd_sc_hdll__ff_n40C_1v95.lib
-rw-rw-r-- 1 izi izi 26214202 Apr 29 22:24 sky130_fd_sc_hdll__ff_n40C_1v95_ccsnoise.lib
-rw-rw-r-- 1 izi izi 17162306 Apr 29 22:24 sky130_fd_sc_hdll__ss_100C_1v60.lib
-rw-rw-r-- 1 izi izi 16753355 Apr 29 22:24 sky130_fd_sc_hdll__ss_n40C_1v28.lib
-rw-rw-r-- 1 izi izi 16762156 Apr 29 22:24 sky130_fd_sc_hdll__ss_n40C_1v44.lib
-rw-rw-r-- 1 izi izi 17166740 Apr 29 22:24 sky130_fd_sc_hdll__ss_n40C_1v60.lib
-rw-rw-r-- 1 izi izi 26214289 Apr 29 22:24 sky130_fd_sc_hdll__ss_n40C_1v60_ccsnoise.lib
-rw-rw-r-- 1 izi izi 16758984 Apr 29 22:24 sky130_fd_sc_hdll__ss_n40C_1v76.lib
-rw-rw-r-- 1 izi izi 17168853 Apr 29 22:24 sky130_fd_sc_hdll__tt_025C_1v80.lib

-rw-rw-r-- 1 izi izi 26214365 Apr 30 14:51 sky130_fd_sc_hs__ff_100C_1v95.lib
-rw-rw-r-- 1 izi izi 26214386 Apr 30 14:51 sky130_fd_sc_hs__ff_150C_1v95.lib
-rw-rw-r-- 1 izi izi 26214087 Apr 30 14:51 sky130_fd_sc_hs__ff_n40C_1v56.lib
-rw-rw-r-- 1 izi izi 26214360 Apr 30 14:51 sky130_fd_sc_hs__ff_n40C_1v76.lib
-rw-rw-r-- 1 izi izi 26214350 Apr 30 14:51 sky130_fd_sc_hs__ff_n40C_1v95.lib
-rw-rw-r-- 1 izi izi 26214354 Apr 30 14:51 sky130_fd_sc_hs__ff_n40C_1v95_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214315 Apr 30 14:51 sky130_fd_sc_hs__ss_100C_1v60.lib
-rw-rw-r-- 1 izi izi 26214391 Apr 30 14:51 sky130_fd_sc_hs__ss_150C_1v60.lib
-rw-rw-r-- 1 izi izi 26214248 Apr 30 14:51 sky130_fd_sc_hs__ss_n40C_1v28.lib
-rw-rw-r-- 1 izi izi 26214173 Apr 30 14:51 sky130_fd_sc_hs__ss_n40C_1v44.lib
-rw-rw-r-- 1 izi izi 26214216 Apr 30 14:51 sky130_fd_sc_hs__ss_n40C_1v60.lib
-rw-rw-r-- 1 izi izi 26214221 Apr 30 14:51 sky130_fd_sc_hs__ss_n40C_1v60_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214124 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v20.lib
-rw-rw-r-- 1 izi izi 26214237 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v35.lib
-rw-rw-r-- 1 izi izi 26214144 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v44.lib
-rw-rw-r-- 1 izi izi 26214251 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v50.lib
-rw-rw-r-- 1 izi izi 26214245 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v62.lib
-rw-rw-r-- 1 izi izi 26214316 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v68.lib
-rw-rw-r-- 1 izi izi 26214292 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v80.lib
-rw-rw-r-- 1 izi izi 26214204 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v80_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214389 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_1v89.lib
-rw-rw-r-- 1 izi izi 26214340 Apr 30 14:51 sky130_fd_sc_hs__tt_025C_2v10.lib
-rw-rw-r-- 1 izi izi 26214357 Apr 30 14:51 sky130_fd_sc_hs__tt_100C_1v80.lib
-rw-rw-r-- 1 izi izi 26214342 Apr 30 14:51 sky130_fd_sc_hs__tt_150C_1v80.lib

-rw-rw-r-- 1 izi izi 26214206 Apr 30 15:04 sky130_fd_sc_ms__ff_085C_1v95_pwrlkg.lib
-rw-rw-r-- 1 izi izi 26214260 Apr 30 15:04 sky130_fd_sc_ms__ff_100C_1v65.lib
-rw-rw-r-- 1 izi izi 26214276 Apr 30 15:04 sky130_fd_sc_ms__ff_100C_1v95.lib
-rw-rw-r-- 1 izi izi 26214250 Apr 30 15:04 sky130_fd_sc_ms__ff_100C_1v95_pwrlkg.lib
-rw-rw-r-- 1 izi izi 26214312 Apr 30 15:04 sky130_fd_sc_ms__ff_150C_1v95.lib
-rw-rw-r-- 1 izi izi 26214180 Apr 30 15:04 sky130_fd_sc_ms__ff_n40C_1v56.lib
-rw-rw-r-- 1 izi izi 26214181 Apr 30 15:04 sky130_fd_sc_ms__ff_n40C_1v65_ka1v76.lib
-rw-rw-r-- 1 izi izi 26214170 Apr 30 15:04 sky130_fd_sc_ms__ff_n40C_1v76.lib
-rw-rw-r-- 1 izi izi 26213941 Apr 30 15:04 sky130_fd_sc_ms__ff_n40C_1v95.lib
-rw-rw-r-- 1 izi izi 26214312 Apr 30 15:04 sky130_fd_sc_ms__ff_n40C_1v95_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214293 Apr 30 15:04 sky130_fd_sc_ms__ff_n40C_1v95_pwrlkg.lib
-rw-rw-r-- 1 izi izi 26214351 Apr 30 15:04 sky130_fd_sc_ms__ss_100C_1v60.lib
-rw-rw-r-- 1 izi izi 26214343 Apr 30 15:04 sky130_fd_sc_ms__ss_150C_1v60.lib
-rw-rw-r-- 1 izi izi 26214229 Apr 30 15:04 sky130_fd_sc_ms__ss_n40C_1v28.lib
-rw-rw-r-- 1 izi izi 26214081 Apr 30 15:04 sky130_fd_sc_ms__ss_n40C_1v44.lib
-rw-rw-r-- 1 izi izi 26214214 Apr 30 15:04 sky130_fd_sc_ms__ss_n40C_1v60.lib
-rw-rw-r-- 1 izi izi 26214156 Apr 30 15:04 sky130_fd_sc_ms__ss_n40C_1v60_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214120 Apr 30 15:04 sky130_fd_sc_ms__tt_025C_1v80.lib
-rw-rw-r-- 1 izi izi 26214345 Apr 30 15:04 sky130_fd_sc_ms__tt_025C_1v80_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214389 Apr 30 15:04 sky130_fd_sc_ms__tt_100C_1v80.lib

-rw-rw-r-- 1 izi izi 26214349 Apr 30 15:10 sky130_fd_sc_ls__ff_085C_1v95.lib
-rw-rw-r-- 1 izi izi 26214292 Apr 30 15:10 sky130_fd_sc_ls__ff_100C_1v65_dest1v76_destvpb1v76_ka1v76.lib
-rw-rw-r-- 1 izi izi 26214374 Apr 30 15:10 sky130_fd_sc_ls__ff_100C_1v95.lib
-rw-rw-r-- 1 izi izi 26214285 Apr 30 15:10 sky130_fd_sc_ls__ff_150C_1v95.lib
-rw-rw-r-- 1 izi izi 26214371 Apr 30 15:10 sky130_fd_sc_ls__ff_n40C_1v56.lib
-rw-rw-r-- 1 izi izi 26214188 Apr 30 15:10 sky130_fd_sc_ls__ff_n40C_1v65_dest1v76_destvpb1v76_ka1v76.lib
-rw-rw-r-- 1 izi izi 26214324 Apr 30 15:10 sky130_fd_sc_ls__ff_n40C_1v76.lib
-rw-rw-r-- 1 izi izi 26214195 Apr 30 15:10 sky130_fd_sc_ls__ff_n40C_1v95.lib
-rw-rw-r-- 1 izi izi 26214235 Apr 30 15:10 sky130_fd_sc_ls__ff_n40C_1v95_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214349 Apr 30 15:10 sky130_fd_sc_ls__ss_100C_1v40.lib
-rw-rw-r-- 1 izi izi 26214269 Apr 30 15:10 sky130_fd_sc_ls__ss_100C_1v60.lib
-rw-rw-r-- 1 izi izi 26214365 Apr 30 15:10 sky130_fd_sc_ls__ss_150C_1v60.lib
-rw-rw-r-- 1 izi izi 26214224 Apr 30 15:10 sky130_fd_sc_ls__ss_n40C_1v28.lib
-rw-rw-r-- 1 izi izi 26214266 Apr 30 15:10 sky130_fd_sc_ls__ss_n40C_1v35.lib
-rw-rw-r-- 1 izi izi 26214277 Apr 30 15:10 sky130_fd_sc_ls__ss_n40C_1v40.lib
-rw-rw-r-- 1 izi izi 26214183 Apr 30 15:10 sky130_fd_sc_ls__ss_n40C_1v44.lib
-rw-rw-r-- 1 izi izi 26214236 Apr 30 15:10 sky130_fd_sc_ls__ss_n40C_1v60.lib
-rw-rw-r-- 1 izi izi 26214388 Apr 30 15:10 sky130_fd_sc_ls__ss_n40C_1v60_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214399 Apr 30 15:10 sky130_fd_sc_ls__ss_n40C_1v76.lib
-rw-rw-r-- 1 izi izi 26214261 Apr 30 15:10 sky130_fd_sc_ls__tt_025C_1v80.lib
-rw-rw-r-- 1 izi izi 26214240 Apr 30 15:10 sky130_fd_sc_ls__tt_025C_1v80_ccsnoise.lib
-rw-rw-r-- 1 izi izi 26214259 Apr 30 15:10 sky130_fd_sc_ls__tt_100C_1v80.lib

-rw-rw-r-- 1 izi izi 26214121 Apr 29 22:22 sky130_fd_sc_lp__ff_100C_1v95.lib
-rw-rw-r-- 1 izi izi 26214284 Apr 29 22:22 sky130_fd_sc_lp__ff_125C_3v15.lib
-rw-rw-r-- 1 izi izi 26214051 Apr 29 22:22 sky130_fd_sc_lp__ff_140C_1v95.lib
-rw-rw-r-- 1 izi izi 26214251 Apr 29 22:22 sky130_fd_sc_lp__ff_150C_2v05.lib
-rw-rw-r-- 1 izi izi 26214317 Apr 29 22:22 sky130_fd_sc_lp__ff_n40C_1v56.lib
-rw-rw-r-- 1 izi izi 26214374 Apr 29 22:22 sky130_fd_sc_lp__ff_n40C_1v76.lib
-rw-rw-r-- 1 izi izi 26214201 Apr 29 22:22 sky130_fd_sc_lp__ff_n40C_1v95.lib
-rw-rw-r-- 1 izi izi 26214186 Apr 29 22:22 sky130_fd_sc_lp__ff_n40C_2v05.lib
-rw-rw-r-- 1 izi izi 26214247 Apr 29 22:22 sky130_fd_sc_lp__ss_100C_1v60.lib
-rw-rw-r-- 1 izi izi 26214342 Apr 29 22:22 sky130_fd_sc_lp__ss_140C_1v65.lib
-rw-rw-r-- 1 izi izi 26214386 Apr 29 22:22 sky130_fd_sc_lp__ss_150C_1v65.lib
-rw-rw-r-- 1 izi izi 26214376 Apr 29 22:22 sky130_fd_sc_lp__ss_n40C_1v55.lib
-rw-rw-r-- 1 izi izi 26214197 Apr 29 22:22 sky130_fd_sc_lp__ss_n40C_1v60.lib
-rw-rw-r-- 1 izi izi 26214298 Apr 29 22:22 sky130_fd_sc_lp__ss_n40C_1v65.lib

-rw-rw-r-- 1 izi izi  7200150 May  4 12:12 sky130_fd_sc_hvl__ff_085C_5v50.lib
-rw-rw-r-- 1 izi izi   157402 May  4 12:12 sky130_fd_sc_hvl__ff_085C_5v50_lv1v95.lib
-rw-rw-r-- 1 izi izi  3514461 May  4 12:12 sky130_fd_sc_hvl__ff_100C_5v50.lib
-rw-rw-r-- 1 izi izi   158872 May  4 12:12 sky130_fd_sc_hvl__ff_100C_5v50_lowhv1v65_lv1v95.lib
-rw-rw-r-- 1 izi izi   156962 May  4 12:12 sky130_fd_sc_hvl__ff_100C_5v50_lv1v95.lib
-rw-rw-r-- 1 izi izi  3100626 May  4 12:12 sky130_fd_sc_hvl__ff_150C_5v50.lib
-rw-rw-r-- 1 izi izi   156924 May  4 12:12 sky130_fd_sc_hvl__ff_150C_5v50_lv1v95.lib
-rw-rw-r-- 1 izi izi  6268527 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_4v40.lib
-rw-rw-r-- 1 izi izi   156980 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_4v40_lv1v95.lib
-rw-rw-r-- 1 izi izi  6267461 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_4v95.lib
-rw-rw-r-- 1 izi izi   156968 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_4v95_lv1v95.lib
-rw-rw-r-- 1 izi izi  6085780 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_5v50.lib
-rw-rw-r-- 1 izi izi 16485700 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_5v50_ccsnoise.lib
-rw-rw-r-- 1 izi izi   158894 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_5v50_lowhv1v65_lv1v95.lib
-rw-rw-r-- 1 izi izi   166236 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_5v50_lv1v95.lib
-rw-rw-r-- 1 izi izi   776051 May  4 12:12 sky130_fd_sc_hvl__ff_n40C_5v50_lv1v95_ccsnoise.lib
-rw-rw-r-- 1 izi izi   158870 May  4 12:12 sky130_fd_sc_hvl__hvff_lvss_100C_5v50_lowhv1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi   163578 May  4 12:12 sky130_fd_sc_hvl__hvff_lvss_100C_5v50_lv1v40.lib
-rw-rw-r-- 1 izi izi   157410 May  4 12:12 sky130_fd_sc_hvl__hvff_lvss_100C_5v50_lv1v60.lib
-rw-rw-r-- 1 izi izi   158892 May  4 12:12 sky130_fd_sc_hvl__hvff_lvss_n40C_5v50_lowhv1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi   161946 May  4 12:12 sky130_fd_sc_hvl__hvff_lvss_n40C_5v50_lv1v35.lib
-rw-rw-r-- 1 izi izi   157506 May  4 12:12 sky130_fd_sc_hvl__hvff_lvss_n40C_5v50_lv1v60.lib
-rw-rw-r-- 1 izi izi   157328 May  4 12:12 sky130_fd_sc_hvl__hvss_lvff_100C_1v65.lib
-rw-rw-r-- 1 izi izi   157353 May  4 12:12 sky130_fd_sc_hvl__hvss_lvff_100C_1v95.lib
-rw-rw-r-- 1 izi izi   158811 May  4 12:12 sky130_fd_sc_hvl__hvss_lvff_100C_1v95_lowhv1v65.lib
-rw-rw-r-- 1 izi izi   158873 May  4 12:12 sky130_fd_sc_hvl__hvss_lvff_100C_5v50_lowhv1v65_lv1v95.lib
-rw-rw-r-- 1 izi izi   157310 May  4 12:12 sky130_fd_sc_hvl__hvss_lvff_n40C_1v65.lib
-rw-rw-r-- 1 izi izi   157372 May  4 12:12 sky130_fd_sc_hvl__hvss_lvff_n40C_1v95.lib
-rw-rw-r-- 1 izi izi   158811 May  4 12:12 sky130_fd_sc_hvl__hvss_lvff_n40C_1v95_lowhv1v65.lib
-rw-rw-r-- 1 izi izi   158879 May  4 12:12 sky130_fd_sc_hvl__hvss_lvff_n40C_5v50_lowhv1v65_lv1v95.lib
-rw-rw-r-- 1 izi izi  2812387 May  4 12:12 sky130_fd_sc_hvl__ss_100C_1v65.lib
-rw-rw-r-- 1 izi izi   163572 May  4 12:12 sky130_fd_sc_hvl__ss_100C_1v65_lv1v40.lib
-rw-rw-r-- 1 izi izi   157281 May  4 12:12 sky130_fd_sc_hvl__ss_100C_1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi  6456233 May  4 12:12 sky130_fd_sc_hvl__ss_100C_1v95.lib
-rw-rw-r-- 1 izi izi   159565 May  4 12:12 sky130_fd_sc_hvl__ss_100C_2v40_lowhv1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi   159580 May  4 12:12 sky130_fd_sc_hvl__ss_100C_2v70_lowhv1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi  2889236 May  4 12:12 sky130_fd_sc_hvl__ss_100C_3v00.lib
-rw-rw-r-- 1 izi izi   160741 May  4 12:12 sky130_fd_sc_hvl__ss_100C_3v00_lowhv1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi   158812 May  4 12:12 sky130_fd_sc_hvl__ss_100C_5v50_lowhv1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi  2813758 May  4 12:12 sky130_fd_sc_hvl__ss_150C_1v65.lib
-rw-rw-r-- 1 izi izi   157289 May  4 12:12 sky130_fd_sc_hvl__ss_150C_1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi   158852 May  4 12:12 sky130_fd_sc_hvl__ss_150C_3v00_lowhv1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi  4694266 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v32.lib
-rw-rw-r-- 1 izi izi   163491 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v32_lv1v28.lib
-rw-rw-r-- 1 izi izi  4714773 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v49.lib
-rw-rw-r-- 1 izi izi   163514 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v49_lv1v44.lib
-rw-rw-r-- 1 izi izi  4080762 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v65.lib
-rw-rw-r-- 1 izi izi 14538114 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v65_ccsnoise.lib
-rw-rw-r-- 1 izi izi   163570 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v65_lv1v35.lib
-rw-rw-r-- 1 izi izi   163569 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v65_lv1v40.lib
-rw-rw-r-- 1 izi izi   163581 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi   726502 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v65_lv1v60_ccsnoise.lib
-rw-rw-r-- 1 izi izi  6456908 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_1v95.lib
-rw-rw-r-- 1 izi izi   158806 May  4 12:12 sky130_fd_sc_hvl__ss_n40C_5v50_lowhv1v65_lv1v60.lib
-rw-rw-r-- 1 izi izi   156891 May  4 12:12 sky130_fd_sc_hvl__tt_025C_2v64_lv1v80.lib
-rw-rw-r-- 1 izi izi   156917 May  4 12:12 sky130_fd_sc_hvl__tt_025C_2v97_lv1v80.lib
-rw-rw-r-- 1 izi izi  6473408 May  4 12:12 sky130_fd_sc_hvl__tt_025C_3v30.lib
-rw-rw-r-- 1 izi izi   158664 May  4 12:12 sky130_fd_sc_hvl__tt_025C_3v30_lv1v80.lib
-rw-rw-r-- 1 izi izi  3054937 May  4 12:12 sky130_fd_sc_hvl__tt_100C_3v30.lib
-rw-rw-r-- 1 izi izi   156923 May  4 12:12 sky130_fd_sc_hvl__tt_100C_3v30_lv1v80.lib
-rw-rw-r-- 1 izi izi   156921 May  4 12:12 sky130_fd_sc_hvl__tt_150C_3v30_lv1v80.lib
