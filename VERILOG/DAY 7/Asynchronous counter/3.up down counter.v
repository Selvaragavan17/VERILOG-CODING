//design code
module async_updown_counter(
  input clk,rst,up,
  output reg [3:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)begin
      count<=4'b0000;
    end
    else begin
      if(up)
      count<=count+1;
      else
        count<=count-1;
    end
  end
endmodule

//testbench code
module async_updown_counter_tb;
  reg clk,rst,up;
  wire [3:0]count;
  
  async_updown_counter uut(clk,rst,up,count);
  
  initial begin
    $dumpfile("async_updown_counter_tb.vcd");
    $dumpvars(0, async_updown_counter_tb);
  end
  
  initial begin
    $monitor("Time = %0t | clk = %b | reset = %b | up = %b | count = %b ", $time, clk, rst, up, count);
  end
  
  initial begin 
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    rst=1;up=1;#10;
    rst=0;up=1;#10;
    rst=0;up=0;#10;
    rst=0;up=1;#10;
    rst=1;up=1;#10;
    rst=0;up=0;#10;
    #50;
    $finish;
  end
endmodule
