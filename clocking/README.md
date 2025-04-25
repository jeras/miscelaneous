# SystemVerilog clocking

## DOULOS example

https://www.doulos.com/knowhow/systemverilog/systemverilog-tutorials/systemverilog-clocking-tutorial/

Running the testbench (can add the `-gui` option to open the GUI):

```sh
qrun -makelib work -sv DOULOS/*.sv -end -top Test_Counter
qrun -makelib work -sv DOULOS/*.sv -end -top Test_Counter_w_clocking
```

## ChipVerify example

https://www.chipverify.com/systemverilog/systemverilog-clocking-blocks-part2

```sh
qrun -makelib work -sv chipverify/*.sv -end -top tb
```

## TCB

```sh
qrun -makelib work -sv tcb/*.sv -end -top tcb_tb
```
