//design code
module mux2to1(
  input s,
  input x0,x1,
  output y);
  assign y=(s)?x1:x0;
endmodule

module mux4to1(
  input s1,s0,
  input x0,x1,x2,x3,
  output y);
  assign y=s1?(s0?x3:x1):(s0?x2:x0);
endmodule

module mux8to1(
  input s2,s1,s0,
  input x0,x1,x2,x3,x4,x5,x6,x7,
  output y);
  wire a,b;
  
  mux4to1 m1(.s1(s2),.s0(s1),.x0(x0),.x1(x1),.x2(x2),.x3(x3),.y(a));
  mux4to1 m2(.s1(s2),.s0(s1),.x0(x3),.x1(x4),.x2(x5),.x3(x6),.y(b));
  mux2to1 m3(.s(s0),.x0(a),.x1(b),.y(y));
endmodule

//testbench code
`timescale 1ns / 1ps

module mux8to1_tb;

    reg s2, s1, s0;
    reg x0, x1, x2, x3, x4, x5, x6, x7;
    wire y;

    mux8to1 uut (
        .s2(s2), .s1(s1), .s0(s0),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .y(y)
    );
  initial begin
      {x0,x1,x2,x3,x4,x5,x6,x7} = 8'b10101011; 
      $monitor("S2=%b|S1=%b|S0=%b|Y=%b", s2, s1, s0, y);
        s2 = 0; s1 = 0; s0 = 0; #10; 
        s2 = 0; s1 = 0; s0 = 1; #10; 
        s2 = 0; s1 = 1; s0 = 0; #10; 
        s2 = 0; s1 = 1; s0 = 1; #10; 
        s2 = 1; s1 = 0; s0 = 0; #10;  
        s2 = 1; s1 = 0; s0 = 1; #10; 
        s2 = 1; s1 = 1; s0 = 0; #10; 
        s2 = 1; s1 = 1; s0 = 1; #10;
        $finish;
    end
  
  initial begin
    $dumpfile("mux8to1.vcd");
    $dumpvars(1,mux8to1_tb);
  end
  

endmodule
