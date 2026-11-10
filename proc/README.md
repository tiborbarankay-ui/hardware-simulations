## Verilog Processor
A small multi-cycle processor built around a shared 8-bit tri-state bus, written in Verilog with a self-checking-style testbench. Completed as a project for Advanced Digital Logic and Verilog at Columbia University.

## Design
FSM: 12 states (Standby, Fetch, Dec, Load1, Move1, Add1-3, Sub1-3, Done). Asserting w starts an instruction and Done goes high when it finishes.
Bus: Tri-state buffers (trin) put R0-R3, G, or the external Data input on Buswires one at a time.
Registers: Parameterized, load-enabled registers (regn).
ALU: An adder/subtractor shared by Add and Sub. A holds the first operand, and the result is stored in G before being written back to Rx.

## Run with testbench
vlog proc.v proc_tb.v
vsim -c proc_tb -do "run -all; quit"
