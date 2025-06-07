//design code
module mux2to1(
  input x0,x1,
  input s,
  output out);
  assign out=s?x1:x0;
endmodule

module mux4to1(
  input x0,x1,x2,x3,
  input s1,s0,
  output out);
  assign out=s1?(s0?x3:x2):(s0?x1:x0);
endmodule

module mux8to1(
  input x0,x1,x2,x3,x4,x5,x6,x7,
  input s2,s1,s0,
  output out);
  wire a,b;
  
  mux4to1 m1(.s1(s2),.s0(s1),.x0(x0),.x1(x1),.x2(x2),.x3(x3),.out(a));
  mux4to1 m2(.s1(s2),.s0(s1),.x0(x4),.x1(x5),.x2(x6),.x3(x7),.out(b));
  mux2to1 m3(.s(s2),.x0(a),.x1(b),.out(out));
endmodule

//testbench code
module mux8to1_tb;

    reg s2, s1, s0;
    reg x0, x1, x2, x3, x4, x5, x6, x7;
    wire out;

    mux8to1 uut (.s2(s2),.s1(s1),.s0(s0),.x0(x0),.x1(x1),.x2(x2), .x3(x3),.x4(x4),.x5(x5),.x6(x6),.x7(x7),.out(out));
  initial begin
      {x0,x1,x2,x3,x4,x5,x6,x7} = 8'b10101011; 
    $monitor("S2=%b|S1=%b|S0=%b|Out=%b", s2, s1, s0, out);
        s2 = 0;s1=0;s0= 0; #10; 
        s2 = 0;s1=0;s0= 1; #10; 
        s2 = 0;s1=1;s0= 0; #10; 
        s2 = 0;s1=1;s0= 1; #10; 
        s2 = 1;s1=0;s0= 0; #10;  
        s2 = 1;s1=0;s0= 1; #10; 
        s2 = 1;s1=1;s0= 0; #10; 
        s2 = 1;s1=1;s0= 1; #10;
        $finish;
    end  
  initial begin
    $dumpfile("mux8to1.vcd");
    $dumpvars(1,mux8to1_tb);
  end
endmodule
