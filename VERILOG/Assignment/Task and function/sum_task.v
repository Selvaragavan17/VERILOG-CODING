//design code
module sum_task(
  input [3:0]a,b,
  output reg [3:0]result);
  
  task sum;
    input[3:0]x,y;
    output [3:0]sum;
    sum=x+y;
  endtask
  
  always@(*)begin
    sum(a,b,result);
  end
  
endmodule

//testbench code
module sum_task_tb;
  reg [3:0]a,b;
  wire [3:0]result;
  
  sum_task uut(a,b,result);
  
  initial begin
    $monitor("Time=%0t|A=%b|B=%b|RESULT=%b",$time,a,b,result);
  end
  
  initial begin
    $dumpfile("sum_task.vcd");
    $dumpvars(1,sum_task_tb);
  end
  
  initial begin
    a=4'b0001;b=4'b0101;#10;
    a=4'b1001;b=4'b1111;#10;
    a=4'b1101;b=4'b0100;#10;
    a=4'b0011;b=4'b1101;#10;
  end
endmodule
