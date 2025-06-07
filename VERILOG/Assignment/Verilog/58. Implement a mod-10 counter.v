//design code
module mod10(
  input clk,rst,
  output reg [3:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)begin
      count<=4'd0;
    end
    else begin
      case(count)
        4'd0:count<=4'd1;
        4'd1:count<=4'd2;
        4'd2:count<=4'd3;
        4'd3:count<=4'd4;
        4'd4:count<=4'd5;
        4'd5:count<=4'd6;
        4'd6:count<=4'd7;
        4'd7:count<=4'd8;
        4'd8:count<=4'd9;
        4'd9:count<=4'd0;
      endcase
    end
  end
endmodule

//testbench code
module mod10_tb;
  reg clk;
  reg rst;
  wire [3:0]count;
  
  mod10 uut (clk,rst,count);
  
  initial begin
    $dumpfile("mod10.vcd");
    $dumpvars(1,mod10_tb);
    $monitor("Time=%0t|CLK=%d|RST=%d|COUNT=%d",$time,clk,rst,count);
     clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    rst=1;#10;
    rst=0;#100;
    rst=1;#10;
    rst=0;#10;
    $finish;
  end
endmodule

//output
VCD info: dumpfile mod10.vcd opened for output.
Time=0|CLK=0|RST=1|COUNT= 0
Time=5|CLK=1|RST=1|COUNT= 0
Time=10|CLK=0|RST=0|COUNT= 0
Time=15|CLK=1|RST=0|COUNT= 1
Time=20|CLK=0|RST=0|COUNT= 1
Time=25|CLK=1|RST=0|COUNT= 2
Time=30|CLK=0|RST=0|COUNT= 2
Time=35|CLK=1|RST=0|COUNT= 3
Time=40|CLK=0|RST=0|COUNT= 3
Time=45|CLK=1|RST=0|COUNT= 4
Time=50|CLK=0|RST=0|COUNT= 4
Time=55|CLK=1|RST=0|COUNT= 5
Time=60|CLK=0|RST=0|COUNT= 5
Time=65|CLK=1|RST=0|COUNT= 6
Time=70|CLK=0|RST=0|COUNT= 6
Time=75|CLK=1|RST=0|COUNT= 7
Time=80|CLK=0|RST=0|COUNT= 7
Time=85|CLK=1|RST=0|COUNT= 8
Time=90|CLK=0|RST=0|COUNT= 8
Time=95|CLK=1|RST=0|COUNT= 9
Time=100|CLK=0|RST=0|COUNT= 9
Time=105|CLK=1|RST=0|COUNT= 0
Time=110|CLK=0|RST=1|COUNT= 0
Time=115|CLK=1|RST=1|COUNT= 0
Time=120|CLK=0|RST=0|COUNT= 0
Time=125|CLK=1|RST=0|COUNT= 1
