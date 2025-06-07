//design code
module up_counter_4bit(
  input clk,rst,
  output reg [3:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)
      count<=4'b0000;
  else 
    count<=count+1'b1;
  end
endmodule

//testbench code
module up_counter_4bit_tb;
    reg clk, rst;
    wire [3:0] count;

    up_counter_4bit uut (.clk(clk),.rst(rst),.count(count));
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
      $dumpfile("up_counter_4bit.vcd");
      $dumpvars(1,up_counter_4bit_tb);
      $display("Time\tReset\tCount");
      $monitor("%0t\t%b\t%0d", $time, rst, count);
        rst = 1; #10;  
        rst = 0;#100;
        rst=1;#40;
        rst=0;#10;
      $finish;

    end
endmodule

//output
Time	Reset	Count
  0	1	0
10	0	0
15	0	1
25	0	2
35	0	3
45	0	4
55	0	5
65	0	6
75	0	7
85	0	8
95	0	9
105	0	10
110	1	0
150	0	0
155	0	1
