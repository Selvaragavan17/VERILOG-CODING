//design code
module mealy(
  input in,
  input clk,
  input rst,
  output reg out);
  
  parameter a=2'b00;
  parameter b=2'b01;
  parameter c=2'b10;
  parameter d=2'b11;
  
  reg [1:0]st,nxst;
  always@(posedge clk)begin
    if(rst)
      st<=a;
    else
      st<=nxst;
  end
  
  always@(st or in)begin
    case(st)
      a:nxst=(in==0)?b:c;
      b:nxst=(in==0)?a:d;
      c:nxst=(in==0)?d:a;
      d:nxst=(in==0)?c:b;
    endcase
  end 
  
  always@(*)begin
    case(st)
      a:out=0;
      b:out=0;
      c:out=0;
      d:out=1;
    endcase
  end
endmodule

//testbench code
module mealy_tb;
  reg in;
  reg clk;
  reg rst;
  wire out;
  
  mealy uut(in,clk,rst,out);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  initial begin
    rst=1'b1;in=1'b1;#10;
    rst=1'b1;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b0;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;
    rst=1'b0;in=1'b1;#10;    
    #1;$finish;
  end
  initial begin
    $dumpfile("mealy.vcd");
    $dumpvars(1,mealy_tb);
  end
  initial begin
    $monitor("$Time=%0t|rst=%b|clk=%b|in=%b|out=%b",$time,rst,clk,in,out);
  end
endmodule
