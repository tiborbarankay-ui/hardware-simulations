## Basic Verilog ALU
This is a basic ALU in verilog with 8 different operations I designed myself

## Testbench
The corresponding testbench is written in SystemVerilog and takes 20 different pairs of input values and checks each of them agains each of the 8 operations for 160 test runs

## Simulation
Simulations can be run with ModelSim: vlog simple_alu.v simple_alu_tb.sv; run -all
