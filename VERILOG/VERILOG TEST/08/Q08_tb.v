//testbench code
module fsm_more_1_tb;
  reg clk;
  reg rst;
  reg in;
  wire out;
  
  fsm_more_1 uut(clk,rst,in,out);
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
    
  
  initial begin
    $dumpfile("fsm_more_1.vcd");
    $dumpvars(1,fsm_more_1_tb);
  end
  
  initial begin
    $monitor("Time=%0t|clk=%b|rst=%b|in=%b|out=%b",$time,clk,rst,in,out);
  end
  
  initial begin
    rst=1;in=1;#10;
    rst=0;
    in=1;#10;
    in=0;#10;
    in=0;#10;
    in=0;#10;
    in=0;#10;
    in=0;#10;
    in=0;#10;
    in=0;#10;
    in=0;#10;
    in=1;#10;
    $finish;
  end
endmodule

//output
Time=0|clk=0|rst=1|in=1|out=0
Time=5|clk=1|rst=1|in=1|out=0
Time=10|clk=0|rst=0|in=1|out=0
Time=15|clk=1|rst=0|in=1|out=0
Time=20|clk=0|rst=0|in=0|out=0
Time=25|clk=1|rst=0|in=0|out=0
Time=30|clk=0|rst=0|in=0|out=0
Time=35|clk=1|rst=0|in=0|out=0
Time=40|clk=0|rst=0|in=0|out=0
Time=45|clk=1|rst=0|in=0|out=0
Time=50|clk=0|rst=0|in=0|out=0
Time=55|clk=1|rst=0|in=0|out=0
Time=60|clk=0|rst=0|in=0|out=0
Time=65|clk=1|rst=0|in=0|out=0
Time=70|clk=0|rst=0|in=0|out=0
Time=75|clk=1|rst=0|in=0|out=0
Time=80|clk=0|rst=0|in=0|out=0
Time=85|clk=1|rst=0|in=0|out=0
Time=90|clk=0|rst=0|in=0|out=0
Time=95|clk=1|rst=0|in=0|out=0
Time=100|clk=0|rst=0|in=1|out=0
Time=105|clk=1|rst=0|in=1|out=1
testbench.sv:38: $finish called at 110 (1s)
Time=110|clk=0|rst=0|in=1|out=1
