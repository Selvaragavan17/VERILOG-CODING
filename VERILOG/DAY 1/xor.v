//Design code
module xor_d(a,b,y);
  input wire a,b;
  output reg y;
  assign y=a^b;
endmodule

//Testbench
module xor_dtb;
  reg a,b;
  wire y;
  xor_d uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("xor_d.vcd");
    $dumpvars(1,xor_dtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule

//behavioural
//Design code
module xor_b(a,b,y);
  input wire a,b;
  output reg y;
  always@(*)
   begin
     if(a^b)
       y=1'b1;
     else
       y=1'b0;
   end
endmodule

//Testbench
module xor_btb;
  reg b,a;
  wire y;
  xor_b uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("xor_b.vcd");
    $dumpvars(1,xor_btb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule

//gate level
//Design code
module xor_g(a,b,y);
  input wire a,b;
  output reg y;
  xor(y,a,b);
endmodule

//Testbench
module xor_gtb;
  reg a,b;
  wire y;
  xor_g uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("xor_g.vcd");
    $dumpvars(1,xor_gtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule
  
