//Design code
module or_b(a,b,y);
  input a,b;
  output reg y;
  always@(*)
    if(a|b)
      y=1'b1;
    else
      y=1'b0;
endmodule

//Testbench
module or_btb;
  reg a,b;
  wire y;
  or_b uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("or_b.vcd");
    $dumpvars(1,or_btb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule

//datalflow
//Design code
module or_d(a,b,y);
  input a,b;
  output y;
  or(y,a,b);
endmodule

//Testbench
module or_dtb;
  reg a,b;
  wire y;
  or_d uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("or_d.vcd");
    $dumpvars(1,or_dtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule

//gate level
//Design code
module or_g(a,b,y);
  input a,b;
  output y;
  or(y,a,b);
endmodule

//Testbench
module or_gtb;
  reg a,b;
  wire y;
  or_g uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("or_g.vcd");
    $dumpvars(1,or_gtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule
