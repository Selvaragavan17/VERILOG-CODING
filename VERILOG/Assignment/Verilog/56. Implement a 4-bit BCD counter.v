//design code
module bcd_counter(
    input clk,
    input rst,
    output reg [3:0]count);

  
    always@(posedge clk or posedge rst) begin
        if(rst)
            count<=4'b0000;        
        else if (count==4'b1001)
            count<=4'b0000;       
        else
            count<=count+1'b1;   
    end
endmodule

//testbench code
module bcd_counter_tb;
    reg clk,rst;
    wire [3:0]count;

    bcd_counter uut(.clk(clk),.rst(rst),.count(count));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    initial begin
      $dumpfile("bcd_counter.vcd");
      $dumpvars(1,bcd_counter_tb);
      $display("Time\tReset\tCount");
      $monitor("%0t\t%b\t%b", $time, rst, count);

      rst = 1; #10;   
      rst = 0;        
      #100;          
      $finish;
    end
  
endmodule

//output 
Time	Reset	Count
0	1	0000
10	0	0000
15	0	0001
25	0	0010
35	0	0011
45	0	0100
55	0	0101
65	0	0110
75	0	0111
85	0	1000
95	0	1001
105	0	0000
