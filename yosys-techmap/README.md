# ASIC arithmetic library for Yosys technology mapping

Mapping the following Yosys word-level cells is supported:

Unary operators

$logic_not
$neg

$reduce_and
$reduce_or
$reduce_xnor
$reduce_xor

Binary operators

$add
$sub
$mod
$modfloor

$div
$divfloor

$eq
$ne
$ge
$gt
$le
$lt

$mul
$pow

Multiplexers

$bmux
$bwmux
$demux
$mux
$pmux
$tribuf

Coarse arithmetics

$alu
$fa
$lcu
$macc
$macc_v2
