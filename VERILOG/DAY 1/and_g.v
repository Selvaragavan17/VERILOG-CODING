// Design code
module and_g(a,b,y);
  input a,b;
  output y;
  and(y,a,b);
endmodule

//Testbench
module and_gtb;
  reg a,b;
  wire y;
  and_g uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("and_g.vcd");
    $dumpvars(1,and_gtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule
