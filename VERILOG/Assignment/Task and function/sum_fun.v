//design code
module sum_fun(
  input [3:0]a,b,
  output reg[3:0]result);
  
  function [3:0]add;
    input [3:0]x,y;
    add=x+y;
  endfunction
  
  always@(*)begin
    result=add(a,b);
  end
  
endmodule

//testbench code
module sum_fun_tb;
  reg [3:0]a,b;
  wire [3:0]result;
  
  sum_fun uut(a,b,result);
  
  initial begin
    $monitor("Time=%0t|A=%b|B=%b|RESULT=%b",$time,a,b,result);
  end
  
  initial begin
    a=4'b0001;b=4'b1001;#10;
    a=4'b1000;b=4'b0100;#10;
    a=4'b1101;b=4'b0101;#10;
    a=4'b1001;b=4'b1100;#10;
    a=4'b1111;b=4'b1001;#10;
  end
endmodule
