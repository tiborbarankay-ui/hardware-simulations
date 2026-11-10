module proc_tb;
  reg clock, reset, w;
  reg [1:0] F, Rx, Ry;
  reg [7:0] Data;
  wire [7:0] Buswires;
  wire Done;

  proc dut (
    .Data(Data), .reset(reset), .w(w), .Clock(clock),
    .F(F), .Rx(Rx), .Ry(Ry),
    .Buswires(Buswires), .Done(Done)
  );

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  task do_instr(input [1:0] f, input [1:0] rx, input [1:0] ry, input [7:0] data);
    begin
      F = f; Rx = rx; Ry = ry; Data = data;
      @(negedge clock);
      w = 1;
      @(negedge clock);
      w = 0;
      while (!Done) @(negedge clock);
      @(negedge clock);
    end
  endtask

  initial begin
    reset = 1; w = 0; F = 0; Rx = 0; Ry = 0; Data = 0;
    @(negedge clock);
    reset = 0;

    do_instr(2'b01, 2'b00, 2'b00, 8'h05);
    $display("After Load R0: R0 = %h (expected 05)", dut.R0);

    do_instr(2'b01, 2'b01, 2'b00, 8'h03);
    $display("After Load R1: R1 = %h (expected 03)", dut.R1);

    do_instr(2'b00, 2'b10, 2'b00, 8'h00);
    $display("After Move R2:=R0: R2 = %h (expected 05)", dut.R2);

    do_instr(2'b10, 2'b00, 2'b01, 8'h00);
    $display("After Add R0:=R0+R1: R0 = %h (expected 08)", dut.R0);

    do_instr(2'b11, 2'b10, 2'b01, 8'h00);
    $display("After Sub R2:=R2-R1: R2 = %h (expected 02)", dut.R2);

    $display("Testbench complete.");
    $finish;
  end
endmodule
