//design code
module mul_div(
  input [3:0]a,b,
  output reg [170]mul,div);
  
  function[7]mul_f;
    input [3:0]x,y;
    mul_f=x*y;
  endfunction
  
  function [7:0]div_f;
    input [3:0]x,y;
    div_f=x/y;
  endfunction
  
  always@(*)begin
    mul=mul_f(a,b);
    div=div_f(a,b);
  end
endmodule

//testbench code
module mul_div_tb;
  reg [3:0]a,b;
  wire [7:0]mul,div;
  
  mul_div uut(a,b,mul,div);
  
  initial begin
    $monitor("Time=%0t|A=%d|B=%d|MUL=%d|DIV=%0.2f",$time,a,b,mul,div);
  end
  
  initial begin
    $dumpfile("mul_div.vcd");
    $dumpvars(1,mul_div_tb);
  end
  
  initial begin
    a=4'd12;b=4'd2;#10;
    a=4'd12;b=4'd6;#10;
    a=4'd8;b=4'd4;#10;
    a=4'd2;b=4'd2;#10;
    a=4'd10;b=4'd5;#10;
    a=4'd15;b=4'd4;#10;
  end
endmodule
