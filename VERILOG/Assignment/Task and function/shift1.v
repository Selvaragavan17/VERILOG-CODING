//design code
module shift1(
  input [3:0]a,
  output reg[3:0]result);
  
  function [3:0]shift_f;
    input [3:0]x;
    shift_f=x>>1;
  endfunction
  
  always@(*)begin
    result=shift_f(a);
  end
  
endmodule

//testbench code
module shift1_tb;
  reg [3:0]a;
  wire [3:0]result;
  
  shift1 uut(a,result);
  
  initial begin
    $monitor("Time=%0t|A=%b|RESULT=%b",$time,a,result);
  end
  
  initial begin
    a=4'b0001;#10;
    a=4'b1000;#10;
    a=4'b1101;#10;
    a=4'b1001;#10;
    a=4'b1111;#10;
  end
endmodule
