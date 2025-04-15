//Design code
module xnor_b(a,b,y);
  input wire a,b;
  output reg y;
  always@(*)
    begin
      if(~(a^b))
        y=1'b1;
      else
        y=1'b0;
    end
endmodule

//Testbench
module xnor_btb;
  reg a,b;
  wire y;
  xnor_b uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("xnor_b.vcd");
    $dumpvars(1,xnor_btb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule

//dataflow
//Design code
module xnor_d(a,b,y);
  input wire a,b;
  output reg y;
  assign y=~(a^b);
endmodule

//Testbench
module xnor_dtb;
  reg a,b;
  wire y;
  xnor_d uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("xnor_d.vcd");
    $dumpvars(1,xnor_dtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule

//gate level
//Design code
module xnor_g(a,b,y);
  input wire a,b;
  output reg y;
  xnor(y,a,b);
endmodule

//Testbench
module xnor_gtb;
  reg b,a;
  wire y;
  xnor_g uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("xnor_g.vcd");
    $dumpvars(1,xnor_gtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule
