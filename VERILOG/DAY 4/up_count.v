//design code
module up_count(
  input en,clk,rst,
  output reg [3:0]out);
 	
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      out <= 4'b0000;
    end 
    else if(en) begin
     out <= out+1;
       
    end
    end
endmodule

//testbench code
module up_count_tb();
  reg en;
  reg clk,rst;
  wire [3:0]out;
  
  up_count uut(en,clk,rst,out);
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    rst = 1; en = 0; #10;
    rst = 0; en = 1; #160; 
    en = 0; #20;           
    en = 1; #30;          
    rst = 1; #10;               
    rst = 0; #20;
    $finish;
  end
  
    initial begin
      $monitor("Time = %0t \t CLK = %b RST = %b ENABLE = %b OUT = %b",$time,clk,rst,en,out );
  end
  
  initial begin
    $dumpfile("up_count.vcd");
    $dumpvars(1,up_count_tb);
  end
endmodule
