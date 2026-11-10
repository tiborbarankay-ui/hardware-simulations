module trin(Y, E, F);
  parameter n = 8;
  input [n-1:0] Y;
  input E;
  output wire [n-1:0] F;
  
  assign F = E ? Y : 'bz;
endmodule

module regn(R, L, Clock, Q);
  parameter n = 8;
  input [n-1:0] R;
  input L, Clock;
  output reg [n-1:0] Q;
  
  always @(posedge Clock)
    if(L)
      Q <= R;

endmodule

module proc(
  input [7:0] Data,
  input reset, w, Clock,
  input [1:0] F, Rx, Ry,
  output wire [7:0] Buswires,
  output Done
);
  reg [0:3] Rin, Rout;
  wire AddSub, Extern, Ain, Gin, Gout;
  reg [7:0] Sum;
  wire [7:0] R0, R1, R2, R3, G, A;
  
  reg [3:0] y, Y;
  parameter [3:0] Standby = 0, Fetch = 1, Dec = 2, Load1 = 3, Move1 = 4, Add1 = 5, Add2 = 6, Add3 = 7, Sub1 = 8, Sub2 = 9, Sub3 = 10, Donest = 11;
  
  regn reg_0(Buswires, Rin[0], Clock, R0);
  regn reg_1(Buswires, Rin[1], Clock, R1);
  regn reg_2(Buswires, Rin[2], Clock, R2);
  regn reg_3(Buswires, Rin[3], Clock, R3);
  regn reg_A(Buswires, Ain, Clock, A);
  regn reg_G(Sum, Gin, Clock, G);

  
  trin tri_0(R0, Rout[0], Buswires);
  trin tri_1(R1, Rout[1], Buswires);
  trin tri_2(R2, Rout[2], Buswires);
  trin tri_3(R3, Rout[3], Buswires);
  trin tri_G(G, Gout, Buswires);
  trin tri_ext(Data, Extern, Buswires);
  
  always @(y, w, F)
    case (y)
      Standby: if (w) Y = Fetch; else Y = Standby;
      Fetch:   Y = Dec;
      Dec:
        case (F)
          2'b00: Y = Move1;
          2'b01: Y = Load1;
          2'b10: Y = Add1;
          2'b11: Y = Sub1;
        endcase
      Move1:  Y = Donest;
      Load1:  Y = Donest;
      Add1:   Y = Add2;
      Add2:   Y = Add3;
      Add3:   Y = Donest;
      Sub1:   Y = Sub2;
      Sub2:   Y = Sub3;
      Sub3:   Y = Donest;
      Donest: Y = Standby;
      default: Y = Standby;
    endcase
  
  always @(posedge Clock)
  	if (reset) y <= Standby;
  	else y <= Y;
  
  always @(y, Rx, Ry) begin
    Rin  = 4'b0000;
    Rout = 4'b0000;
    case (y)
      Move1: begin
        Rout[Ry] = 1'b1;
        Rin[Rx]  = 1'b1;
      end
      Load1: Rin[Rx] = 1'b1;
      Add1, Sub1: Rout[Rx] = 1'b1;
      Add2, Sub2: Rout[Ry] = 1'b1;
      Add3, Sub3: Rin[Rx]  = 1'b1;
    endcase
  end
  
  always @(AddSub, A, Buswires)
    if(!AddSub)
      Sum = A + Buswires;
  	else
      Sum = A - Buswires;

  assign Ain    = (y == Add1)  || (y == Sub1);
  assign Gin    = (y == Add2)  || (y == Sub2);
  assign Gout   = (y == Add3)  || (y == Sub3);
  assign AddSub = (y == Sub2);
  assign Extern = (y == Load1);
  assign Done   = (y == Donest);
  
endmodule
