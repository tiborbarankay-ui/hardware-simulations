`timescale 1ns/1ps

module kitchtimer(
  input clk, M, S, STSP,
  output reg[5:0] min_reg, sec_reg,
  output reg sound,
);
  
  wire resetn;
  reg [2:0] y, Y;
  reg [6:0] count;
  reg count_e, D_min, D_sec, clr, clr_count;
  
  
  wire count_f = (count == 7'd99);
  wire zero = ((min_reg == 0) && (sec_reg == 0))
  assign resetn = ~(M & S);

  
  initial begin
    clk = 0;
  end
  
  always #5 clk = ~clk;
  
  parameter S1 = 3'b000, S2 = 3'b001, S3 = 3'b010;
  
  always @(S, y, M, STSP) begin
    case(y)
      S1:	if(resetn) Y = S2;
      else if(M) Y = S3;
      else if(S) Y = S4;
      else if(STSP) Y = S5;
      else Y = S1;
      
      S2: Y = S1;
      
      S3: Y = S1;
      
      S4: Y = S1;
      
      S5: if(STSP) Y = S1;
      else if(count_f == 1) Y = S6;
      else Y = S5;
      
      S6: if(zero) Y = S7;
      else Y = S5;
      
      S7: if(STSP) Y = S1;
      else Y = S7;
    endcase
  end
  
  always@(posedge clk, negedge resetn) begin
    if(resetn == 0) begin
      y <= S1;
    end else begin
      y <= Y;
    end
  end
  
  
  always@(y) begin
    clr = 0; clr_count = 0; inc_min = 0; count_e = 0;
    case(y):
      S1: clr_count = 1;
      
      S2: clr = 1;
      
      S3: inc_min = 1;
      
      S4: inc_sec = 1;
      
      S5: count_e = 1;
      
      S6: clr_count = 1;
  
  multi mult_min(min_reg, min_reg + 1, inc_min, D_min);
  base_reg reg_min(D_min, min_reg, clk, clr);
  
  multi mult_sec(sec_reg, sec_reg + 1, inc_sec, D_sec);
  base_reg reg_min(D_sec, sec_reg, clk, clr);
  
  counter base_counter(clr_count, count_e, clk, count);

  
  
  
  
  
    
    
    
    
endmodule
    
    
    
module base_reg(
  reg [5:0] D, Q;
  reg clk, clr;
);
  always@(posedge clk, posedge clr) begin
    if(clr) Q <= 0;
    else if(Q == 6'd59) Q <= 0;
    else Q <= D;
  end
endmodule

module multi(
  reg A, B, control, out
);
  always@(A, B, control) begin
    if(control) out <= B;
  	else out <= A;
  end
endmodule

module counter(
  reg clr, enable, clk,
  reg [6:0] out
);
  always@(posedge clk, posedge, clr) begin
    if(clr) out = 0;
    else if(enable) out++;
    else ;
  end
endmodule
  
      
  
