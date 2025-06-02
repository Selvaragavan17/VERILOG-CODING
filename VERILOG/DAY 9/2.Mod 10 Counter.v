//design code
module mod_10_counter(
  input clk,
  input rst,
  output reg[3:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)
      count<=4'b0000;
    else if(count==4'b1010)
      count<=4'b000;
    else 
      count<=count+1;
  end
endmodule

//testbench codee
`timescale 1ns / 1ps
module mod_10_counter_tb;
  reg clk;
  reg rst;
  wire [3:0]count;
  
  mod_10_counter uut(clk,rst,count);
  
  initial begin
    $monitor("Time=%0t|clk=%d|rst=%d|Count=%d",$time,clk,rst,count);
  end
  
  initial begin
    $dumpfile("mod_10_counter.vcd");
    $dumpvars(1,mod_10_counter_tb);
  end

  
  always #5 clk = ~clk;

    initial begin
        clk = 0;
      rst=1;#10;
      rst=0;#100;
      rst=1;#10;
      rst=0;#50;
      rst=1;#10;
      $finish;

    end
endmodule
