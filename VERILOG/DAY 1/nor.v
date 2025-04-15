//Design code
module nor_b(a,b,y);
  input wire a,b;
  output reg y;
  always@(*)
    begin
      if(~(a|b))
        y=1'b1;
      else
        y=1'b0;
    end
endmodule

//Testbench
module nor_btb;
  reg a,b;
  wire y;
  nor_b uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("nor_b.vcd");
    $dumpvars(1,nor_btb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule

//dataflow
//Design code
module nor_d(a,b,y);
  input wire a,b;
  output reg y;
  assign y=~(a|b);
endmodule

//Testbench
module nor_dtb;
  reg a,b;
  wire y;
  nor_d uut(.a(a),.b(b),.y(y));
  initial begin
    a=0;b=0;#5;
    a=0;b=1;#5;
    a=1;b=0;#5;
    a=1;b=1;#5;
    $finish;
  end
  initial begin
    $dumpfile("nor_d.vcd");
    $dumpvars(1,nor_dtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule

//gate level
//Design code
module nor_g(a,b,y);
  input wire a,b;
  output reg y;
  nor(y,a,b);
endmodule

//Testbench
module nor_gtb;
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
    $dumpfile("nor_g.vcd");
    $dumpvars(1,nor_gtb);
  end
  initial begin
    $monitor("Time=%0t | a=%b | b=%b | y=%b",$time,a,b,y);
  end
endmodule
