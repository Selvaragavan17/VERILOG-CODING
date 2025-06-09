//design code
module t_flipflop(
  input clk,rst,t,
  output reg q);
  always@(posedge clk)begin
    if(rst)
      q<=0;
    else if(t)
      q<=~q;
    else
      q<=q;
  end
endmodule

//teestbench code
module t_flipflop_tb;
  reg clk,rst,t;
  wire q;
  t_flipflop uut(.clk(clk),.rst(rst),.t(t),.q(q));
 
  initial begin
    $monitor("Time=%0t | ClK=%b RST=%b T=%b  Q=%b", $time, clk, rst, t, q);
  end
  
  initial begin
    $dumpfile("t_flipflop.vcd");
    $dumpvars(1, t_flipflop_tb);
  end
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    rst = 1;       
  t = 0;
  #10;
  rst = 0;      
  t = 1; #10;
  t = 1; #10;
  t = 0; #10;
  rst = 1; #10;  
  rst = 0; t = 1; #10;
  t = 0; #10;
  $finish;
  end
endmodule

//output
Time=0 | ClK=0 RST=1 T=0  Q=x
Time=5 | ClK=1 RST=1 T=0  Q=0
Time=10 | ClK=0 RST=0 T=1  Q=0
Time=15 | ClK=1 RST=0 T=1  Q=1
Time=20 | ClK=0 RST=0 T=1  Q=1
Time=25 | ClK=1 RST=0 T=1  Q=0
Time=30 | ClK=0 RST=0 T=0  Q=0
Time=35 | ClK=1 RST=0 T=0  Q=0
Time=40 | ClK=0 RST=1 T=0  Q=0
Time=45 | ClK=1 RST=1 T=0  Q=0
Time=50 | ClK=0 RST=0 T=1  Q=0
Time=55 | ClK=1 RST=0 T=1  Q=1
Time=60 | ClK=0 RST=0 T=0  Q=1
Time=65 | ClK=1 RST=0 T=0  Q=1
testbench.sv:32: $finish called at 70 (1s)
Time=70 | ClK=0 RST=0 T=0  Q=1
