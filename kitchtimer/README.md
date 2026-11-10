## Kitchen Timer Verilog
A countdown kitchen timer written in Verilog, with a testbench. Completed as a project for Advanced Digital Logic and Verilog at Columbia University.
The timer holds minutes and seconds (each 0-59) and counts down to zero. Buttons set the time, a start/stop button runs it, and a sound output turns on when it reaches zero.

## Design
A 7-state FSM controls the timer:

State	Action
S1	Idle, waiting for a button
S2	Reset time to 0:00
S3	Increment minutes
S4	Increment seconds
S5	Counting, waiting for one second to elapse
S6	Decrement the time by one second
S7	Time is up, sound on until STSP is pressed
Datapath: Two 6-bit registers (base_reg) for minutes and seconds, multiplexers (multi) that choose between incrementing and decrementing, and a free-running counter (counter) that counts 100 clock cycles per second.
Rollover: Seconds and minutes wrap from 59 to 0 when incrementing, and decrementing seconds borrows from minutes (e.g., 1:00 becomes 0:59).
Reset: The FSM resets asynchronously when M and S are pressed together.
Start is ignored if the time is 0:00.

## Run with testbench
vlog kitchtimer.v kitchtimer_tb.v
vsim -c kitchtimer_tb -do "run -all; quit"
