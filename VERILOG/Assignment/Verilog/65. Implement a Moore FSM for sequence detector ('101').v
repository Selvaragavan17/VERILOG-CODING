//design code
module mealy_101(
  input clk,
  input rst,
  input in,
  output reg out);
  
  parameter s0=2'b00;
  parameter s1=2'b01;
  parameter s2=2'b10;
  parameter s3=2'b11;
  
  reg[1:0]st,nxst;
  
  always@(posedge clk)begin
    if(rst)
      st<=s0;
    else
      st<=nxst;
  end
  
  always@(st or in)begin
    case(st)
      s0:nxst=in?s1:s0;
      s1:nxst=in?s1:s2;
      s2:nxst=in?s3:s0;
      s3:nxst=in?s1:s2;
    endcase
  end
  
  always@(*)begin
    case(st)
      s0:out=0;
      s1:out=0;
      s2:out=0;
      s3:out=1;
    endcase
  end
endmodule

//testbench code
module mealy_101_tb;
  reg clk;
  reg rst;
  reg in;
  wire out;
  
  mealy_101 uut(clk,rst,in,out);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    $monitor("Time=%0t|clk=%b|rst=%b|in=%b|out=%b",$time,clk,rst,in,out);
    $dumpfile("mealy_101.vcd");
    $dumpvars(1,mealy_101_tb);
  end
  
  initial begin
    rst=1;#10;
   rst=0;in=1;#10;
   rst=0;in=0;#10;
   rst=0;in=1;#10;
   rst=0;in=0;#10;
   rst=0;in=1;#10;
   rst=0;in=0;#10;
   rst=0;in=1;#10;
   rst=1;in=1;#10;
   rst=0;in=1;#10;
    $finish;
  end
endmodule

//output
Time=0|clk=0|rst=1|in=x|out=x
Time=5|clk=1|rst=1|in=x|out=0
Time=10|clk=0|rst=0|in=1|out=0
Time=15|clk=1|rst=0|in=1|out=0
Time=20|clk=0|rst=0|in=0|out=0
Time=25|clk=1|rst=0|in=0|out=0
Time=30|clk=0|rst=0|in=1|out=0
Time=35|clk=1|rst=0|in=1|out=1
Time=40|clk=0|rst=0|in=0|out=1
Time=45|clk=1|rst=0|in=0|out=0
Time=50|clk=0|rst=0|in=1|out=0
Time=55|clk=1|rst=0|in=1|out=1
Time=60|clk=0|rst=0|in=0|out=1
Time=65|clk=1|rst=0|in=0|out=0
Time=70|clk=0|rst=0|in=1|out=0
Time=75|clk=1|rst=0|in=1|out=1
Time=80|clk=0|rst=1|in=1|out=1
Time=85|clk=1|rst=1|in=1|out=0
Time=90|clk=0|rst=0|in=1|out=0
Time=95|clk=1|rst=0|in=1|out=0
