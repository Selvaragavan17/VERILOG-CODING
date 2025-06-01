//design code
module async_down_counter(
  input clk,rst,
  output reg [3:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)
      count<=4'b1111;
    else
      count<=count-1;
  end
endmodule

//testbench coode
 module async_down_counter_tb;
  reg clk,rst;
  wire [3:0]count;
  
  async_down_counter uut(clk,rst,count);
  
  initial begin
    $dumpfile("async_down_counter_tb.vcd");
    $dumpvars(0, async_down_counter_tb);
  end
  
  initial begin
    $monitor("Time = %0t | clk = %b | reset = %b | count = %b", $time, clk, rst, count);
  end
  
  initial begin 
    clk=0;
    forever #10 clk=~clk;
  end
  
  initial begin
    rst=1;#10;
    rst=0;#10;
    rst=0;#10;
    rst=0;#10;
    rst=0;#10;
    rst=0;#10;
    rst=1;#10;
    rst=0;#10;
    #50;
    $finish;
  end
endmodule
