`timescale 1ms / 100us
module kitchtimer_tb;

  reg clk = 0, M = 0, S = 0, STSP = 0;
  wire [5:0] min_reg, sec_reg;
  wire sound;

  kitchtimer dut (.clk(clk), .M(M), .S(S), .STSP(STSP),
                  .min_reg(min_reg), .sec_reg(sec_reg), .sound(sound));

  always #5 clk = ~clk; 
  
  integer i;

  task pulse_S;
    begin
      S = 1;
      @(posedge clk);
      #1;
      S = 0;
      @(posedge clk);
      #1;
    end
  endtask

  task pulse_M;
    begin
      M = 1;
      @(posedge clk);
      #1;
      M = 0;
      @(posedge clk);
      #1;
    end
  endtask

  task pulse_STSP;
    begin
      STSP = 1;
      @(posedge clk);
      #1;
      STSP = 0;
      @(posedge clk);
      #1;
    end
  endtask

  task pulse_both;
    begin
      M = 1;
      S = 1;
      @(posedge clk);
      #1;
      M = 0;
      S = 0;
      @(posedge clk);
      #1;
    end
  endtask

  initial begin
    @(posedge clk);
    #1;

    pulse_both;
    $display("After reset: %0d:%0d (expect 0:0)", min_reg, sec_reg);

    for (i = 1; i <= 60; i = i + 1) begin
      pulse_S;
      $display("S press %0d: sec=%0d", i, sec_reg);
    end

    for (i = 1; i <= 5; i = i + 1) begin
      pulse_M;
      $display("M press %0d: min=%0d", i, min_reg);
    end

    pulse_both;
    $display("After reset: %0d:%0d (expect 0:0)", min_reg, sec_reg);

    for (i = 0; i < 3; i = i + 1) begin
      pulse_S;
    end
    pulse_STSP;
    repeat (350) @(posedge clk);
    $display("After countdown: %0d:%0d sound=%b (expect 0:0, 1)", min_reg, sec_reg, sound);

    pulse_STSP;
    $display("After stop: sound=%b (expect 0)", sound);

    pulse_M;
    pulse_STSP;
    repeat (110) @(posedge clk);
    $display("Borrow test: %0d:%0d (expect 0:59)", min_reg, sec_reg);

    $finish;
  end
endmodule
