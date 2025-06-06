//design code
module mod6(
  input clk,
  input rst,
  output reg [2:0]count);
  
  always@(posedge clk or posedge rst)begin
    if(rst)begin
      count<=3'b010;
    end
    else if(count==3'b101)
      count<=3'b000;
    else
      count<=count+1;
  end
endmodule

//testbench code
module mod6_tb;
  reg clk;
  reg rst;
  wire [2:0]count;
  
  mod6 uut(clk,rst,count);
  
  initial begin
    $dumpfile("mod6.vcd");
    $dumpvars(1,mod6_tb);
    $monitor("clk=%b|rst=%b|count=%d",clk,rst,count);
  end
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    rst = 1;
        #10 rst = 0;

        #100;
        $finish;
    end
endmodule
