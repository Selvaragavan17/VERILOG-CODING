//design code
module glitch_free_clk(
  input clk,
  input en,
  output reg gate_clk);
  
  reg en_latched;
  
  always@(clk or en)begin
    if(!clk)
      en_latched=en;
  end
  
  assign gate_clk= clk&en_latched;
endmodule

//testbench code
module glitch_free_clk_tb;
  reg clk;
  reg en;
  wire gate_clk;
  
  glitch_free_clk uut (clk,en,gate_clk);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    $dumpfile("glitch_free_clk.vcd");
    $dumpvars(1,glitch_free_clk_tb);
  end
  
  initial begin
    $display("Time\tclk\ten\tgate_clk");
    $monitor("%0t\t%b\t%b\t%b",$time,clk,en,gate_clk);
  end
  
  initial begin
    en=1;#10;
    en=0;#40;
    en=0;#10;
    en=1;#20;
    en=0;#20;
    en=1;#20;
    $finish;
  end
endmodule

//output
Time	clk	en	gate_clk
0	0	1	0
5	1	1	1
10	0	0	0
15	1	0	0
20	0	0	0
25	1	0	0
30	0	0	0
35	1	0	0
40	0	0	0
45	1	0	0
50	0	0	0
55	1	0	0
60	0	1	0
65	1	1	1
70	0	1	0
75	1	1	1
80	0	0	0
85	1	0	0
90	0	0	0
95	1	0	0
100	0	1	0
105	1	1	1
110	0	1	0
115	1	1	1
testbench.sv:32: $finish called at 120 (1s)
120	0	1	0
