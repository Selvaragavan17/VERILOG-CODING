//design code
module divisible_5(
  input in,
  input clk,
  input rst,
  output reg out);
  
  parameter a=3'b000;
  parameter b=3'b001;
  parameter c=3'b010;
  parameter d=3'b011;
  parameter e=3'b100;
  parameter f=3'b101;
  
  reg [2:0]st,nxst;
  always@(posedge clk)begin
    if(rst)
      st<=a;
    else
      st<=nxst;
  end
  
  always@(st or in)begin
    case(st)
      a:nxst=(in==0)?a:b;
      b:nxst=(in==0)?c:d;
      c:nxst=(in==0)?e:f;
      d:nxst=(in==0)?b:c;
      e:nxst=(in==0)?d:e;
      f:nxst=(in==0)?a:b;
    endcase
  end 
  
  always@(*)begin
    case(st)
      a:out=0;
      b:out=0;
      c:out=0;
      d:out=0;
      e:out=0;
      f:out=1;
    endcase
  end
  
endmodule

//testbench code
module divisible_5_tb;
  reg in;
  reg clk;
  reg rst;
  wire out;
  
  divisible_5 uut(in,clk,rst,out);
  
  initial begin
    clk=0;
  forever #5 clk=~clk;
  end
  
   initial begin
     $dumpfile("divisible_5.vcd");
     $dumpvars(0,divisible_5_tb);
  end
  
  initial begin
    rst=1; in=1; #10;
    rst=0;#10;
    in=1'b1;#10;
    in=1'b0;#10;
    in=1'b1;#10;
    in=1'b1;#10;
    in=1'b1;#10;
    in=1'b1;#10;
    in=1'b0;#10;
    in=1'b1;#10;
    in=1'b0;#10;
    $finish;
  end
  
  initial  begin
    $monitor("Time=%0t | clk=%b | rst=%b | input=%b | output=%b",$time,clk,rst,in,out);
  end
  
endmodule
