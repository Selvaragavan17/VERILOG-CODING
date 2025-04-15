//Design code
module and_d(a,b,y);
  input a,b;
  output y;
  and(y,a,b);
endmodule

//Testbench
module and_dtb;
  reg a,b;
  wire y;
  and_d uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("and_d.vcd");
    $dumpvars(1,and_dtb);
  end
  initial begin
    $monitor("Time=%0t  a=%b  b=%b  y=%b",$time,a,b,y);
  end
endmodule
