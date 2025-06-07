//design code
module down_counter_4bit(
  input clk,rst,
  output reg [3:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)
      count<=4'b1011;
  else 
    count<=count-1'b1;
  end
endmodule

//testbench code
module down_counter_4bit_tb;
    reg clk, rst;
    wire [3:0] count;

  down_counter_4bit uut (clk,rst,count);
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
      $dumpfile("down_counter_4bit.vcd");
      $dumpvars(1,down_counter_4bit_tb);
      $display("Time\tReset\tCount");
      $monitor("%0t\t%b\t%0d", $time, rst, count);
        rst = 1; #20;  
        rst = 0;#100;
        rst=1;#40;
        rst=0;#10;
      $finish;

    end
endmodule

//output 
Time	Reset	Count
  0	1	11
20	0	11
25	0	10
35	0	9
45	0	8
55	0	7
65	0	6
75	0	5
85	0	4
95	0	3
105	0	2
115	0	1
120	1	11
160	0	11
165	0	10
