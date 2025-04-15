//Design code
module not_b(a,y);
  input wire a;
  output reg y;
  always@(*)
   begin
     if(a==1'b0)
       y=1'b1;
     else
       y=1'b0;
   end
endmodule

//Testbench
module not_btb;
  reg a;
  wire y;
not_b uut(.a(a),.y(y));
  initial begin
   a=0;#5;
   a=1;#5;
  end
  initial begin
    $dumpfile("not_b.vcd");
    $dumpvars(0,not_btb);
  end
  initial begin
    $monitor("$Time=%0t a=%b y=%b",$time,a,y);
  end
endmodule


//dataflow
//Design code 
module not_d(a,y);
  input wire a;
  output reg y;
  assign y=~a;
endmodule

//Testbench
module not_dtb;
  wire y;
  reg a;
not_d uut(.a(a),.y(y));
  initial begin
   a=0;#5;
   a=1;#5;
  end
  initial begin
    $dumpfile("not_d.vcd");
    $dumpvars(0,not_dtb);
  end
  initial begin
    $monitor("$Time=%0t a=%b y=%b",$time,a,y);
  end
endmodule

//gate level
//Design code
module not_g(a,y);
  input a;
  output reg y;
  not(y,a);
endmodule

//Testbench
module not_gtb;
  wire y;
  reg a;
not_g uut(.a(a),.y(y));
  initial begin
   a=0;#5;
   a=1;#5;
  end
  initial begin
    $dumpfile("not_g.vcd");
    $dumpvars(0,not_gtb);
  end
  initial begin
    $monitor("$Time=%0t a=%b y=%b",$time,a,y);
  end
endmodule
  
