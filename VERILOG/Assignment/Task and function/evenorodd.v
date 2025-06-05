//design code
module evenorodd(
  input [3:0]a,
  input [1:0]sel,
  output reg [3:0]result);
  
  function [3:0]evod;
    input [3:0]x;
    input [1:0]s;
    if(sel==0)
      evod=x*2;
    else
      evod=x*2+1;
  endfunction
  
  always@(*)begin
    result=evod(sel,a);
  end
  
endmodule

//testbench code
module evenorodd_tb;
  reg [3:0]a;
  reg [1:0]sel;
  wire [3:0]result;
  
  evenorodd uut(a,sel,result);
  
  initial begin
    $monitor("A=%b|SEL=%b|RESULT=%b",a,sel,result);
  end
  
  initial begin
    $dumpfile("evenorodd.vcd");
    $dumpvars(1,evenorodd_tb);
  end
  
  initial begin
    a=4'b0001;sel=01;#10;
    a=4'b1011;sel=10;#10;
    a=4'b1010;sel=00;#10;
    a=4'b0101;sel=11;#10;
    a=4'b1111;sel=01;#10;
  end
endmodule
