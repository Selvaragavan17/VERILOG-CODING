//design code
module sync_up_counter(
  input clk,rst,
  output reg [3:0]count);
  
  always@(posedge clk)begin
    if(rst)
      count<=4'b0010;
    else
      count<=count+1;
  end
endmodule

//testbench code
module sync_up_counter_tb;
  reg clk,rst;
  wire [3:0]count;
  
  sync_up_counter uut(clk,rst,count);
  
  initial begin
    $dumpfile("sync_up_counter_tb.vcd");
    $dumpvars(0, sync_up_counter_tb);
  end
  
  initial begin
    $monitor("Time = %0t | clk = %b | reset = %b | count = %b", $time, clk, rst, count);
  end
  
  initial begin 
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    rst=1;#10;
    rst=0;#10;
    rst=0;#10;
    rst=0;#10;
    rst=1;#10;
    rst=0;#10;
    #50;
    $finish;
  end
endmodule
