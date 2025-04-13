//design code
module johnson_counter(
  input clk,rst,
  output reg [3:0]count);
 	
  always @(posedge clk or posedge rst) begin
    if(rst)
      count <= 4'b1010;
    else
      count <= {~count[3],count[3:1]};
  end
endmodule

//testbench code
module johnson_counter_tb;
  reg clk,rst;
  wire [3:0]count;
  johnson_counter uut(.clk(clk),.rst(rst),.count(count));
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    clk = 0;
    rst = 1; #10;
    rst = 0; #10;
    $finish;
  end
  
  initial begin
    $dumpfile("johnson_counter.vcd");
    $dumpvars(1,johnson_counter_tb);
  end
  
  initial begin
    $monitor("Time = %0t  Reset = %b  Out = %b", $time, rst, count);
  end

endmodule
