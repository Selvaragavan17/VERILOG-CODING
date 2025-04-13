//design code
module up_down_count(
  input en,
  input up_count,
  input clk,rst,
  output reg [3:0]count); 	
  always @(posedge clk or posedge rst) begin
    if (rst) 
      count <= 4'b0000;
     
    else if(en) begin
      if(up_count) 
        count <= count+1;
      else
        count <= count-1;  
    end
  end

endmodule

//testbench code
module up_down_count_tb();
  reg en;
  reg up_count;
  reg clk,rst;
  wire [3:0]count;
  
  up_down_count uut(en,up_count,clk,rst,count);
  
  initial begin
    clk = 0;
    forever #5clk = ~clk;
  end
  initial begin
    rst = 1; en = 0;
    up_count = 1;#10;
    rst = 0; en = 1;
    up_count = 1;#10;
    rst = 0; en = 1;
    up_count = 0;#10;
    rst = 0; en = 1;
    up_count = 1;#10;
    rst = 0; en = 1;
    up_count = 1;#10;
    
    $finish;
  end
  initial begin
    $dumpfile("up_down_count.vcd");
    $dumpvars(1,up_down_count_tb);
  end
  initial begin
    $monitor("Time = %0t  CLK = %b RST = %b ENABLE = %b UP_COUNT = %b COUNT = %b",$time,clk,rst,en,up_count,count );
  end
endmodule
